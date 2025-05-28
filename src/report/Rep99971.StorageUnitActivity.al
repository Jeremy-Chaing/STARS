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
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(StartingDate; StartingDate)
            {
            }
            column(EndingDate; EndingDate)
            {
            }
            column(StorageUnitNo; "Storage Unit No.")
            {
            }
            column(Description; Description)
            {
            }
            column(PrintRentalFeesPayment; PrintRentalFeesPayment)
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

                trigger OnPreDataItem()
                begin
                    if not PrintRentalFeesPayment then
                        // 如果未勾選，就排除 Entry Type 為 Rental Fees Payment 的資料
                        SetFilter("Entry Type", '<>%1', "Entry Type"::"Rental Fees Payment");

                    // 處理日期篩選
                    if (StartingDate <> 0D) and (EndingDate <> 0D) then
                        SetFilter("Date of Transaction", '%1..%2', StartingDate, EndingDate)
                    else if StartingDate <> 0D then
                        SetFilter("Date of Transaction", '>=%1', StartingDate)
                    else if EndingDate <> 0D then
                        SetFilter("Date of Transaction", '<=%1', EndingDate);
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field("Start Date"; StartingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the start date.';
                    }
                    field("End Date"; EndingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the end date.';
                    }

                    field(PrintRentalFeesPayment; PrintRentalFeesPayment)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Rental Fees Payment';
                        ToolTip = 'Specifies whether to print detail lines.';
                    }
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

    var
        CompanyDisplayName: Text;
        PrintRentalFeesPayment: Boolean;

        StartingDate: Date;
        EndingDate: Date;

    trigger OnPreReport()
    begin
        // Get the company name
        CompanyDisplayName := CompanyProperty.DisplayName();
    end;

    procedure InitializeRequest(PrintPayment: Boolean; StartDate: Date; EndDate: Date)
    begin
        PrintRentalFeesPayment := PrintPayment;
        StartingDate := StartDate;
        EndingDate := EndDate;
    end;
}
