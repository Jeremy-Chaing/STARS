page 99944 "Storage Ledger Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Storage Ledger Entry";
    //Editable = false;
    Caption = 'Storage Ledger Entries';

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
                    ToolTip = 'Specifies the description of the ledger entry.';
                }
                field("Date of Transaction"; Rec."Date of Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction date.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the ledger entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the ledger entry.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
            }
        }
    }
}