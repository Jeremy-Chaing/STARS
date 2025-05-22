table 99950 "Rental Contract"
{
    Caption = 'Rental Contract';
    DataClassification = CustomerContent;
    LookupPageId = "Rental Contract List";
    DrillDownPageId = "Rental Contract Card";

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(3; "Storage Unit No."; Code[20])
        {
            Caption = 'Storage Unit No.';
            DataClassification = CustomerContent;
            TableRelation = "Storage Unit"."Storage Unit No.";
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "End Date" < "Start Date" then
                    Error('End Date cannot be earlier than Start Date');
            end;
        }
        field(6; "Monthly Rental Fee"; Decimal)
        {
            Caption = 'Monthly Rental Fee';
            DataClassification = CustomerContent;
        }
        field(7; "Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // begin
            //     TestField("Deposit Amount", "Monthly Rental Fee");  // 押金必須等於一個月租金
            // end;
        }
        field(8; "Contract Status"; Enum "Contract Status")
        {
            Caption = 'Contract Status';
            DataClassification = CustomerContent;
            InitValue = Active;  // 預設為 Active
        }
        field(9; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        // Statistics fields
        field(10; "Last Transaction Date"; Date)
        {
            Caption = 'Last Transaction Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Total Deposits Received"; Decimal)
        {
            Caption = 'Total Deposits Received';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Total Deposits Returned"; Decimal)
        {
            Caption = 'Total Deposits Returned';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Total Rent Collected"; Decimal)
        {
            Caption = 'Total Rent Collected';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Storage Unit Square footage"; Decimal)
        {
            Caption = 'Storage Unit Square footage';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Contract No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit "No. Series";

        StorageUnit: Record "Storage Unit";

    trigger OnInsert()
    var
        Setup: Record "STARS Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
    begin
        if "Contract No." = '' then begin
            Setup.Get('STARS');
            Setup.TestField("Contract Nos.");
            "No. Series" := Setup."Contract Nos.";
            "Contract No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

    end;

    procedure AssistEdit(OldContract: Record "Rental Contract"): Boolean
    var
        Setup: Record "STARS Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        TempRec: Record "Rental Contract";
    begin
        TempRec := Rec;
        Setup.Get('STARS');
        Setup.TestField("Contract Nos.");

        if NoSeries.LookupRelatedNoSeries(Setup."Contract Nos.", OldContract."No. Series", TempRec."No. Series") then begin
            TempRec."Contract No." := NoSeries.GetNextNo(TempRec."No. Series", WorkDate());
            Rec := TempRec;
            exit(true);
        end;
    end;
}