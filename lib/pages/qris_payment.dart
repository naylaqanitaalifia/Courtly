import "dart:convert";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sewa_lapangan_app/pages/home_page.dart";
import "package:sewa_lapangan_app/pages/booking_receipt_page.dart";
import "package:sewa_lapangan_app/pages/package_duration_page.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sewa_lapangan_app/utils/utils.dart";
import '../widgets/custom_appbar.dart';

class QrisPaymentPage extends StatelessWidget {
  final Court court;
  final PackageOption package;
  final int totalAmount;
  final DateTime bookingDate;

  QrisPaymentPage({
    super.key,
    required this.court,
    required this.package,
    required this.totalAmount,
    required this.bookingDate,
  });

  Future<void> saveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bookings') ?? [];

    final booking = {
      "paymentMethod": "QRIS",
      "court": court.name,
      "type": court.type,
      "totalAmount": totalAmount,
      "duration": package.duration.toString(),
      "bookingDate": DateTime.now().toIso8601String(),
    };

    list.add(jsonEncode(booking));
    await prefs.setStringList('bookings', list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "QRIS Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Payment Amount",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Rp${formatRupiah(totalAmount)}",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset("assets/images/qr.png", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    "Scan to Pay",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Point your camera at the QR code",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Open your mobile banking or e-wallet app and scan the QR code above to complete your payment",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  backgroundColor: const Color(0xFF1C1C1C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  await saveBooking();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingReceiptPage(
                        court: court,
                        package: package,
                        totalAmount: totalAmount,
                        paymentMethod: "QRIS",
                        bookingDate: bookingDate,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                label: Text(
                  "I Have Paid",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [ 
                Icon(
                  Icons.share, 
                  color: const Color(0xFF6B7280), 
                  size: 20
                ), 
                const SizedBox(width: 4), 
                Text(
                  "Share", 
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    fontWeight: FontWeight.w400, 
                    color: const Color(0xFF6B7280), 
                  ), 
                ), 
                const SizedBox(width: 24), 
                Icon(
                  Icons.download_outlined,
                  color: const Color(0xFF6B7280), 
                  size: 20
                ), 
                const SizedBox(width: 4), 
                Text(
                  "Save", 
                  style: GoogleFonts.poppins( 
                    fontSize: 14, 
                    fontWeight: FontWeight.w400, 
                    color: const Color(0xFF6B7280), 
                  ), 
                ), 
              ], 
            ),
          ],
        ),
      ),
    );
  }
}
