codeunit 99941 "Stor. Jnl. Line-Check Line"
{
    TableNo = "Storage Journal";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    procedure RunCheck(var StorageJournalLine: Record "Storage Journal")
    begin
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

        // Check if Contract exists and is valid
        CheckContract(StorageJournalLine);

        // Check if Storage Unit exists
        CheckStorageUnit(StorageJournalLine);

        // Check if Customer exists
        CheckCustomer(StorageJournalLine);

        // Check Entry Type specific validations
        CheckEntryTypeValidations(StorageJournalLine);
    end;

    local procedure CheckContract(StorageJournalLine: Record "Storage Journal")
    var
        RentalContract: Record "Rental Contract";
    begin
        if not RentalContract.Get(StorageJournalLine."Contract No.") then
            Error('Contract %1 does not exist.', StorageJournalLine."Contract No.");

        if RentalContract."Contract Status" <> RentalContract."Contract Status"::Active then
            Error('Contract %1 is not active.', StorageJournalLine."Contract No.");

        if (StorageJournalLine."Date of Transaction" < RentalContract."Start Date") or
           (StorageJournalLine."Date of Transaction" > RentalContract."End Date") then
            Error('Transaction date must be within the contract period.');
    end;

    local procedure CheckStorageUnit(StorageJournalLine: Record "Storage Journal")
    var
        StorageUnit: Record "Storage Unit";
    begin
        if not StorageUnit.Get(StorageJournalLine."Storage Unit No.") then
            Error('Storage Unit %1 does not exist.', StorageJournalLine."Storage Unit No.");
    end;

    local procedure CheckCustomer(StorageJournalLine: Record "Storage Journal")
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(StorageJournalLine."Customer No.") then
            Error('Customer %1 does not exist.', StorageJournalLine."Customer No.");

        if Customer.Blocked in [Customer.Blocked::All] then
            Error('Customer %1 is blocked.', StorageJournalLine."Customer No.");
    end;

    local procedure CheckEntryTypeValidations(StorageJournalLine: Record "Storage Journal")
    var
        StorageUnit: Record "Storage Unit";
    begin
        StorageUnit.Get(StorageJournalLine."Storage Unit No.");

        case StorageJournalLine."Entry Type" of
            StorageJournalLine."Entry Type"::Deposits:
                begin
                    if StorageJournalLine.Amount <= 0 then
                        Error('Deposit amount must be positive.');
                    if StorageJournalLine.Amount > (StorageUnit."Square Footage" * 5) then
                        Error('Deposit amount cannot exceed $5 per square foot.');
                end;
            StorageJournalLine."Entry Type"::"Return Deposits":
                begin
                    if StorageJournalLine.Amount >= 0 then
                        Error('Return deposit amount must be negative.');
                    if Abs(StorageJournalLine.Amount) > (StorageUnit."Square Footage" * 5) then
                        Error('Return deposit amount cannot exceed $5 per square foot.');
                end;
            StorageJournalLine."Entry Type"::"Rental Fees":
                begin
                    if StorageJournalLine.Amount <= 0 then
                        Error('Rental fee must be positive.');
                end;
        end;
    end;
}