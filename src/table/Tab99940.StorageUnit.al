table 99940 "Storage Unit"
{
    Caption = 'Storage Unit';
    DataClassification = CustomerContent;
    LookupPageId = "Storage Unit List";
    DrillDownPageId = "Storage Unit Card";

    fields
    {
        field(1; "Storage Unit No."; Code[20])
        {
            Caption = 'Storage Unit No.';
            DataClassification = CustomerContent;
        }
        field(2; "Building Identifier"; Code[20])
        {
            Caption = 'Building Identifier';
            DataClassification = CustomerContent;
            TableRelation = Building."Building Code";

            trigger OnValidate()
            begin
                CalcFields("Description");
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Building.Description where("Building Code" = field("Building Identifier")));
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
        }
        field(6; "Total Rental Income"; Decimal)
        {
            Caption = 'Total Rental Income';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where(
                "Storage Unit No." = field("Storage Unit No."),
                "Entry Type" = const(Rent)));
            Editable = false;
        }
        field(7; "Current Deposit"; Decimal)
        {
            Caption = 'Current Deposit';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where(
                "Storage Unit No." = field("Storage Unit No."),
                "Entry Type" = const(Deposit)));
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
}