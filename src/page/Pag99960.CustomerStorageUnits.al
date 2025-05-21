page 99960 "Customer Storage Units"
{
    PageType = ListPart;
    SourceTable = "Rental Contract";
    Caption = 'Storage Units';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Units)
            {
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the rental started.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the rental ends.';
                }
                field("Monthly Rental Fee"; Rec."Monthly Rental Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the monthly rental fee.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the contract.';
                }
            }
        }
    }
}