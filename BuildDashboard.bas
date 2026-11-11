Attribute VB_Name = "Module1"
Sub BuildAllSheets()

    ' -- File paths — update these to match your folder ------
    Dim path1 As String
    Dim path2 As String
    Dim path3 As String
    Dim path4 As String

    path1 = "C:\Users\ABHISHEK PANCHAL\OneDrive\Desktop\SQL Project\bess_performance.csv"
    path2 = "C:\Users\ABHISHEK PANCHAL\OneDrive\Desktop\SQL Project\monthly_summary.csv"
    path3 = "C:\Users\ABHISHEK PANCHAL\OneDrive\Desktop\SQL Project\degradation_trend.csv"
    path4 = "C:\Users\ABHISHEK PANCHAL\OneDrive\Desktop\SQL Project\peak_shaving_savings.csv"
    ' -- Load all 4 sheets ------------------------------------
    Call LoadCSVToSheet(path1, "Dashboard")
    Call LoadCSVToSheet(path2, "Monthly")
    Call LoadCSVToSheet(path3, "Degradation")
    Call LoadCSVToSheet(path4, "Peak Shaving")

    ' -- Format all sheets ------------------------------------
    Call FormatSheet("Dashboard")
    Call FormatSheet("Monthly")
    Call FormatSheet("Degradation")
    Call FormatSheet("Peak Shaving")

    ' -- Highlight Below target on Dashboard ------------------
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Dashboard")
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    Dim i As Long
    For i = 2 To lastRow
        If ws.Cells(i, 9).Value = "Below target" Then
            ws.Rows(i).Interior.Color = RGB(255, 199, 199)
        End If
    Next i

    ' -- Charts -----------------------------------------------
    Call BuildEfficiencyChart
    Call BuildDegradationChart
    Call BuildPeakShavingChart

    MsgBox "All sheets built successfully!"

End Sub

' -- Helper: Load CSV into a named sheet ----------------------
Sub LoadCSVToSheet(csvPath As String, sheetName As String)
    Dim ws As Worksheet
    
    Set ws = ThisWorkbook.Sheets(sheetName)
    ws.Cells.Clear

    Dim fileNum As Integer
    fileNum = FreeFile
    Open csvPath For Input As #fileNum

    Dim rowNum As Long
    rowNum = 1
    Dim line As String
    Dim fields() As String

    Do While Not EOF(fileNum)
        Line Input #fileNum, line
        If Trim(line) <> "" Then
            fields = Split(line, ",")
            Dim col As Integer
            For col = 0 To UBound(fields)
                ws.Cells(rowNum, col + 1).Value = Trim(fields(col))
            Next col
            rowNum = rowNum + 1
        End If
    Loop
    Close #fileNum
End Sub

' -- Helper: Format header row of a sheet ---------------------
Sub FormatSheet(sheetName As String)
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets(sheetName)

    With ws.Rows(1)
        .Font.Bold = True
        .Interior.Color = RGB(0, 70, 127)
        .Font.Color = RGB(255, 255, 255)
    End With

    ws.Cells.EntireColumn.AutoFit
End Sub

' -- Chart 1: Efficiency trend — Dashboard sheet --------------
Sub BuildEfficiencyChart()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Dashboard")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    Dim cht As ChartObject
    Set cht = ws.ChartObjects.Add(20, (lastRow + 2) * 15, 500, 250)

    With cht.Chart
        .ChartType = 4
        .SetSourceData Source:=ws.Range("A1:A" & lastRow & ",F1:F" & lastRow)
        .HasTitle = True
        .ChartTitle.Text = "Efficiency per Cycle (%) — 730 Cycles"
        .Axes(1).HasTitle = True
        .Axes(1).AxisTitle.Text = "Cycle"
        .Axes(2).HasTitle = True
        .Axes(2).AxisTitle.Text = "Efficiency (%)"
    End With
End Sub

' -- Chart 2: Degradation trend — Degradation sheet -----------
Sub BuildDegradationChart()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Degradation")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    Dim cht As ChartObject
    Set cht = ws.ChartObjects.Add(20, (lastRow + 2) * 15, 500, 250)

    With cht.Chart
        .ChartType = 4
        .SetSourceData Source:=ws.Range("B1:C" & lastRow)
        .HasTitle = True
        .ChartTitle.Text = "Efficiency Degradation Over Time (%)"
        .Axes(1).HasTitle = True
        .Axes(1).AxisTitle.Text = "Month"
        .Axes(2).HasTitle = True
        .Axes(2).AxisTitle.Text = "Avg Efficiency (%)"
    End With
End Sub

' -- Chart 3: Net savings — Peak Shaving sheet ----------------
Sub BuildPeakShavingChart()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Peak Shaving")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    Dim cht As ChartObject
    Set cht = ws.ChartObjects.Add(20, (lastRow + 2) * 15, 500, 250)

    With cht.Chart
        .ChartType = 51
        .SetSourceData Source:=ws.Range("B1:B" & lastRow & ",E1:E" & lastRow)
        .HasTitle = True
        .ChartTitle.Text = "Monthly Net Savings from Peak Shaving (EUR)"
        .Axes(1).HasTitle = True
        .Axes(1).AxisTitle.Text = "Month"
        .Axes(2).HasTitle = True
        .Axes(2).AxisTitle.Text = "Net Saving (EUR)"
    End With
End Sub
