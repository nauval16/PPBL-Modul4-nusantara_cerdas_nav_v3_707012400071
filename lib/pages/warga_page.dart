import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';
import '../navigation/app_routes.dart';
import '../widgets/status_pill.dart';

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final daftar = model.daftar;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // Named route, bukan Navigator.push ke kelas halaman.
        onPressed: () => Navigator.pushNamed(context, AppRoutes.rincianLayanan),
        icon: const Icon(Icons.add),
        label: const Text('Pengajuan Baru'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Row(
            children: [
              _Ringkasan(label: 'Total', nilai: model.total, ikon: Icons.inbox),
              const SizedBox(width: 10),
              _Ringkasan(
                  label: 'Diproses',
                  nilai: model.jumlahDiproses,
                  ikon: Icons.hourglass_top),
              const SizedBox(width: 10),
              _Ringkasan(
                  label: 'Selesai',
                  nilai: model.jumlahSelesai,
                  ikon: Icons.check_circle_outline),
            ],
          ),
          const SizedBox(height: 20),
          Text('Riwayat Pengajuan',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            'Ketuk untuk melihat rincian, tahan untuk menandai selesai.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (daftar.isEmpty)
            const _KosongView()
          else
            ...daftar.map((p) => _KartuRiwayat(pengajuan: p)),
        ],
      ),
    );
  }
}

class _Ringkasan extends StatelessWidget {
  final String label;
  final int nilai;
  final IconData ikon;
  const _Ringkasan(
      {required this.label, required this.nilai, required this.ikon});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        elevation: 0,
        color: skema.surfaceContainerHighest.withValues(alpha: 0.6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(ikon, color: skema.primary),
              const SizedBox(height: 6),
              Text('$nilai',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _KosongView extends StatelessWidget {
  const _KosongView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.description_outlined,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('Belum ada pengajuan.'),
          const Text('Tekan tombol "Pengajuan Baru" untuk memulai.'),
        ],
      ),
    );
  }
}

class _KartuRiwayat extends StatelessWidget {
  final Pengajuan pengajuan;
  const _KartuRiwayat({required this.pengajuan});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.detailPengajuan,
        arguments: pengajuan.id,
      ),
      onLongPress: () {
        final model = context.read<PengajuanModel>();
        final pesan = pengajuan.selesai
            ? 'Pengajuan ini sudah ditandai selesai.'
            : 'Pengajuan ditandai selesai ditindaklanjuti.';
        model.tandaiSelesai(pengajuan.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(pesan)));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: skema.primaryContainer,
                child: Icon(Icons.description, color: skema.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pengajuan.bidang,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(pengajuan.nama),
                    Text(
                      'Sesi ${pengajuan.sesi} • ${pengajuan.waktuTeks}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              StatusPill(selesai: pengajuan.selesai),
            ],
          ),
        ),
      ),
    );
  }
}
