page 99954 "Storage Journal Worksheet"
{
    PageType = Worksheet;
    SourceTable = "Storage Journal";
    Caption = 'Storage Journal Worksheet';
    ApplicationArea = All;
    UsageCategory = Tasks;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            group(Control1900000001)
            {
                Caption = '';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Batch Name';
                    Lookup = true;
                    DrillDown = true;
                    LookupPageId = "Storage Journal Batches";
                    TableRelation = "Storage Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        CurrentJnlBatchName := Rec."Journal Batch Name";
                        SetControlAppearance();
                        UpdateBatch();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        StorageJnlBatch: Record "Storage Journal Batch";
                        JnlSelected: Boolean;
                    begin
                        StorageJnlBatch.FilterGroup(2);
                        StorageJnlBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                        StorageJnlBatch.FilterGroup(0);
                        JnlSelected := Page.RunModal(Page::"Storage Journal Batches", StorageJnlBatch) = Action::LookupOK;
                        if JnlSelected then begin
                            Text := StorageJnlBatch.Name;
                            CurrentJnlBatchName := StorageJnlBatch.Name;
                            UpdateBatch();
                            exit(true);
                        end;
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                        else begin
                            Rec."Storage Unit No." := '';
                            Rec."Customer No." := '';
                        end;
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
                        if Rec."Contract No." <> '' then begin
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
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the journal entry.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Manage)
            {
                Caption = 'Manage';
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Post the selected journal entries.';
                    ShortcutKey = 'F9';

                    trigger OnAction()
                    var
                        StorageJournal: Record "Storage Journal";
                        StoragePostBatch: Codeunit "Stor. Jnl. Line-Post Batch";
                        ConfirmQst: Label 'Do you want to post the journal lines?';
                    begin
                        if not Confirm(ConfirmQst) then
                            exit;

                        StorageJournal.Copy(Rec);
                        StoragePostBatch.Run(StorageJournal);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Journal Template Name" = '' then
            Rec."Journal Template Name" := 'STORAGE';
        CurrentJnlBatchName := Rec."Journal Batch Name";
        SetControlAppearance();
        UpdateBatch();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Journal Template Name" := 'STORAGE';
        Rec."Journal Batch Name" := CurrentJnlBatchName;
        Rec."Date of Transaction" := WorkDate();
    end;

    var
        CurrentJnlBatchName: Code[10];

    local procedure SetControlAppearance()
    begin
        // Add any control appearance logic here if needed
    end;

    local procedure UpdateBatch()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Journal Template Name", 'STORAGE');
        Rec.SetRange("Journal Batch Name", CurrentJnlBatchName);
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;
}