page 99941 "Storage Unit List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Storage Unit";
    CardPageId = "Storage Unit Card";
    Editable = false;
    Caption = 'Storage Unit List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
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
                field("Total Rental Income"; Rec."Total Rental Income")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total rental income received for this storage unit.';
                }
                field("Current Deposit"; Rec."Current Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current deposit held for this storage unit.';
                }
            }
        }
    }
}