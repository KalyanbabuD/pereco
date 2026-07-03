import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExcelExportHelper {
  /// Generates an Excel file with the provided data and opens it in the native viewer.
  static Future<void> shareTableExcel({
    required String sheetName,
    required List<String> headers,
    required List<List<String>> data,
    required String filename,
  }) async {
    // Create a new Excel document
    var excel = Excel.createExcel();
    
    // Rename the default sheet
    String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    if (defaultSheet != sheetName) {
      excel.rename(defaultSheet, sheetName);
    }
    
    Sheet sheetObject = excel[sheetName];

    // Append headers
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());
    
    // Style the header row (bold)
    for (int col = 0; col < headers.length; col++) {
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.cellStyle = CellStyle(bold: true);
    }

    // Append data rows
    for (var row in data) {
      sheetObject.appendRow(row.map((e) => TextCellValue(e)).toList());
    }

    // Generate the bytes
    var fileBytes = excel.save();

    if (fileBytes != null) {
      // Save the file to the temporary directory
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/$filename';
      final file = File(path);
      
      await file.writeAsBytes(fileBytes);
      
      // Use open_file to launch the file directly
      await OpenFile.open(path);
    }
  }
}
