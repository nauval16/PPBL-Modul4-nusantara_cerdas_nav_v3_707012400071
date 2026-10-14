import 'package:flutter/material.dart';

import '../pages/tanya_petugas_page.dart';
import '../pages/lokasi_kantor_page.dart';
import '../pages/rincian_layanan_page.dart';
import '../pages/statistik_layanan_page.dart';
import '../pages/warga_page.dart';
import 'app_routes.dart';

class _Tujuan {
  final String route;
  final String judul;
  final String label;
  final IconData ikon;
  final IconData ikonAktif;
  final Widget halaman;

  const _Tujuan({
    required this.route,
    required this.judul,
    required this.label,
    required this.ikon,
    required this.ikonAktif,
    required this.halaman,
  });
}

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  // Seluruh halaman didaftarkan sejak awal; nama route dari AppRoutes.
  final List<_Tujuan> _tujuan = const [
    _Tujuan(
      route: AppRoutes.rincianLayanan,
      judul: 'Rincian Layanan',
      label: 'Layanan',
      ikon: Icons.assignment_outlined,
      ikonAktif: Icons.assignment,
      halaman: RincianLayananPage(),
    ),
    _Tujuan(
      route: AppRoutes.warga,
      judul: 'Warga',
      label: 'Warga',
      ikon: Icons.people_outline,
      ikonAktif: Icons.people,
      halaman: WargaPage(),
    ),
    _Tujuan(
      route: AppRoutes.tanyaPetugas,
      judul: 'Tanya Petugas',
      label: 'Petugas',
      ikon: Icons.chat_outlined,
      ikonAktif: Icons.chat,
      halaman: TanyaPetugasPage(),
    ),
    _Tujuan(
      route: AppRoutes.lokasiKantor,
      judul: 'Lokasi Kantor',
      label: 'Lokasi',
      ikon: Icons.map_outlined,
      ikonAktif: Icons.map,
      halaman: LokasiKantorPage(),
    ),
    _Tujuan(
      route: AppRoutes.statistikLayanan,
      judul: 'Statistik Layanan',
      label: 'Statistik',
      ikon: Icons.bar_chart_outlined,
      ikonAktif: Icons.bar_chart,
      halaman: StatistikLayananPage(),
    ),
  ];

  void _pilihTujuan(int indeks) {
    setState(() => _indeksTerpilih = indeks);
  }

  @override
  Widget build(BuildContext context) {
    final bool layarLebar = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(title: Text(_tujuan[_indeksTerpilih].judul)),
      body: layarLebar ? _tataLetakLebar() : _isiHalaman(),
      bottomNavigationBar: layarLebar ? null : _buatBilahBawah(),
    );
  }

  // IndexedStack menjaga isi formulir dan chat saat berpindah tab.
  Widget _isiHalaman() {
    return IndexedStack(
      index: _indeksTerpilih,
      children: _tujuan.map((t) => t.halaman).toList(),
    );
  }

  Widget _buatBilahBawah() {
    return NavigationBar(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      destinations: _tujuan
          .map((t) => NavigationDestination(
                icon: Icon(t.ikon),
                selectedIcon: Icon(t.ikonAktif),
                label: t.label,
              ))
          .toList(),
    );
  }

  // Tata letak layar lebar: rail di kiri, isi halaman di kanan.
  Widget _tataLetakLebar() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          extended: true,
          destinations: _tujuan
              .map((t) => NavigationRailDestination(
                    icon: Icon(t.ikon),
                    selectedIcon: Icon(t.ikonAktif),
                    label: Text(t.label),
                  ))
              .toList(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _isiHalaman()),
      ],
    );
  }
}
