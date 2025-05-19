table 99950 "Rental Contract"
{
    Caption = 'Rental Contract';
    DataClassification = CustomerContent;

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
        }
        field(8; "Contract Status"; Enum "Contract Status")
        {
            Caption = 'Contract Status';
            DataClassification = CustomerContent;
        }
        field(9; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Contract No.")
        {
            Clustered = true;
        }
    }
}