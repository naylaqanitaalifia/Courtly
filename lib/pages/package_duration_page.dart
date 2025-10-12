import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sewa_lapangan_app/pages/home_page.dart";
import "package:sewa_lapangan_app/pages/order_summary.dart";
import "package:sewa_lapangan_app/utils/utils.dart";
import '../widgets/custom_appbar.dart';

class PackageOption {
  final int duration;
  final int price;
  final String description;

  const PackageOption({
    required this.duration,
    required this.price,
    required this.description,
  });
}

class PackageDurationPage extends StatefulWidget {
  final Court court; // menyimpan data court yg dipilih dari homepage

  const PackageDurationPage({
    super.key, 
    required this.court, // wajib kirim data court saat bikin halaman ini
  });

  @override
  State<PackageDurationPage> createState() => _PackageDurationPageState();
}

class _PackageDurationPageState extends State<PackageDurationPage> {

  // fungsi untuk generate package options berdasarkan harga court
  List<PackageOption> _generateOptions() { // hanya dapat diakses dalam class/file itu sendiri
    return [
      PackageOption(
        duration: 1,
        price: widget.court.price * 1, // data dari widget makanya diakses melalui widget. terlebih dahulu
        description: "Perfect for training",
      ),
      PackageOption(
        duration: 2,
        price: widget.court.price * 2,
        description: "Best value for groups",
      ),
      PackageOption(
        duration: 3,
        price: widget.court.price * 3,
        description: "Great for tournaments",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final options = _generateOptions(); // menjalankan fungsi dan simpan ke var options

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Package Duration",
        showBottomLine: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: options.map((option) { // ambil tiap data di options, ubah jadi widget lalu jadikan list taruh di children
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderSummaryPage(
                      court: widget.court,
                      package: option,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${option.duration} ${option.duration > 1 ? 'Hours' : 'Hour'}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Text(
                          "Rp${formatRupiah(option.price)}",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1C1C1C),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          "per session",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
