import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final bool selesai;
  const StatusPill({super.key, required this.selesai});

  @override
  Widget build(BuildContext context) {
    final warna = selesai ? Colors.green.shade700 : Colors.blue.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(selesai ? Icons.check_circle : Icons.hourglass_top,
              size: 14, color: warna),
          const SizedBox(width: 4),
          Text(
            selesai ? 'Selesai' : 'Diproses',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: warna),
          ),
        ],
      ),
    );
  }
}
