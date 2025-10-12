import "dart:convert";
import 'package:intl/intl.dart';
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sewa_lapangan_app/pages/booking_receipt_page.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:sewa_lapangan_app/utils/utils.dart';
import '../widgets/custom_appbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> filteredBookings = []; // simpan hasil booking yg udh difilter

  // Filter states
  Set<String> selectedCategories = {"All"}; // simpan pilihan filter yg lagi aktif
  Set<String> selectedTypes = {"All"};
  Set<String> selectedStatuses = {"All"};
  Set<String> selectedPaymentMethods = {"All"};

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bookings') ?? [];
    setState(() {
      bookings = list.map<Map<String, dynamic>>((e) {
        try {
          final decoded = jsonDecode(e);
          return Map<String, dynamic>.from(decoded);
        } catch (_) {
          return <String, dynamic>{};
        }
      }).toList().reversed.toList();
      filteredBookings = List.from(bookings);
    });
  }

  void applyFilters() {
    setState(() {
      filteredBookings = bookings.where((booking) {
        // Filter by category
        bool categoryMatch = selectedCategories.contains("All") ||
          selectedCategories.any((category) {
            final court = (booking['court'] ?? "").toString().toLowerCase();
            return court.contains(category.toLowerCase());
          });

        // Filter by type
        bool typeMatch = selectedTypes.contains("All") ||
          selectedTypes.any((type) {
            final courtType = (booking['type'] ?? "").toString().toLowerCase();
            return courtType.contains(type.toLowerCase());
          });

        // Filter by status
        bool statusMatch = selectedStatuses.contains("All") ||
            selectedStatuses.contains(booking['status'] ?? "");

        // Filter by payment method
        final bookingPayment = (booking['paymentMethod'] ?? "Cash").toString();
        bool paymentMatch = selectedPaymentMethods.contains("All") ||
          selectedPaymentMethods.any((payment) =>
          bookingPayment.toLowerCase() == payment.toLowerCase()
          );

        return categoryMatch && typeMatch && statusMatch && paymentMatch;
      }).toList();
    });
  }

  void toggleFilter(Set<String> filterSet, String value) {
    setState(() {
      if (value == "All") {
        filterSet.clear();
        filterSet.add("All");
      } else {
        if (filterSet.contains(value)) { // cek value ada di Set ga?
          filterSet.remove(value);
          if (filterSet.isEmpty) {
            filterSet.add("All");
          }
        } else {
          filterSet.remove("All");
          filterSet.add(value);
          if (filterSet.isEmpty) {
            filterSet.add("All");
          }
        }
      }
      applyFilters();
    });
  }

  IconData getCourtIcon(String courtName) {
    if (courtName.toLowerCase().contains("futsal")) {
      return Icons.sports_soccer;
    } else if (courtName.toLowerCase().contains("basket")) {
      return Icons.sports_basketball;
    } else if (courtName.toLowerCase().contains("badminton")) {
      return Icons.sports_tennis; // pakai tennis icon
    } else if (courtName.toLowerCase().contains("tennis")) {
      return Icons.sports_tennis;
    } else if (courtName.toLowerCase().contains("volleyball")) {
      return Icons.sports_volleyball;
    } else {
      return Icons.sports;
    }
  }


  void _showFilterBottomSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Align(
                alignment: Alignment.topCenter,
                child: Material(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filter",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Color(0xFF1C1C1C)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFFE5E7EB),
                                thickness: 1.5,
                              ),
                              const SizedBox(height: 16),

                              // Court Category
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Court Category",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Court Category Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip("All",
                                    isSelected: selectedCategories.contains("All"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "All");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Futsal",
                                    isSelected: selectedCategories.contains("Futsal"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "Futsal");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Basketball",
                                    isSelected: selectedCategories.contains("Basketball"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "Basketball");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Badminton",
                                    isSelected: selectedCategories.contains("Badminton"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "Badminton");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Tennis",
                                    isSelected: selectedCategories.contains("Tennis"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "Tennis");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Volleyball",
                                    isSelected: selectedCategories.contains("Volleyball"),
                                    onTap: () {
                                      toggleFilter(selectedCategories, "Volleyball");
                                      setModalState(() {});
                                    }
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Court Type Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Court Type",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Court Type Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip("All",
                                    isSelected: selectedTypes.contains("All"),
                                    onTap: () {
                                      toggleFilter(selectedTypes, "All");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Indoor",
                                    isSelected: selectedTypes.contains("Indoor"),
                                    onTap: () {
                                      toggleFilter(selectedTypes, "Indoor");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Outdoor",
                                    isSelected: selectedTypes.contains("Outdoor"),
                                      onTap: () {
                                        toggleFilter(selectedTypes, "Outdoor");
                                        setModalState(() {});
                                      }
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Status Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Status Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip("All",
                                    isSelected: selectedStatuses.contains("All"),
                                    onTap: () {
                                      toggleFilter(selectedStatuses, "All");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Paid",
                                    isSelected: selectedStatuses.contains("Paid"),
                                    onTap: () {
                                      toggleFilter(selectedStatuses, "Paid");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Pending",
                                    isSelected: selectedStatuses.contains("Pending"),
                                    onTap: () {
                                      toggleFilter(selectedStatuses, "Pending");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Cancelled",
                                    isSelected: selectedStatuses.contains("Cancelled"),
                                    onTap: () {
                                      toggleFilter(selectedStatuses, "Cancelled");
                                      setModalState(() {});
                                    }
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Payment Method Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Method",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Payment Method Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip("All",
                                    isSelected: selectedPaymentMethods.contains("All"),
                                    onTap: () {
                                      toggleFilter(selectedPaymentMethods, "All");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("Cash",
                                    isSelected: selectedPaymentMethods.contains("Cash"),
                                    onTap: () {
                                      toggleFilter(selectedPaymentMethods, "Cash");
                                      setModalState(() {});
                                    }
                                  ),
                                  _buildFilterChip("QRIS",
                                    isSelected: selectedPaymentMethods.contains("QRIS"),
                                    onTap: () {
                                      toggleFilter(selectedPaymentMethods, "QRIS");
                                      setModalState(() {});
                                    }
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        )
                    )
                )
            );
          }
        );
      },
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C1C1C) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1C1C1C) : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Order History",
        showBottomLine: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(
                Icons.tune,
                size: 32,
                color: Color(0xFF1C1C1C),
              ),
              onPressed: () => _showFilterBottomSheet(context),
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: filteredBookings.isEmpty
            ? Center(
                child: Text(
                  "No bookings yet",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  final booking = filteredBookings[index];

                  final type = booking['type'] ?? "Unknown Type";
                  final court = booking['court'] ?? "Unknown Court";
                  final dateStr = booking['date'] ?? DateTime.now().toIso8601String();
                  final dateTime = DateTime.tryParse(dateStr) ?? DateTime.now();
                  final formattedDate = DateFormat('d MMM yyyy, h:mm a').format(dateTime);                  final duration = booking['duration'] ?? "0";
                  final totalAmount = booking['totalAmount']?.toString() ?? "0";
                  final totalAmountInt = int.tryParse(booking['totalAmount']?.toString() ?? "0") ?? 0;
                  final paymentMethod = booking['paymentMethod'] ?? "Cash";
                  final status = booking['status'] ?? "Paid";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFC9CDCF), width: 1),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Icon(
                              getCourtIcon(court),
                              size: 40,
                              color: const Color(0xFF1F2937),
                            ),
                            const SizedBox(width: 12),

                            // Main Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    court,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Type: ${type}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Payment Method: $paymentMethod",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Total: Rp${formatRupiah(totalAmountInt)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Duration & Status Badge
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    "$duration h",
                                    style: GoogleFonts.poppins(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1C1C1C),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: status == "Paid"
                                      ? Colors.green.withOpacity(0.1)
                                      : status == "Pending"
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    status,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: status == "Paid"
                                        ? Colors.green
                                        : status == "Pending"
                                          ? Colors.orange
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 2),
                        const SizedBox(height: 8),

                        // See E-Ticket button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingReceiptPage(
                                  court: court,
                                  package: duration,
                                  totalAmount: totalAmountInt,
                                  paymentMethod: paymentMethod,
                                  bookingDate: dateTime,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1C1C1C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "See E-Ticket",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
