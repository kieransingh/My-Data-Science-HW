Sub Stocksort()
' Declare Current as a worksheet object variable.
Dim ws As Worksheet
Dim ticker As String
Dim volume As Double
Dim Closing_price, Opening_price As Double
Dim summary_volume As Integer
Dim Last_row As Long
Dim year_change As Double
Dim percent_change As Double
Dim final_row As Long



 'Loop through all of the worksheets in the active workbook.
For Each ws In ActiveWorkbook.Worksheets
    ws.Activate
    summary_volume = 2
    Range("I1").Value = "Ticker"
    Range("J1").Value = "Total Volume"
    Range("K1").Value = "Opening Price"
    Range("L1").Value = "Closing Price"
    Range("M1").Value = "Year Change"
    Range("N1").Value = "% Year Change"
    Last_row = Range("A999999").End(xlUp).Row
    'Range.End finds the last non blank cell
For I = 2 To Last_row
'check if the stock ticker is the same as the next'
If Cells(I, 1).Value <> Cells(I + 1, 1).Value Then
    ticker = Cells(I, 1).Value
    volume = volume + Cells(I, 7).Value
    Closing_price = Cells(I, 6).Value
    Range("I" & summary_volume).Value = ticker
    Range("J" & summary_volume).Value = volume
    Cells(summary_volume, 12).Value = Closing_price
    summary_volume = summary_volume + 1
    volume = 0
ElseIf Cells(I - 1, 1).Value <> Cells(I, 1).Value Then
    Opening_price = Cells(I, 3).Value
    Cells(summary_volume, 11).Value = Opening_price
'if ticker is the same then
Else
    volume = volume + Cells(I, 7).Value
End If
Next I

'final_row = range("L65000").End(xlUp).Row

For j = 2 To Range("L999999").End(xlUp).Row
'Range.End finds the last non blank cell'
    Cells(j, 13).Value = Cells(j, 12).Value - Cells(j, 11).Value
    If Cells(j, 12).Value > Cells(j, 11).Value Then
        Cells(j, 13).Interior.ColorIndex = 4
    ElseIf Cells(j, 12).Value < Cells(j, 11).Value Then
        Cells(j, 13).Interior.ColorIndex = 3
    End If
Next j

Next ws


End Sub
