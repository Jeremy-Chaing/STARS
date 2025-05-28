codeunit 99943 "Stor. Jnl. Line-Post Batch"
{
    TableNo = "Storage Journal";

    trigger OnRun()
    begin
        StorageJnlLine.Copy(Rec);
        Code();
        Rec.Copy(StorageJnlLine);
    end;

    var
        StorageJnlLine: Record "Storage Journal";
        StorageCheckLine: Codeunit "Stor. Jnl. Line-Check Line";
        StoragePostLine: Codeunit "Stor. Jnl. Line-Post Line";
        Window: Dialog;
        LineCount: Integer;
        Text001: Label 'Posting lines  #1######';
        NoSelectErrText: Label 'No lines selected for posting.';
        SuccessMsg: Label '已成功過帳 %1 筆分錄。';

    local procedure "Code"()
    var
        ErrorText: Text;
    begin
        if StorageJnlLine.IsEmpty then
            Error(NoSelectErrText);

        Window.Open(Text001);

        OnBeforePostBatch(StorageJnlLine);

        // First check all selected lines
        if not StorageJnlLine.FindSet() then
            exit;

        repeat
            if not StorageCheckLine.RunCheck(StorageJnlLine, ErrorText) then
                Error('合約 %1 檢查失敗：%2', StorageJnlLine."Contract No.", ErrorText);
            LineCount += 1;
            Window.Update(1, LineCount);
        until StorageJnlLine.Next() = 0;

        // If all lines are valid, then post them
        LineCount := 0;
        StorageJnlLine.FindSet();

        repeat
            if not PostLine(StorageJnlLine, ErrorText) then
                Error('合約 %1 過帳失敗：%2', StorageJnlLine."Contract No.", ErrorText);
            LineCount += 1;
            Window.Update(1, LineCount);
        until StorageJnlLine.Next() = 0;

        OnAfterPostBatch(StorageJnlLine);

        Window.Close();

        if LineCount > 0 then
            Message(SuccessMsg, LineCount);
    end;

    local procedure PostLine(var StorageJournalLine: Record "Storage Journal"; var ErrorText: Text): Boolean
    begin
        exit(StoragePostLine.RunPostLine(StorageJournalLine, ErrorText));
    end;

    local procedure DeletePostedLines(SelectionFilter: Text)
    begin
        StorageJnlLine.Reset();
        StorageJnlLine.SetView(SelectionFilter);
        if StorageJnlLine.FindSet() then
            StorageJnlLine.DeleteAll();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostBatch(var StorageJournalLine: Record "Storage Journal")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostBatch(var StorageJournalLine: Record "Storage Journal")
    begin
    end;
}