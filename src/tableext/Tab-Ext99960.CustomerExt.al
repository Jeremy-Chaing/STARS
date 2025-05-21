tableextension 99960 "Customer Ext" extends Customer
{
    fields
    {
        field(99940; "Auto Post Journals"; Boolean)
        {
            Caption = 'Auto Post Journals';
            DataClassification = CustomerContent;
        }
        field(99941; "Total Outstanding Amount"; Decimal)
        {
            Caption = 'Total Outstanding Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where("Customer No." = field("No.")));
            Editable = false;
        }
        field(99942; "Total Deposits"; Decimal)
        {
            Caption = 'Total Deposits';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where(
                "Customer No." = field("No."),
                "Entry Type" = const(Deposit)));
            Editable = false;
        }
        field(99943; "Total Rental Fees"; Decimal)
        {
            Caption = 'Total Rental Fees';
            FieldClass = FlowField;
            CalcFormula = sum("Storage Ledger Entry".Amount where(
                "Customer No." = field("No."),
                "Entry Type" = const(Rent)));
            Editable = false;
        }
        field(99944; "Active Storage Units"; Integer)
        {
            Caption = 'Active Storage Units';
            FieldClass = FlowField;
            CalcFormula = count("Rental Contract" where(
                "Customer No." = field("No."),
                "Contract Status" = const(Active)));
            Editable = false;
        }
        field(99945; "Average Deposit"; Decimal)
        {
            Caption = 'Average Deposit';
            FieldClass = FlowField;
            CalcFormula = average("Storage Ledger Entry".Amount where(
                "Customer No." = field("No."),
                "Entry Type" = const(Deposit)));
            Editable = false;
        }
    }
}