report 99945 "Create Rental Fees"
{
    // This report is designed to generate next month's payable accounts
    // UseRequestPage is kept true to allow users to:
    // 1. Select specific processing date
    // 2. Handle special cases where different date calculations are needed
    Caption = 'Create Next Month''s Rental Fees';
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem("Rental Contract"; "Rental Contract")
        {
            RequestFilterFields = "Contract No.", "Customer No.";
            DataItemTableView = where("Contract Status" = const(Active));

            trigger OnPreDataItem()
            begin
                SetRange("Contract Status", "Contract Status"::Active);
                // 確保執行日期在合約期間內
                SetFilter("Start Date", '<=%1', ProcessingDate);
                SetFilter("End Date", '>=%1', ProcessingDate);
                // 確保合約在下個月仍然有效
                SetFilter("End Date", '>=%1', NextMonth);
            end;

            trigger OnAfterGetRecord()
            begin
                StorageJournal.Init();
                if LastLineNo = 0 then
                    LastLineNo := 10000
                else
                    LastLineNo += 10000;

                StorageJournal."Line No." := LastLineNo;
                StorageJournal."Contract No." := "Contract No.";
                StorageJournal."Storage Unit No." := "Storage Unit No.";
                StorageJournal."Customer No." := "Customer No.";
                StorageJournal.Description := StrSubstNo('Monthly Rental Fee for %1', Format(NextMonth, 0, '<Month Text> <Year4>'));
                StorageJournal."Date of Transaction" := NextMonth;
                StorageJournal.Amount := "Monthly Rental Fee";
                StorageJournal."Entry Type" := StorageJournal."Entry Type"::"Rental Fees";
                StorageJournal."Job Queue Created" := true;
                if not StorageJournal.Insert() then
                    Error('Failed to create journal entry for contract %1', "Contract No.");
            end;
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
                    field(ProcessingDate; ProcessingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Processing Date';
                        ToolTip = 'Specifies the date for which to generate the rental fees. This date will be used to calculate next month''s transactions.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if ProcessingDate = 0D then
            ProcessingDate := WorkDate();

        // 計算下個月第一天
        NextMonth := CalcDate('<CM+1D>', ProcessingDate);

        // 取得最後一筆 line no.
        StorageJournal.Reset();
        if StorageJournal.FindLast() then
            LastLineNo := StorageJournal."Line No."
        else
            LastLineNo := 0;
    end;

    trigger OnPostReport()
    begin
        if LastLineNo > 0 then
            Message('Successfully generated %1 journal entries for next month''s rental fees.', LastLineNo);
    end;

    var
        StorageJournal: Record "Storage Journal";
        ProcessingDate: Date;
        NextMonth: Date;
        LastLineNo: Integer;
}