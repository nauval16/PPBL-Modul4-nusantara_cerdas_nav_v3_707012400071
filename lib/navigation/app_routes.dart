import 'package:flutter/material.dart';

import '../pages/tanya_petugas_page.dart';
import '../pages/rincian_pengajuan_page.dart';
import '../pages/lokasi_kantor_page.dart';
import '../pages/rincian_layanan_page.dart';
import '../pages/statistik_layanan_page.dart';
import '../pages/warga_page.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  static const String beranda = '/';
  static const String rincianLayanan = '/rincian-layanan';
  static const String warga = '/warga';
  static const String tanyaPetugas = '/tanya-petugas';
  static const String lokasiKantor = '/lokasi-kantor';
  static const String statistikLayanan = '/statistik-layanan';
  static const String detailPengajuan = '/detail-pengajuan'; // butuh argumen

  // Route tanpa argumen didaftarkan di sini.
  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      rincianLayanan: (context) =>
          _mandiri('Rincian Layanan', const RincianLayananPage()),
      warga: (context) => _mandiri('Warga', const WargaPage()),
      tanyaPetugas: (context) => _mandiri('Tanya Petugas', const TanyaPetugasPage()),
      lokasiKantor: (context) => _mandiri('Lokasi Kantor', const LokasiKantorPage()),
      statistikLayanan: (context) =>
          _mandiri('Statistik Layanan', const StatistikLayananPage()),
    };
  }

  // Route yang memerlukan argumen (id pengajuan).
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == detailPengajuan && settings.arguments is String) {
      final id = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => RincianPengajuanPage(idPengajuan: id),
      );
    }
    return null;
  }

  // Dipakai ketika nama route tidak terdaftar.
  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Route Tidak Ditemukan')),
        body: Center(child: Text('Route ${settings.name} belum terdaftar.')),
      ),
    );
  }

  // Halaman yang dibuka sendiri (di luar kerangka) diberi AppBar.
  static Widget _mandiri(String judul, Widget isi) {
    return Scaffold(appBar: AppBar(title: Text(judul)), body: isi);
  }
}
