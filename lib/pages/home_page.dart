import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sewa_lapangan_app/pages/history_page.dart";
import "package:sewa_lapangan_app/pages/package_duration_page.dart";
import "package:sewa_lapangan_app/utils/utils.dart";
import '../widgets/custom_appbar.dart';

class Court {
  final String image;
  final String name;
  final String type;
  final String feature;
  final String rating;
  final int price;

  Court({
    required this.image,
    required this.name,
    required this.type,
    required this.feature,
    required this.rating,
    required this.price,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Court> courts = [
    Court(
      image: "assets/images/futsal-court-a.png",
      name: "Futsal Court A",
      type: "Indoor",
      feature: "Air Conditioned",
      rating: "4.8",
      price: 50000,
    ),
    Court(
      image: "assets/images/basketball-court-b.png",
      name: "Basketball Court B",
      type: "Outdoor",
      feature: "Premium Floor",
      rating: "4.7",
      price: 75000,
    ),
    Court(
      image: "assets/images/badminton-court-c.png",
      name: "Badminton Court C",
      type: "Indoor",
      feature: "Wooden Floor",
      rating: "4.9",
      price: 45000,
    ),
    Court(
      image: "assets/images/tennis-court-d.png",
      name: "Tennis Court D",
      type: "Outdoor",
      feature: "Hard Surface",
      rating: "4.9",
      price: 80000,
    ),
    Court(
      image: "assets/images/volleyball-court-e.png",
      name: "Volleyball Court E",
      type: "Indoor",
      feature: "Synthetic Floor",
      rating: "4.9",
      price: 60000,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Sports Courts",
        titlePadding: const EdgeInsets.only(left: 20),
        automaticallyImplyLeading: false,
        showBottomLine: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(
                  Icons.history,
                  size: 32,
                  color: Color(0xFF1C1C1C)
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: courts.length, // jumlah item yg mau ditampilkan 
            itemBuilder: (context, index) { // itemBuilder bikin widget berdasarkan index-nya
              final court = courts[index]; // ambil data berdasarkan index
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
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
                    ClipRRect( // potong gambar sesuai border radius
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image(
                              image: AssetImage(
                                court.image,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      court.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: Colors.amberAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          court.rating,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF1F2937),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "${court.type} • ${court.feature}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // "Rp${NumberFormat("#,###", "id_ID").format(court.price)}/hour",
                                      "Rp${formatRupiah(court.price)}/hour",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),

                                    // select button
                                    SizedBox(
                                      // width: 91,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 4,
                                          ),
                                          backgroundColor: const Color(
                                            0xFF1C1C1C,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                PackageDurationPage(
                                                  court: court,
                                                ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Select",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
