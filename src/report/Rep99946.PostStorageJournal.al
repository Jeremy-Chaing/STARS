report 99946 "Post Storage Journal"
{
    Caption = 'Post Storage Journal';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Storage Journal"; "Storage Journal")
        {
            DataItemTableView = where("Job Queue Created" = const(true));

            trigger OnPreDataItem()
            begin
                if FindSet() then
                    Window.Open(ProcessingMsg);
            end;

            trigger OnAfterGetRecord()
            var
                StoragePostLine: Codeunit "Stor. Jnl. Line-Post Line";
                StorageCheckLine: Codeunit "Stor. Jnl. Line-Check Line";
                ErrorText: Text;
            begin
                LineCount += 1;
                Window.Update(1, LineCount);

                // 檢查分錄
                if not StorageCheckLine.RunCheck("Storage Journal", ErrorText) then
                    Error('合約 %1 檢查失敗：%2', "Contract No.", ErrorText);

                // 過帳分錄
                Clear(StoragePostLine);
                if not StoragePostLine.RunPostLine("Storage Journal", ErrorText) then
                    Error('合約 %1 過帳失敗：%2', "Contract No.", ErrorText);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                if LineCount > 0 then
                    Message(SuccessMsg, LineCount);
            end;
        }
    }

    var
        Window: Dialog;
        LineCount: Integer;
        ProcessingMsg: Label 'Processing journal entries #1######';
        SuccessMsg: Label 'Successfully posted %1 journal entries.';
}