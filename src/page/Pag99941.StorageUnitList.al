page 99941 "Storage Units"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Storage Unit";
    CardPageId = "Storage Unit";
    Editable = false;
    Caption = 'Storage Units';

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
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Building No. this storage unit belongs to.';
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
                field("Average Deposit"; Rec."Average Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the average deposit for this storage unit.';
                }
            }
        }
    }
}