report 99970 "Customer Report"
{
    ApplicationArea = All;
    Caption = 'CustomerReport';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report/layout/CustomerReport.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Name", City;
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(City; City)
            {
            }
            dataitem(RentalContract; "Rental Contract")
            {

                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Contract No.");

                column(ContractNo; "Contract No.")
                {
                }
                column(StartDate; "Start Date")
                {
                }
                column(EndDate; "End Date")
                {
                }
                column(StorageUnitNo; "Storage Unit No.")
                {
                }
                column(ContractStatus; "Contract Status")
                {
                }
                column(PrintDetails; PrintDetails)
                {
                }

                dataitem(StorageUnit; "Storage Unit")
                {
                    DataItemLinkReference = RentalContract;
                    DataItemLink = "Storage Unit No." = field("Storage Unit No.");
                    DataItemTableView = sorting("Storage Unit No.");
                    column(StorageUnitNo1; "Storage Unit No.")
                    {
                    }
                    column(StorageUnitDescription; Description)
                    {
                    }
                    dataitem(Building; Building)
                    {
                        DataItemLinkReference = StorageUnit;
                        DataItemLink = "Building No." = field("Building No.");
                        DataItemTableView = sorting("Building No.");
                        column(BuildingNo; "Building No.")
                        {
                        }
                        column(BuildingDescription; Description)
                        {
                        }
                    }
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
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Details';
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
        PrintDetails: Boolean;


    procedure InitializeRequest(ShowDetails: Boolean)
    begin
        PrintDetails := ShowDetails;
    end;
}
