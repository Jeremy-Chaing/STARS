page 99943 "Storage Journal List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Storage Journal";
    Caption = 'Storage Journal List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';
                }
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the journal entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the journal entry.';
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment date.';
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
                        RecRef: RecordRef;
                        ConfirmQst: Label 'Do you want to post the selected journal lines?';
                        NothingSelectedErr: Label 'Please select the lines you want to post.';
                    begin
                        CurrPage.SetSelectionFilter(StorageJournal);
                        if StorageJournal.IsEmpty then
                            Error(NothingSelectedErr);

                        if not Confirm(ConfirmQst) then
                            exit;

                        StoragePostBatch.Run(Rec);

                        Message('The selected journal lines have been posted successfully.');
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
}