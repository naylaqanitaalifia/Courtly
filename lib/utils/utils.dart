String formatRupiah(int price) {
  return price.toString().replaceAllMapped(
    // ubah angka jd string, ksh titik setiap 3 digit dari blkg
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'), // regex mencari posisi buat titik
    (Match m) => "${m[1]}.", // ganti setiap match pake angka + titik
  );
}
