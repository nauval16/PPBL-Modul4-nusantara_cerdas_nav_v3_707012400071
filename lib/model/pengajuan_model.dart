import 'package:flutter/foundation.dart';

class Pengajuan {
  final String id;
  final String nama;
  final String email;
  final String bidang;
  final String sesi;
  final DateTime waktu;
  final bool selesai;

  const Pengajuan({
    required this.id,
    required this.nama,
    required this.email,
    required this.bidang,
    required this.sesi,
    required this.waktu,
    this.selesai = false,
  });

  Pengajuan copyWith({bool? selesai}) => Pengajuan(
        id: id,
        nama: nama,
        email: email,
        bidang: bidang,
        sesi: sesi,
        waktu: waktu,
        selesai: selesai ?? this.selesai,
      );

  String get waktuTeks {
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${dua(waktu.day)}/${dua(waktu.month)}/${waktu.year} '
        '${dua(waktu.hour)}.${dua(waktu.minute)}';
  }
}

class PengajuanModel extends ChangeNotifier {
  static const List<String> daftarBidang = [
    'Kependudukan',
    'Perizinan',
    'Kesehatan',
    'Pendidikan',
    'Sosial',
  ];
  static const List<String> daftarSesi = ['Pagi', 'Siang', 'Sore'];

  final List<Pengajuan> _daftar = [];

  List<Pengajuan> get daftar => List.unmodifiable(_daftar);
  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((p) => p.selesai).length;
  int get jumlahDiproses => total - jumlahSelesai;

  void tambah({
    required String nama,
    required String email,
    required String bidang,
    required String sesi,
  }) {
    final sekarang = DateTime.now();
    _daftar.insert(
      0,
      Pengajuan(
        id: sekarang.microsecondsSinceEpoch.toString(),
        nama: nama,
        email: email,
        bidang: bidang,
        sesi: sesi,
        waktu: sekarang,
      ),
    );
    notifyListeners();
  }

  Pengajuan? cari(String id) {
    for (final p in _daftar) {
      if (p.id == id) return p;
    }
    return null;
  }

  void tandaiSelesai(String id) {
    final i = _daftar.indexWhere((p) => p.id == id);
    if (i == -1 || _daftar[i].selesai) return;
    _daftar[i] = _daftar[i].copyWith(selesai: true);
    notifyListeners();
  }

  int jumlahBidang(String bidang) =>
      _daftar.where((p) => p.bidang == bidang).length;
}
