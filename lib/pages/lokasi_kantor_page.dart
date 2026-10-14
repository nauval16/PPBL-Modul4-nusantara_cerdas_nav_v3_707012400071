import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _Kantor {
  final String id;
  final String nama;
  final String alamat;
  final LatLng posisi;
  const _Kantor(this.id, this.nama, this.alamat, this.posisi);
}

class LokasiKantorPage extends StatefulWidget {
  const LokasiKantorPage({super.key});

  @override
  State<LokasiKantorPage> createState() => _LokasiKantorPageState();
}

class _LokasiKantorPageState extends State<LokasiKantorPage> {
  // Koordinat contoh; sesuaikan dengan kantor layanan yang diinginkan.
  static const List<_Kantor> _daftarKantor = [
    _Kantor('pusat', 'Kantor Layanan Pusat (Balai Kota)',
        'Jl. Wastukencana, Bandung', LatLng(-6.9134, 107.6101)),
    _Kantor('utara', 'Kantor Layanan Wilayah Utara',
        'Kawasan Dago, Bandung', LatLng(-6.8873, 107.6130)),
    _Kantor('selatan', 'Kantor Layanan Wilayah Selatan',
        'Kawasan Buahbatu, Bandung', LatLng(-6.9525, 107.6190)),
    _Kantor('timur', 'Kantor Layanan Wilayah Timur',
        'Kawasan Cicaheum, Bandung', LatLng(-6.9175, 107.6600)),
  ];

  static const CameraPosition _kameraAwal = CameraPosition(
    target: LatLng(-6.9150, 107.6100),
    zoom: 12,
  );

  GoogleMapController? _kontrol;

  late final Set<Marker> markers = _daftarKantor
      .map((k) => Marker(
            markerId: MarkerId(k.id),
            position: k.posisi,
            infoWindow: InfoWindow(title: k.nama, snippet: k.alamat),
          ))
      .toSet();

  Future<void> _fokusKe(_Kantor k) async {
    await _kontrol?.animateCamera(CameraUpdate.newLatLngZoom(k.posisi, 15));
    await _kontrol?.showMarkerInfoWindow(MarkerId(k.id));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kameraAwal,
          markers: markers,
          onMapCreated: (c) => _kontrol = c,
          zoomControlsEnabled: false,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _daftarKantor.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final k = _daftarKantor[i];
              return SizedBox(
                width: 240,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _fokusKe(k),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(k.nama,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(k.alamat,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
