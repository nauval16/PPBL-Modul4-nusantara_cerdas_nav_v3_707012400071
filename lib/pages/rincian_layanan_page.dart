import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';

class RincianLayananPage extends StatefulWidget {
  const RincianLayananPage({super.key});

  @override
  State<RincianLayananPage> createState() => _RincianLayananPageState();
}

class _RincianLayananPageState extends State<RincianLayananPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  String? bidangTerpilih;
  bool setujuDataPribadi = false;
  String? sesiTerpilih; // groupValue RadioListTile (state lokal)
  bool sedangMengirim = false;

  bool get emailValid => emailController.text.contains('@');

  bool get formLengkap =>
      namaController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      emailValid &&
      bidangTerpilih != null &&
      sesiTerpilih != null &&
      setujuDataPribadi;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      namaController.clear();
      emailController.clear();
      bidangTerpilih = null;
      sesiTerpilih = null;
      setujuDataPribadi = false;
      sedangMengirim = false;
    });
  }

  Future<void> kirimPengajuan() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final model = context.read<PengajuanModel>();

    setState(() => sedangMengirim = true);

    // Simulasi pengiriman. Ganti baris ini dengan pemanggilan API-mu.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    model.tambah(
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      bidang: bidangTerpilih!,
      sesi: sesiTerpilih!,
    );
    _reset();

    messenger.showSnackBar(
      const SnackBar(content: Text('Pengajuan berhasil dikirim')),
    );
    // Bila dibuka dari FAB (named route), kembali ke halaman Warga.
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final tampilkanErrorEmail =
        emailController.text.isNotEmpty && !emailValid;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.account_balance, size: 40, color: Colors.white),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nusantara Cerdas Mobile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      'Dinas Komunikasi dan Informatika. Ajukan permohonan '
                      'layanan tanpa datang ke balai kota.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Data Pemohon',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: namaController,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: const OutlineInputBorder(),
            errorText:
                tampilkanErrorEmail ? 'Email harus mengandung karakter @' : null,
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: bidangTerpilih,
          decoration: const InputDecoration(
            labelText: 'Bidang Layanan',
            prefixIcon: Icon(Icons.category_outlined),
            border: OutlineInputBorder(),
          ),
          items: PengajuanModel.daftarBidang
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: (nilai) => setState(() => bidangTerpilih = nilai),
        ),
        const SizedBox(height: 20),
        Text('Sesi Kunjungan',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        ...PengajuanModel.daftarSesi.map(
          (sesi) => RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text('Sesi $sesi'),
            value: sesi,
            groupValue: sesiTerpilih,
            onChanged: (nilai) => setState(() => sesiTerpilih = nilai),
          ),
        ),
        const SizedBox(height: 4),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: setujuDataPribadi,
          title: const Text(
              'Saya menyetujui penggunaan data pribadi untuk keperluan pengajuan ini.'),
          onChanged: (nilai) =>
              setState(() => setujuDataPribadi = nilai ?? false),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: (formLengkap && !sedangMengirim) ? kirimPengajuan : null,
            child: sedangMengirim
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Mengirim...'),
                    ],
                  )
                : const Text('Kirim Pengajuan'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
