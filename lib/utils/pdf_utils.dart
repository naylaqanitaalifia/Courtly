import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future<void> downloadReceipt({
  required String courtName,
  required DateTime date,
  required String paymentMethod,
  required int totalAmount,
}) async {
  final pdf = pw.Document();
  final formattedDate = DateFormat('d MMM yyyy, h:mm a').format(date);

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Booking Receipt",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Court: $courtName", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Date: $formattedDate", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Payment Method: $paymentMethod", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Total: Rp${NumberFormat("#,###", "id_ID").format(totalAmount)}", style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 24),
              pw.Text(
                "Thank you for your booking!",
                style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
            ],
          ),
        );
      },
    ),
  );

  // Tampilkan dialog share/download PDF
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
  );
}
