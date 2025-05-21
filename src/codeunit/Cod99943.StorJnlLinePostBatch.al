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
        PostErrText: Label 'An error occurred while posting the journal lines.';
        NoSelectErrText: Label 'No lines selected for posting.';

    local procedure "Code"()
    var
        ErrorOccurred: Boolean;
        RecordRef: RecordRef;
        SelectionFilter: Text;
    begin
        // Get selection filter
        RecordRef.GetTable(StorageJnlLine);
        SelectionFilter := RecordRef.GetView();

        if SelectionFilter = '' then
            Error(NoSelectErrText);

        Window.Open(Text001);

        OnBeforePostBatch(StorageJnlLine);

        // First check all selected lines
        StorageJnlLine.Reset();
        StorageJnlLine.SetView(SelectionFilter);

        if not StorageJnlLine.FindSet() then
            exit;

        repeat
            StorageCheckLine.RunCheck(StorageJnlLine);
            LineCount += 1;
            Window.Update(1, LineCount);
        until StorageJnlLine.Next() = 0;

        // If all lines are valid, then post them
        LineCount := 0;
        StorageJnlLine.FindSet();

        repeat
            if not PostLine(StorageJnlLine) then begin
                ErrorOccurred := true;
                break;
            end;
            LineCount += 1;
            Window.Update(1, LineCount);
        until StorageJnlLine.Next() = 0;

        if not ErrorOccurred then
            DeletePostedLines(SelectionFilter);

        OnAfterPostBatch(StorageJnlLine);

        Window.Close();

        if ErrorOccurred then
            Error(PostErrText);
    end;

    local procedure PostLine(var StorageJournalLine: Record "Storage Journal"): Boolean
    var
        Success: Boolean;
    begin
        Success := true;
        StoragePostLine.RunPostLine(StorageJournalLine);
        exit(Success);
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