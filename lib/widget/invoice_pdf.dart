import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:product_app/model/product.dart';

class InvoicePdfWidget {
  static Future<pw.Document> generateInvoicePdf(
      String orderId, String orderDate, String userAddress, List<Product> orderedItems, String orderUsername) async {
    final pdf = pw.Document();

    final finalAddress = userAddress.split(',');
    final addressLine1 = finalAddress.length >= 2
        ? "${finalAddress[0].trim()}, ${finalAddress[1].trim()}"
        : userAddress;
    final addressLine2 = finalAddress.length >= 4
        ? "${finalAddress[2].trim()}, ${finalAddress[3].trim()}"
        : "";

    final List<List<String>> tableData = orderedItems.map((item) {
      return [
        item.title,
        "1",
        "\$${item.price.toString()}",
        "\$${item.price.toString()}"
      ];
    }).toList();

    final double subtotal =
        orderedItems.fold(0.0, (sum, item) => sum + item.price);
    final double tax = subtotal * 0.1;
    final double total = subtotal + tax;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(margin: pw.EdgeInsets.all(32)),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Invoice', style:const pw.TextStyle(fontSize: 24)),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('E-commerce App',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('123, AM Company'),
                  pw.SizedBox(height: 4),
                  pw.Text('Mumbai, India'),
                  pw.SizedBox(height: 4),
                  pw.Text('Email: am@gmail.com'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Order ID: $orderId',
                      style: pw.TextStyle(fontSize: 13)),
                  pw.SizedBox(height: 4),
                  pw.Text('Order Date: $orderDate'),
                  pw.SizedBox(height: 4),
                  pw.Text('Invoice Date: 2025-03-22'),
                  pw.SizedBox(height: 4),
                  pw.Text('Due Date: 2025-10-05'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Bill To:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              )),
          pw.SizedBox(height: 4),
          pw.Text(orderUsername),
          pw.Text(addressLine1),
          pw.Text(addressLine2),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey),
            headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
            data: tableData,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellPadding: const pw.EdgeInsets.all(8),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Tax (10%): \$${tax.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Total: \$${total.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontStyle: pw.FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
    return pdf;
  }
}