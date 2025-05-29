table 99952 "Storage Journal Batch"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10]) { }
        field(2; "Name"; Code[10]) { DataClassification = CustomerContent; }
        field(3; "Description"; Text[100]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Journal Template Name", Name) { Clustered = true; }
    }
}