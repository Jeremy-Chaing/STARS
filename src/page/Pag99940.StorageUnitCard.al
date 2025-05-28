page 99940 "Storage Unit"
{
    PageType = Card;
    SourceTable = "Storage Unit";
    Caption = 'Storage Unit';

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
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
            group(Statistics)
            {
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