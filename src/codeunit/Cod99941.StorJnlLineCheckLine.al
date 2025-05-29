codeunit 99941 "Stor. Jnl. Line-Check Line"
{
    TableNo = "Storage Journal";

    trigger OnRun()
    var
        ErrorText: Text;
    begin
        RunCheck(Rec, ErrorText);
    end;

    procedure RunCheck(var StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    begin
        //基本空值檢查
        if StorageJournalLine.Amount = 0 then begin
            ErrorText := '金額不可為零';
            exit(false);
        end;

        if StorageJournalLine."Contract No." = '' then begin
            ErrorText := '合約編號不可為空';
            exit(false);
        end;

        if StorageJournalLine."Storage Unit No." = '' then begin
            ErrorText := '倉庫編號不可為空';
            exit(false);
        end;

        if StorageJournalLine."Customer No." = '' then begin
            ErrorText := '客戶編號不可為空';
            exit(false);
        end;

        if StorageJournalLine."Date of Transaction" = 0D then begin
            ErrorText := '交易日期不可為空';
            exit(false);
        end;

        if not CheckContract(StorageJournalLine, ErrorText) then
            exit(false);

        if not CheckStorageUnit(StorageJournalLine, ErrorText) then
            exit(false);

        if not CheckCustomer(StorageJournalLine, ErrorText) then
            exit(false);

        if not CheckEntryTypeValidations(StorageJournalLine, ErrorText) then
            exit(false);

        if not CheckDuplicatePayment(StorageJournalLine, ErrorText) then
            exit(false);

        exit(true);
    end;

    local procedure CheckContract(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        RentalContract: Record "Rental Contract";
    begin
        //合約不存在
        if not RentalContract.Get(StorageJournalLine."Contract No.") then begin
            ErrorText := StrSubstNo('合約 %1 不存在', StorageJournalLine."Contract No.");
            exit(false);
        end;

        //合約狀態必須為Active  
        if RentalContract."Contract Status" <> RentalContract."Contract Status"::Active then begin
            ErrorText := StrSubstNo('合約 %1 不是有效狀態', StorageJournalLine."Contract No.");
            exit(false);
        end;

        //租金或退還押金日期必須在合約期間內    
        if (StorageJournalLine."Entry Type" in [StorageJournalLine."Entry Type"::"Rental Fees", StorageJournalLine."Entry Type"::"Return Deposits"]) then
            if (StorageJournalLine."Date of Transaction" < RentalContract."Start Date") or
                (StorageJournalLine."Date of Transaction" > RentalContract."End Date") then begin
                ErrorText := StrSubstNo('合約 %1 的交易日期必須在合約期間內', StorageJournalLine."Contract No.");
                exit(false);
            end;

        exit(true);
    end;

    local procedure CheckStorageUnit(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        StorageUnit: Record "Storage Unit";
    begin
        //倉庫不存在
        if not StorageUnit.Get(StorageJournalLine."Storage Unit No.") then begin
            ErrorText := StrSubstNo('倉庫 %1 不存在', StorageJournalLine."Storage Unit No.");
            exit(false);
        end;
        exit(true);
    end;

    local procedure CheckCustomer(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        Customer: Record Customer;
    begin
        //客戶不存在
        if not Customer.Get(StorageJournalLine."Customer No.") then begin
            ErrorText := StrSubstNo('客戶 %1 不存在', StorageJournalLine."Customer No.");
            exit(false);
        end;

        //客戶被停用
        if Customer.Blocked in [Customer.Blocked::All] then begin
            ErrorText := StrSubstNo('客戶 %1 已被停用', StorageJournalLine."Customer No.");
            exit(false);
        end;
        exit(true);
    end;

    local procedure CheckDuplicatePayment(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        StorageLedgerEntry: Record "Storage Ledger Entry";
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
    begin
        // 只檢查租金和租金付款類型的分錄
        if not (StorageJournalLine."Entry Type" in [
            StorageJournalLine."Entry Type"::"Rental Fees",
            StorageJournalLine."Entry Type"::"Rental Fees Payment"]) then
            exit(true);

        // 計算當月的日期範圍
        CurrentMonthStart := CalcDate('<-CM>', StorageJournalLine."Date of Transaction");
        CurrentMonthEnd := CalcDate('<CM>', StorageJournalLine."Date of Transaction");

        // 檢查是否已有當月的租金記錄
        StorageLedgerEntry.Reset();
        StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
        if StorageJournalLine."Entry Type" = StorageJournalLine."Entry Type"::"Rental Fees" then
            StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::"Rental Fees")
        else
            StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::"Rental Fees Payment");
        StorageLedgerEntry.SetRange("Date of Transaction", CurrentMonthStart, CurrentMonthEnd);

        if not StorageLedgerEntry.IsEmpty then begin
            if StorageJournalLine."Entry Type" = StorageJournalLine."Entry Type"::"Rental Fees" then
                ErrorText := StrSubstNo('合約 %1 已有 %2 的租金記錄',
                    StorageJournalLine."Contract No.",
                    Format(StorageJournalLine."Date of Transaction", 0, '<Month Text> <Year4>'))
            else
                ErrorText := StrSubstNo('合約 %1 已有 %2 的租金付款記錄',
                    StorageJournalLine."Contract No.",
                    Format(StorageJournalLine."Date of Transaction", 0, '<Month Text> <Year4>'));
            exit(false);
        end;

        exit(true);
    end;

    local procedure CheckEntryTypeValidations(StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    var
        StorageUnit: Record "Storage Unit";
        Customer: Record Customer;
        StorageLedgerEntry: Record "Storage Ledger Entry";
    begin
        StorageUnit.Get(StorageJournalLine."Storage Unit No.");
        Customer.Get(StorageJournalLine."Customer No.");

        Customer.CalcFields("Total Deposits", "Total Rental Fees");

        case StorageJournalLine."Entry Type" of
            StorageJournalLine."Entry Type"::Deposits:
                begin
                    //押金金額必須為正
                    if StorageJournalLine.Amount <= 0 then begin
                        ErrorText := '押金金額必須為正數';
                        exit(false);
                    end;

                    //押金金額不能超過5元/平方呎
                    if StorageJournalLine.Amount > (StorageUnit."Square Footage" * 5) then begin
                        ErrorText := StrSubstNo('押金金額不能超過每平方呎5元（最高%1元）', StorageUnit."Square Footage" * 5);
                        exit(false);
                    end;

                    // 檢查同一合約是否已有押金記錄
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if not StorageLedgerEntry.IsEmpty then begin
                        ErrorText := StrSubstNo('合約 %1 已有押金記錄', StorageJournalLine."Contract No.");
                        exit(false);
                    end;
                end;
            StorageJournalLine."Entry Type"::"Return Deposits":
                begin
                    //退還押金金額必須為負
                    if StorageJournalLine.Amount >= 0 then begin
                        ErrorText := '退還押金金額必須為負數';
                        exit(false);
                    end;

                    //退還押金金額不能超過5元/平方呎
                    if Abs(StorageJournalLine.Amount) > (StorageUnit."Square Footage" * 5) then begin
                        ErrorText := StrSubstNo('退還押金金額不能超過每平方呎5元（最高%1元）', StorageUnit."Square Footage" * 5);
                        exit(false);
                    end;

                    // 檢查合約是否有押金可以退還
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if StorageLedgerEntry.IsEmpty then begin
                        ErrorText := StrSubstNo('合約 %1 沒有可退還的押金', StorageJournalLine."Contract No.");
                        exit(false);
                    end;

                    // 計算合約押金總額
                    StorageLedgerEntry.CalcSums(Amount);
                    if Abs(StorageJournalLine.Amount) > StorageLedgerEntry.Amount then begin
                        ErrorText := StrSubstNo('退還金額不能超過目前押金餘額 %1', StorageLedgerEntry.Amount);
                        exit(false);
                    end;
                end;
            StorageJournalLine."Entry Type"::"Rental Fees":
                begin
                    //租金必須為正
                    if StorageJournalLine.Amount <= 0 then begin
                        ErrorText := '租金必須為正數';
                        exit(false);
                    end;

                    // 檢查合約是否已繳押金
                    StorageLedgerEntry.Reset();
                    StorageLedgerEntry.SetRange("Contract No.", StorageJournalLine."Contract No.");
                    StorageLedgerEntry.SetRange("Entry Type", StorageLedgerEntry."Entry Type"::Deposits);
                    if StorageLedgerEntry.IsEmpty then begin
                        ErrorText := StrSubstNo('合約 %1 必須先繳交押金才能收取租金', StorageJournalLine."Contract No.");
                        exit(false);
                    end;
                end;
        end;
        exit(true);
    end;
}