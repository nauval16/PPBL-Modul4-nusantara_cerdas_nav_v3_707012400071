import 'package:flutter/material.dart';

class _Pesan {
  final String teks;
  final bool dariWarga;
  final DateTime waktu;
  _Pesan(this.teks, this.dariWarga) : waktu = DateTime.now();
}

class TanyaPetugasPage extends StatefulWidget {
  const TanyaPetugasPage({super.key});

  @override
  State<TanyaPetugasPage> createState() => _TanyaPetugasPageState();
}

class _TanyaPetugasPageState extends State<TanyaPetugasPage> {
  final pesanController = TextEditingController();
  final List<_Pesan> pesan = [
    _Pesan('Selamat datang di layanan Nusantara Cerdas. Ada yang bisa kami bantu?',
        false),
  ];

  @override
  void dispose() {
    pesanController.dispose();
    super.dispose();
  }

  Future<void> kirimPesan() async {
    final teks = pesanController.text.trim();
    if (teks.isEmpty) return;
    setState(() {
      pesan.add(_Pesan(teks, true));
      pesanController.clear();
    });

    // Balasan otomatis petugas (simulasi).
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      pesan.add(_Pesan(
          'Terima kasih, pesan Anda sudah kami terima. Petugas akan segera menanggapi.',
          false));
    });
  }

  String _jam(DateTime w) =>
      '${w.hour.toString().padLeft(2, '0')}.${w.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: pesan.length,
            itemBuilder: (context, index) {
              final data = pesan[pesan.length - 1 - index];
              return _Gelembung(data: data, jam: _jam(data.waktu));
            },
          ),
        ),
        _KolomInput(controller: pesanController, onKirim: kirimPesan),
      ],
    );
  }
}

class _Gelembung extends StatelessWidget {
  final _Pesan data;
  final String jam;
  const _Gelembung({required this.data, required this.jam});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final warga = data.dariWarga;
    final lebarMaks = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: warga ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: lebarMaks),
        decoration: BoxDecoration(
          color: warga ? skema.primary : skema.secondaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(warga ? 16 : 4),
            bottomRight: Radius.circular(warga ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              warga ? 'Anda' : 'Petugas',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: warga ? skema.onPrimary.withValues(alpha: 0.8)
                    : skema.onSecondaryContainer.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.teks,
              style: TextStyle(
                  color: warga ? skema.onPrimary : skema.onSecondaryContainer),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                jam,
                style: TextStyle(
                  fontSize: 10,
                  color: warga ? skema.onPrimary.withValues(alpha: 0.7)
                      : skema.onSecondaryContainer.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KolomInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onKirim;
  const _KolomInput({required this.controller, required this.onKirim});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onKirim(),
                  decoration: InputDecoration(
                    hintText: 'Tulis pesan untuk petugas...',
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                icon: const Icon(Icons.send),
                tooltip: 'Kirim',
                onPressed: onKirim,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
