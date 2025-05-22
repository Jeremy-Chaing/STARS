page 99950 "Rental Contract Card"
{
    PageType = Card;
    SourceTable = "Rental Contract";
    Caption = 'Rental Contract Card';
    Editable = true;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                    //當Storage Unit No.被改變時，顯示所選Storage Unit的Square Footage 
                    trigger OnValidate()
                    var
                        StorageUnit: Record "Storage Unit";
                    begin
                        if Rec."Storage Unit No." <> '' then begin
                            StorageUnit.Get(Rec."Storage Unit No.");
                            Rec."Storage Unit Square footage" := StorageUnit."Square Footage";
                            Rec."Monthly Rental Fee" := StorageUnit."Monthly Rental Fee"
                        end;
                    end;


                }
                field("Storage Unit Square footage"; Rec."Storage Unit Square footage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit square footage.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the rental contract.';
                }
            }
            group(Details)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the contract.';
                    ShowMandatory = true;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the contract.';
                    ShowMandatory = true;
                }
                field("Monthly Rental Fee"; Rec."Monthly Rental Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the monthly rental fee.';
                    Editable = false;
                }
                field("Deposit Amount"; Rec."Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit amount.';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        StorageUnit: Record "Storage Unit";

                    begin
                        StorageUnit.Get(Rec."Storage Unit No.");
                        if StorageUnit."Square Footage" * 5 < Rec."Deposit Amount" then
                            Error('Deposit Amount cannot be more than 5 times the square footage of the storage unit.');
                    end;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the contract.';
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CreateJournal)
            {
                ApplicationArea = All;
                Caption = 'Create Journal';
                //Image = NewJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Creates a new storage journal entry for this contract.';

                trigger OnAction()
                var
                    StorageJournal: Record "Storage Journal";
                    ConfirmMsg: Label '確定要為合約 %1 建立押金紀錄嗎?';
                    DuplicateErr: Label '合約 %1 已經有押金紀錄存在。';
                begin
                    // 檢查是否已存在相同合約編號的押金紀錄
                    StorageJournal.SetRange("Contract No.", Rec."Contract No.");
                    StorageJournal.SetRange("Entry Type", Enum::"Storage Journal Entry Type"::"Deposits");
                    if StorageJournal.FindFirst() then
                        Error(DuplicateErr, Rec."Contract No.");

                    // 顯示確認對話框
                    if not Confirm(ConfirmMsg, false, Rec."Contract No.") then
                        exit;

                    StorageJournal.Init();
                    StorageJournal."Contract No." := Rec."Contract No.";
                    StorageJournal."Storage Unit No." := Rec."Storage Unit No.";
                    StorageJournal."Customer No." := Rec."Customer No.";
                    //StorageJournal.Description := 'Rental Contract Deposit';
                    StorageJournal."Date of Transaction" := Today();
                    StorageJournal.Amount := Rec."Deposit Amount";
                    StorageJournal."Entry Type" := Enum::"Storage Journal Entry Type"::"Deposits";
                    //StorageJournal."Payment Date" := Today();

                    StorageJournal.Insert();
                end;
            }
        }
    }
}