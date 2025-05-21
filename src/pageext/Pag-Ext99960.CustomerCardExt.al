pageextension 99960 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Total Outstanding Amount"; Rec."Total Outstanding Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total outstanding amount for storage rentals.';
            }
            field("Active Storage Units"; Rec."Active Storage Units")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of active storage units rented by this customer.';
            }
            field("Average Deposit"; Rec."Average Deposit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the average deposit amount for this customer''s storage units.';
            }
        }
        addlast(Invoicing)
        {
            field("Auto Post Journals"; Rec."Auto Post Journals")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether storage journals should be automatically posted for this customer.';
            }
        }
        addlast(factboxes)
        {
            part(StorageUnits; "Customer Storage Units")
            {
                ApplicationArea = All;
                SubPageLink = "Customer No." = field("No.");
            }
        }
    }
}