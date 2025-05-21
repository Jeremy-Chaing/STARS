page 99940 "Storage Unit Card"
{
    PageType = Card;
    SourceTable = "Storage Unit";
    Caption = 'Storage Unit Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                }
                field("Building Identifier"; Rec."Building Identifier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the building identifier this storage unit belongs to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the storage unit.';
                }
            }
            group(Details)
            {
                field("Square Footage"; Rec."Square Footage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the square footage of the storage unit.';
                }
                field("Monthly Rental Fee"; Rec."Monthly Rental Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the monthly rental fee for this storage unit.';
                }
            }
        }
    }
}