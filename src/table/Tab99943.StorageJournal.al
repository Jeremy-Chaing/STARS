table 99943 "Storage Journal"
{
    Caption = 'Storage Journal';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            DataClassification = CustomerContent;
            TableRelation = "Rental Contract"."Contract No.";
        }
        field(3; "Storage Unit No."; Code[20])
        {
            Caption = 'Storage Unit No.';
            DataClassification = CustomerContent;
            TableRelation = "Storage Unit"."Storage Unit No.";
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Date of Transaction"; Date)
        {
            Caption = 'Date of Transaction';
            DataClassification = CustomerContent;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(8; "Entry Type"; Enum "Storage Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(9; "Job Queue Created"; Boolean)
        {
            Caption = 'Job Queue Created';
            DataClassification = CustomerContent;
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Journal Template Name"; Code[10]) { }
        field(12; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Storage Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }

    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Journal Batch Name", "Description")
        {
            Caption = 'Storage Unit';
        }
    }
}