page 99950 "Rental Contract Card"
{
    PageType = Card;
    SourceTable = "Rental Contract";
    Caption = 'Rental Contract Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Storage Unit No."; Rec."Storage Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storage unit number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the rental contract.';
                }
            }
            group(Details)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the contract.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the contract.';
                }
                field("Monthly Rental Fee"; Rec."Monthly Rental Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the monthly rental fee.';
                }
                field("Deposit Amount"; Rec."Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit amount.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the contract.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateJournal)
            {
                ApplicationArea = All;
                Caption = 'Create Journal';
                //Image = NewJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Creates a new storage journal entry for this contract.';

                trigger OnAction()
                begin
                    // Create Journal functionality will be implemented in codeunit
                end;
            }
        }
    }
}