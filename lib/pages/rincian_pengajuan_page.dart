import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';
import '../widgets/status_pill.dart';

class RincianPengajuanPage extends StatelessWidget {
  final String idPengajuan;
  const RincianPengajuanPage({super.key, required this.idPengajuan});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PengajuanModel>().cari(idPengajuan);

    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Pengajuan')),
      body: p == null
          ? const Center(child: Text('Pengajuan tidak ditemukan.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p.bidang,
                                style:
                                    Theme.of(context).textTheme.titleLarge),
                            StatusPill(selesai: p.selesai),
                          ],
                        ),
                        const Divider(height: 28),
                        _Baris(
                            ikon: Icons.person_outline,
                            label: 'Nama Lengkap',
                            nilai: p.nama),
                        _Baris(
                            ikon: Icons.email_outlined,
                            label: 'Email',
                            nilai: p.email),
                        _Baris(
                            ikon: Icons.schedule,
                            label: 'Sesi Kunjungan',
                            nilai: 'Sesi ${p.sesi}'),
                        _Baris(
                            ikon: Icons.event,
                            label: 'Waktu Pengajuan',
                            nilai: p.waktuTeks),
                        _Baris(
                            ikon: Icons.verified_user_outlined,
                            label: 'Persetujuan Data Pribadi',
                            nilai: 'Disetujui'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Baris extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  const _Baris({required this.ikon, required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(nilai, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
