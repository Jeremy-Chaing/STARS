codeunit 99941 "Stor. Jnl. Line-Check Line"
{
    TableNo = "Storage Journal";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    procedure RunCheck(var StorageJournalLine: Record "Storage Journal")
    begin
        //基本空值檢查
        if StorageJournalLine.Amount = 0 then
            Error('Amount cannot be zero.');

        if StorageJournalLine."Contract No." = '' then
            Error('Contract No. must be specified.');

        if StorageJournalLine."Storage Unit No." = '' then
            Error('Storage Unit No. must be specified.');

        if StorageJournalLine."Customer No." = '' then
            Error('Customer No. must be specified.');

        if StorageJournalLine."Date of Transaction" = 0D then
            Error('Date of Transaction must be specified.');


        CheckContract(StorageJournalLine);

        CheckStorageUnit(StorageJournalLine);

        CheckCustomer(StorageJournalLine);

        CheckEntryTypeValidations(StorageJournalLine);
    end;

    local procedure CheckContract(StorageJournalLine: Record "Storage Journal")
    var
        RentalContract: Record "Rental Contract";
    begin
        //合約不存在
        if not RentalContract.Get(StorageJournalLine."Contract No.") then
            Error('Contract %1 does not exist.', StorageJournalLine."Contract No.");

        //合約狀態必須為Active  
        if RentalContract."Contract Status" <> RentalContract."Contract Status"::Active then
            Error('Contract %1 is not active.', StorageJournalLine."Contract No.");

        //租金或退還押金日期必須在合約期間內    
        if (StorageJournalLine."Entry Type" in [StorageJournalLine."Entry Type"::"Rental Fees", StorageJournalLine."Entry Type"::"Return Deposits"]) then
            if (StorageJournalLine."Date of Transaction" < RentalContract."Start Date") or
                (StorageJournalLine."Date of Transaction" > RentalContract."End Date") then
                Error('%1 Transaction date must be within the contract period.', StorageJournalLine."Contract No.");
    end;

    local procedure CheckStorageUnit(StorageJournalLine: Record "Storage Journal")
    var
        StorageUnit: Record "Storage Unit";
    begin
        //倉庫不存在
        if not StorageUnit.Get(StorageJournalLine."Storage Unit No.") then
            Error('Storage Unit %1 does not exist.', StorageJournalLine."Storage Unit No.");
    end;

    local procedure CheckCustomer(StorageJournalLine: Record "Storage Journal")
    var
        Customer: Record Customer;
    begin
        //客戶不存在
        if not Customer.Get(StorageJournalLine."Customer No.") then
            Error('Customer %1 does not exist.', StorageJournalLine."Customer No.");

        //客戶被停用
        if Customer.Blocked in [Customer.Blocked::All] then
            Error('Customer %1 is blocked.', StorageJournalLine."Customer No.");
    end;

    local procedure CheckEntryTypeValidations(StorageJournalLine: Record "Storage Journal")
    var
        StorageUnit: Record "Storage Unit";
        Customer: Record Customer;
        StorageLedgerEntry: Record "Storage Ledger Entry";
        ExistingDepositErr: Label 'Contract %1 already has a deposit record.';
    begin
        StorageUnit.Get(StorageJournalLine."Storage Unit No.");
        Customer.Get(StorageJournalLine."Customer No.");

        Customer.CalcFields("Total Deposits", "Total Rental Fees");

        case StorageJournalLine."Entry Type" of
            StorageJournalLine."Entry Type"::Deposits:
                begin
                    //押金金額必須為正
                    if StorageJournalLine.Amount <= 0 then
                        Error('Deposit amount must be positive.');

                    //押金金額不能超過5元/平方呎
                    if StorageJournalLine.Amount > (StorageUnit."Square Footage" * 5) then
                        Error('Deposit amount cannot exceed $5 per square foot.');

                    // 檢查同一合約是否已有押金記錄
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if not StorageLedgerEntry.IsEmpty then
                        Error(ExistingDepositErr, StorageJournalLine."Contract No.");
                end;
            StorageJournalLine."Entry Type"::"Return Deposits":
                begin
                    //退還押金金額必須為負
                    if StorageJournalLine.Amount >= 0 then
                        Error('Return deposit amount must be negative.');

                    //退還押金金額不能超過5元/平方呎
                    if Abs(StorageJournalLine.Amount) > (StorageUnit."Square Footage" * 5) then
                        Error('Return deposit amount cannot exceed $5 per square foot.');

                    // 檢查合約是否有押金可以退還
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if StorageLedgerEntry.IsEmpty then
                        Error('No deposit available to return for Contract %1.',
                            StorageJournalLine."Contract No.");

                    // 計算合約押金總額
                    StorageLedgerEntry.CalcSums(Amount);
                    if Abs(StorageJournalLine.Amount) > StorageLedgerEntry.Amount then
                        Error('Return amount cannot exceed current deposit of %1.',
                            StorageLedgerEntry.Amount);
                end;
            StorageJournalLine."Entry Type"::"Rental Fees":
                begin
                    //租金必須為正
                    if StorageJournalLine.Amount <= 0 then
                        Error('Rental fee must be positive.');

                    // 檢查合約是否已繳押金
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if StorageLedgerEntry.IsEmpty then
                        Error('Contract %1 must have a deposit before being charged rental fees.',
                            StorageJournalLine."Contract No.");
                end;
        end;
    end;
}