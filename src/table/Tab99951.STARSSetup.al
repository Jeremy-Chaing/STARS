table 99951 "STARS Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Contract Nos."; Code[20])
        {
            Caption = 'Contract Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
        field(3; "Building Nos."; Code[20])
        {
            Caption = 'Building Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
        field(4; "Storage Unit Nos."; Code[20])
        {
            Caption = 'Storage Unit Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }
}