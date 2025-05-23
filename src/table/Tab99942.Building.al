table 99942 Building
{
    Caption = 'Building';
    DataClassification = CustomerContent;
    LookupPageId = "Buildings";
    DrillDownPageId = "Buildings";

    fields
    {
        field(1; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; Address; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(4; Status; Enum "Building Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(5; "Activity Exists"; Boolean)
        {
            Caption = 'Activity Exists';
            FieldClass = FlowField;
            CalcFormula = exist("Storage Unit" where("Building No." = field("Building No.")));
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Building No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    var
        Setup: Record "STARS Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
    begin
        if "Building No." = '' then begin
            Setup.Get('STARS');
            Setup.TestField("Building Nos.");
            "No. Series" := Setup."Building Nos.";
            "Building No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;

    procedure AssistEdit(OldContract: Record "Building"): Boolean
    var
        Setup: Record "STARS Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        TempRec: Record "Building";
    begin
        TempRec := Rec;
        Setup.Get('STARS');
        Setup.TestField("Building Nos.");

        if NoSeries.LookupRelatedNoSeries(Setup."Building Nos.", OldContract."No. Series", TempRec."No. Series") then begin
            TempRec."Building No." := NoSeries.GetNextNo(TempRec."No. Series", WorkDate());
            Rec := TempRec;
            exit(true);
        end;
    end;
}