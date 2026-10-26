// Tugas Rutin 2: Kasir Console (Warung Makan Medan)
// Nama: ................  NIM: ................
import 'dart:io';

typedef Hidangan = ({String nama, String kategori, int harga});
typedef Baris = ({Hidangan item, int jumlah});

const batasDiskon = 100000;
const persenDiskon = 10;

const daftarMenu = <String, Hidangan>{
  'M01': (nama: 'Sup Ayam', kategori: 'Makanan', harga: 25000),
  'M02': (nama: 'Mie Gomak', kategori: 'Makanan', harga: 28000),
  'M03': (nama: 'Pecel Lele', kategori: 'Makanan', harga: 30000),
  'M04': (nama: 'Es Teh Pahit', kategori: 'Minuman', harga: 6000),
  'M05': (nama: 'Jus Alpukat', kategori: 'Minuman', harga: 15000),
  'M06': (nama: 'Pisang Goreng', kategori: 'Camilan', harga: 12000),
};

extension Rupiah on int {
  String get rp =>
      'Rp${toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';
}

void main() {
  print('=== WARUNG MAKAN MEDAN ===');
  for (final e in daftarMenu.entries) {
    print('${e.key}  ${e.value.nama.padRight(16)} ${e.value.harga.rp.padLeft(10)}');
  }

  stdout.write('\nPesanan format JUMLAHxKODE (contoh: 2xM01, 1xM04): ');
  final input = stdin.readLineSync() ?? '';

  final pesanan = <Baris>[];
  final diabaikan = <String>[];

  for (final potong in input.split(',')) {
    final teks = potong.trim();
    if (teks.isEmpty) continue;

    // Pola list: hanya cocok bila hasil split tepat 2 bagian.
    switch (teks.toLowerCase().split('x')) {
      case [final j, final k]:
        {
          final jumlah = int.tryParse(j.trim());
          final item = daftarMenu[k.trim().toUpperCase()];
          if (jumlah != null && jumlah > 0 && item != null) {
            pesanan.add((item: item, jumlah: jumlah));
          } else {
            diabaikan.add(teks);
          }
        }
      default:
        diabaikan.add(teks);
    }
  }

  print('\n--- STRUK ---');
  if (pesanan.isEmpty) {
    print('Tidak ada pesanan yang valid.');
  } else {
    for (final b in pesanan) {
      print('${b.item.nama.padRight(16)} ${b.jumlah} x ${(b.item.harga * b.jumlah).rp.padLeft(10)}');
    }
    final total = pesanan
        .map((b) => b.item.harga * b.jumlah)
        .fold<int>(0, (s, n) => s + n);
    final diskon = total >= batasDiskon ? total * persenDiskon ~/ 100 : 0;
    final kategori = pesanan.map((b) => b.item.kategori).toSet();
    final terbesar = pesanan.reduce(
      (a, b) => a.item.harga * a.jumlah >= b.item.harga * b.jumlah ? a : b,
    );

    print('.' * 36);
    print('Total    : ${total.rp}');
    print('Diskon $persenDiskon%: ${diskon.rp}');
    print('BAYAR    : ${(total - diskon).rp}');
    print('Kategori : ${kategori.join(', ')}');
    print('Belanja terbesar: ${terbesar.item.nama}');
  }
  if (diabaikan.isNotEmpty) print('Diabaikan: ${diabaikan.join(', ')}');
}
