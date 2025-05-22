page 99961 "STARS Setup"
{
    PageType = Card;
    SourceTable = "STARS Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.") { }
                field("Contract Nos."; Rec."Contract Nos.")
                {
                    ApplicationArea = All;
                }
                field("Building Nos."; Rec."Building Nos.")
                {
                    ApplicationArea = All;
                }
                field("Storage Unit Nos."; Rec."Storage Unit Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}