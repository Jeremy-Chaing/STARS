codeunit 99942 "Stor. Jnl. Line-Post Line"
{
    Permissions = TableData "Storage Ledger Entry" = imd,
                  TableData "Storage Journal" = rimd;
    TableNo = "Storage Journal";

    trigger OnRun()
    begin
        RunPostLine(Rec);
    end;

    procedure RunPostLine(var StorageJournalLine: Record "Storage Journal"): Boolean
    var
        StorageLedgerEntry: Record "Storage Ledger Entry";
        IsSuccess: Boolean;
    begin
        if not StorageJournalLine.Get(StorageJournalLine."Entry No.") then
            Error('Journal line with Entry No. %1 not found.', StorageJournalLine."Entry No.");

        // Start transaction
        IsSuccess := false;
        StorageLedgerEntry.LockTable();

        // Create ledger entry using TransferFields
        StorageLedgerEntry.Init();
        StorageLedgerEntry.TransferFields(StorageJournalLine, false);
        StorageLedgerEntry."Posting Date" := Today();

        OnBeforeInsertLedgerEntry(StorageLedgerEntry, StorageJournalLine);

        // Insert ledger entry within transaction scope
        if not StorageLedgerEntry.Insert(true) then
            Error('Failed to insert ledger entry.');

        // Update statistics (optimized)
        UpdateStatistics(StorageJournalLine);

        // Delete the journal line after successful posting
        if not StorageJournalLine.Delete() then
            Error('Failed to delete journal line after posting.');

        IsSuccess := true;
        OnAfterInsertLedgerEntry(StorageLedgerEntry, StorageJournalLine);

        exit(IsSuccess);
    end;

    local procedure UpdateStatistics(StorageJournalLine: Record "Storage Journal")
    var
        RentalContract: Record "Rental Contract";
    begin
        // Update contract statistics if needed
        if (StorageJournalLine."Contract No." = '') then
            exit;

        if not RentalContract.Get(StorageJournalLine."Contract No.") then
            exit;

        // Update description with latest transaction
        RentalContract.Description := StrSubstNo('Last transaction: %1 on %2',
            Format(StorageJournalLine."Entry Type"),
            Format(StorageJournalLine."Date of Transaction"));

        if not RentalContract.Modify() then
            Error('Failed to update rental contract statistics.');

        // Note: Removed unnecessary FlowField calculations as they are computed on-demand
    end;

    local procedure GetMaxEntryNo(): Integer
    var
        StorageLedgerEntry: Record "Storage Ledger Entry";
    begin
        StorageLedgerEntry.Reset();
        if not StorageLedgerEntry.FindLast() then
            exit(0);

        exit(StorageLedgerEntry."Entry No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertLedgerEntry(var StorageLedgerEntry: Record "Storage Ledger Entry"; StorageJournalLine: Record "Storage Journal")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertLedgerEntry(var StorageLedgerEntry: Record "Storage Ledger Entry"; StorageJournalLine: Record "Storage Journal")
    begin
    end;
}