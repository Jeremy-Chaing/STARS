codeunit 99942 "Stor. Jnl. Line-Post Line"
{
    Permissions = TableData "Storage Ledger Entry" = imd,
                  TableData "Storage Journal" = rimd;
    TableNo = "Storage Journal";

    trigger OnRun()
    var
        ErrorText: Text;
    begin
        RunPostLine(Rec, ErrorText);
    end;

    procedure RunPostLine(var StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        StorageLedgerEntry: Record "Storage Ledger Entry";
        IsSuccess: Boolean;
    begin
        // Start transaction
        IsSuccess := false;
        StorageLedgerEntry.LockTable();

        // Create ledger entry using TransferFields
        StorageLedgerEntry.Init();
        StorageLedgerEntry.TransferFields(StorageJournalLine, false);
        if GetMaxEntryNo() = 0 then
            StorageLedgerEntry."Entry No." := 10000
        else
            StorageLedgerEntry."Entry No." := GetMaxEntryNo() + 10000;
        StorageLedgerEntry."Posting Date" := Today();
        StorageLedgerEntry."Job Queue Created" := false;

        OnBeforeInsertLedgerEntry(StorageLedgerEntry, StorageJournalLine);

        // Insert ledger entry within transaction scope
        if not StorageLedgerEntry.Insert(true) then begin
            ErrorText := GetLastErrorText();
            exit(false);
        end;

        // Update statistics (optimized)
        if not UpdateStatistics(StorageJournalLine, ErrorText) then
            exit(false);

        // Delete the journal line after successful posting
        if not StorageJournalLine.Delete() then begin
            ErrorText := StrSubstNo('無法刪除已過帳的分錄 %1', StorageJournalLine."Line No.");
            exit(false);
        end;

        IsSuccess := true;
        OnAfterInsertLedgerEntry(StorageLedgerEntry, StorageJournalLine);

        exit(IsSuccess);
    end;

    local procedure UpdateStatistics(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        RentalContract: Record "Rental Contract";
    begin
        // Update contract statistics if needed
        if (StorageJournalLine."Contract No." = '') then
            exit(true);

        if not RentalContract.Get(StorageJournalLine."Contract No.") then begin
            ErrorText := StrSubstNo('找不到合約 %1', StorageJournalLine."Contract No.");
            exit(false);
        end;

        // Update description with latest transaction
        RentalContract.Description := StrSubstNo('Last transaction: %1 on %2',
            Format(StorageJournalLine."Entry Type"),
            Format(StorageJournalLine."Date of Transaction"));

        if not RentalContract.Modify() then begin
            ErrorText := StrSubstNo('無法更新合約 %1 的統計資料', StorageJournalLine."Contract No.");
            exit(false);
        end;

        exit(true);
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