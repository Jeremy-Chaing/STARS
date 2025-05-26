table 99940 "Storage Unit"
{
    Caption = 'Storage Unit';
    DataClassification = CustomerContent;
    LookupPageId = "Storage Unit List";
    DrillDownPageId = "Storage Unit List";

    fields
    {
        field(1; "Storage Unit No."; Code[20])
        {
            Caption = 'Storage Unit No.';
            DataClassification = CustomerContent;
        }
        field(2; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            DataClassification = CustomerContent;
            TableRelation = Building."Building No." where(Status = filter(Active));
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';

        }
        field(4; "Square Footage"; Decimal)
        {
            Caption = 'Square Footage';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Square Footage" <= 0 then
                    Error('Square Footage must be a positive number.');
            end;
        }
        field(5; "Monthly Rental Fee"; Decimal)
        {
            Caption = 'Monthly Rental Fee';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Monthly Rental Fee" <= 0 then
                    Error('Monthly Rental Fee must be a positive number.');
            end;
        }
        field(6; "Total Rental Income"; Decimal)
        {
            Caption = 'Total Rental Income';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where(
                "Storage Unit No." = field("Storage Unit No."),
                "Entry Type" = const("Rental Fees")));
            Editable = false;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; "Average Deposit"; Decimal)
        {
            Caption = 'Average Deposit';
            FieldClass = FlowField;
            CalcFormula = average("Storage Ledger Entry".Amount where(
                "Storage Unit No." = field("Storage Unit No."),
                "Entry Type" = const(Deposits)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Storage Unit No.")
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
        if "Storage Unit No." = '' then begin
            Setup.Get('STARS');
            Setup.TestField("Storage Unit Nos.");
            "No. Series" := Setup."Storage Unit Nos.";
            "Storage Unit No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;

    procedure AssistEdit(OldContract: Record "Storage Unit"): Boolean
    var
        Setup: Record "STARS Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        TempRec: Record "Storage Unit";
    begin
        TempRec := Rec;
        Setup.Get('STARS');
        Setup.TestField("Storage Unit Nos.");

        if NoSeries.LookupRelatedNoSeries(Setup."Storage Unit Nos.", OldContract."No. Series", TempRec."No. Series") then begin
            TempRec."Storage Unit No." := NoSeries.GetNextNo(TempRec."No. Series", WorkDate());
            Rec := TempRec;
            exit(true);
        end;
    end;
}