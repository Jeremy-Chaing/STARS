page 99943 "Storage Journals"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Storage Journal";
    Caption = 'Storage Journals';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                    //Visible = false;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';

                    trigger OnValidate()
                    var
                        RentalContract: Record "Rental Contract";
                    begin
                        if Rec."Contract No." <> '' then begin
                            RentalContract.Get(Rec."Contract No.");
                            Rec."Storage Unit No." := RentalContract."Storage Unit No.";
                            Rec."Customer No." := RentalContract."Customer No.";
                            if Rec."Entry Type" = Rec."Entry Type"::"Deposits" then begin
                                Rec.Amount := RentalContract."Deposit Amount";
                            end
                            else if Rec."Entry Type" = Rec."Entry Type"::"Rental Fees" then begin
                                Rec.Amount := RentalContract."Monthly Rental Fee";
                            end
                            else if Rec."Entry Type" = Rec."Entry Type"::"Return Deposits" then begin
                                Rec.Amount := -RentalContract."Deposit Amount";
                            end;
                        end
                        else
                            Rec."Storage Unit No." := '';
                    end;
                }
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the journal entry.';
                }
                field("Date of Transaction"; Rec."Date of Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction date.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the journal entry.';
                    trigger OnValidate()
                    var
                        RentalContract: Record "Rental Contract";
                    begin
                        RentalContract.Get(Rec."Contract No.");
                        if Rec."Entry Type" = Rec."Entry Type"::"Deposits" then begin
                            Rec.Amount := RentalContract."Deposit Amount";
                        end
                        else if Rec."Entry Type" = Rec."Entry Type"::"Rental Fees" then begin
                            Rec.Amount := RentalContract."Monthly Rental Fee";
                        end
                        else if Rec."Entry Type" = Rec."Entry Type"::"Return Deposits" then begin
                            Rec.Amount := -RentalContract."Deposit Amount";
                        end;
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the journal entry.';
                }
                field("Job Queue Created"; Rec."Job Queue Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the job queue was created.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = New;
                ToolTip = 'Create a new journal entry.';

                trigger OnAction()
                begin
                    Clear(Rec);
                    Rec.Insert(true);
                end;
            }
        }
        area(Processing)
        {
            group(Manage)
            {
                Caption = 'Manage';

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post Selected';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Post the selected journal entries. Use Ctrl+Click to select multiple entries.';
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        StorageJournal: Record "Storage Journal";
                        StoragePostBatch: Codeunit "Stor. Jnl. Line-Post Batch";
                        ConfirmQst: Label 'Do you want to post the selected journal lines?';
                        NothingSelectedErr: Label 'Please select the lines you want to post.';
                    begin
                        CurrPage.SetSelectionFilter(StorageJournal);
                        if StorageJournal.IsEmpty then
                            Error(NothingSelectedErr);

                        if not Confirm(ConfirmQst) then
                            exit;

                        StoragePostBatch.Run(StorageJournal);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
}