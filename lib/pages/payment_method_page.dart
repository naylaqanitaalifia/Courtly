import "dart:convert";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sewa_lapangan_app/pages/booking_receipt_page.dart";
import "package:sewa_lapangan_app/pages/home_page.dart";
import "package:sewa_lapangan_app/pages/package_duration_page.dart";
import "package:sewa_lapangan_app/pages/qris_payment.dart";
import "package:shared_preferences/shared_preferences.dart";
import '../widgets/custom_appbar.dart';

class PaymentMethodPage extends StatefulWidget {
  final Court court;
  final PackageOption package;
  final int totalAmount;

  const PaymentMethodPage({
    super.key,
    required this.court,
    required this.package,
    required this.totalAmount,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  Future<void> saveBooking(Map<String, dynamic> bookingData) async { // fungsi async untuk simpan booking, tidak mengembalikan nilai 
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bookings') ?? [];
    list.add(jsonEncode(bookingData));
    await prefs.setStringList('bookings', list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Payment Method",
        showBottomLine: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Payment",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select your preferred payment method",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 24),

            // Cash Payment Option
            PaymentOptionCard(
              iconPath: "assets/icons/cash-icon.png",
              title: "Pay on Location",
              subtitle: "Cash payment",
              description: "Pay with cash when you arrive at the location",
              onTap: () async {
                final booking = {
                  "court": widget.court.name,
                  "type": widget.court.type,
                  "totalAmount": widget.totalAmount,
                  "duration": widget.package.duration.toString(),
                  "paymentMethod": "Cash",
                  "date": DateTime.now().toIso8601String(),
                };

                await saveBooking(booking);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingReceiptPage(
                      court: widget.court,
                      package: widget.package,
                      totalAmount: widget.totalAmount,
                      paymentMethod: "Cash",
                      bookingDate: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // QRIS Payment Option
            PaymentOptionCard(
              iconPath: "assets/icons/qris-icon.png",
              title: "Pay via QRIS",
              subtitle: "Digital payment",
              description: "Scan QR code to pay instantly with your e- wallet",
              onTap: () {

                // onPaymentSuccess("QRIS");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrisPaymentPage(
                      court: widget.court,
                      package: widget.package,
                      totalAmount: widget.totalAmount,
                      bookingDate: DateTime.now(),
                      // onPaymentSuccess: (method) {},
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1C1C1C),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Booking Policy",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      "Your payment method can’t be changed after completing the order",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reusable untuk payment option
class PaymentOptionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onTap;

  const PaymentOptionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      iconPath,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1C1C1C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
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
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFE5E7EB), thickness: 1),
              const SizedBox(height: 12),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
