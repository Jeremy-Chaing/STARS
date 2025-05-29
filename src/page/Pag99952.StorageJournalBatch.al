page 99952 "Storage Journal Batches"
{
    PageType = List;
    SourceTable = "Storage Journal Batch";
    ApplicationArea = All;
    Caption = 'Storage Journal Batches';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Batch Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty then begin
            Rec.Init();
            Rec."Journal Template Name" := 'STORAGE';
            Rec.Name := 'DEFAULT';
            Rec.Description := 'Default Storage Journal Batch';
            if Rec.Insert() then;
        end;
    end;
}