table 99942 Building
{
    Caption = 'Building';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
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
            CalcFormula = exist("Storage Ledger Entry" where("Storage Unit No." = field("Building Code")));
        }
    }

    keys
    {
        key(PK; "Building Code")
        {
            Clustered = true;
        }
    }
}