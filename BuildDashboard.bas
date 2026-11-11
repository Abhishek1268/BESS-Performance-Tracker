Attribute VB_Name = "Module1"
Sub BuildDashboard()

    Dim csvPath As String
    csvPath = "C:\Users\ABHISHEK PANCHAL\OneDrive\Desktop\SQL Project\bess_performance.csv"
    
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Dashboard")
    ws.Cells.Clear
    
    ' -- 1. Read CSV ------------------------------------------
    Dim fileNum As Integer
    fileNum = FreeFile
    Open csvPath For Input As #fileNum
    
    Dim rowNum As Integer
    rowNum = 1
    Dim line As String
    Dim fields() As String
    
    Do While Not EOF(fileNum)
        Line Input #fileNum, line
        fields = Split(line, ",")
        Dim col As Integer
        For col = 0 To UBound(fields)
            ws.Cells(rowNum, col + 1).Value = Trim(fields(col))
        Next col
        rowNum = rowNum + 1
    Loop
    Close #fileNum
    
    ' -- 2. Format header row ---------------------------------
    With ws.Rows(1)
        .Font.Bold = True
        .Interior.Color = RGB(0, 70, 127)
        .Font.Color = RGB(255, 255, 255)
    End With
    
    ' -- 3. Highlight Below target rows in red ----------------
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    
    Dim i As Long
    For i = 2 To lastRow
        If ws.Cells(i, 9).Value = "Below target" Then
            ws.Rows(i).Interior.Color = RGB(255, 199, 199)
        End If
    Next i
    
    ' -- 4. Autofit columns -----------------------------------
    ws.Columns("A:I").AutoFit
    
    ' -- 5. Efficiency trend chart ----------------------------
    Dim cht As ChartObject
    Set cht = ws.ChartObjects.Add(20, 220, 500, 250)
    
    With cht.Chart
        .ChartType = 4
        .SetSourceData Source:=ws.Range("A1:A11,F1:F11")
        .HasTitle = True
        .ChartTitle.Text = "Efficiency per Cycle (%)"
        .Axes(1).HasTitle = True
        .Axes(1).AxisTitle.Text = "Cycle"
        .Axes(2).HasTitle = True
        .Axes(2).AxisTitle.Text = "Efficiency (%)"
    End With
    
    MsgBox "Dashboard built successfully!"

End Sub
