report 99971 "Storage Unit Activity"
{
    ApplicationArea = All;
    Caption = 'Storage Unit  Activity';
    UsageCategory = ReportsAndAnalysis;

    RDLCLayout = './src/report/layout/StorageUnitActivity.rdl';
    dataset
    {
        dataitem(StorageUnit; "Storage Unit")
        {
            column(StorageUnitNo; "Storage Unit No.")
            {
            }
            column(Description; Description)
            {
            }
            dataitem(StorageLedgerEntry; "Storage Ledger Entry")
            {
                DataItemLinkReference = StorageUnit;
                DataItemLink = "Storage Unit No." = field("Storage Unit No.");
                DataItemTableView = sorting("Entry No.");
                column(Customer_No; "Customer No.")
                {
                }
                column(Entry_No; "Entry No.")
                {

                }
                column(DateOfTransaction; "Date of Transaction")
                {
                }
                column(Amount; Amount)
                {
                }
                column(EntryType; "Entry Type")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
