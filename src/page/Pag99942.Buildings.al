page 99942 "Buildings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Building;
    Caption = 'Buildings';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Building No.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the building.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the building.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the building.';
                }
                field("Activity Exists"; Rec."Activity Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether there are any storage ledger entries for this building.';
                }
            }
        }
    }
}