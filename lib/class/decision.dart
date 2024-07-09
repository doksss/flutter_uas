class Decisions {
  final int id;
  String nama;
  String keterangan;
  String foto;
  int num_interes;
  String jenis_hewan;
  List? adopters;

  Decisions(
      {required this.id,
      required this.nama,
      required this.keterangan,
      required this.foto,
      required this.num_interes,
      required this.jenis_hewan,
      this.adopters});

  factory Decisions.fromJson(Map<String, dynamic> json) {
    return Decisions(
      id: json['id'] as int,
      nama: json['nama'] as String,
      keterangan: json['keterangan'] as String,
      foto: json['foto'] as String,
      num_interes: json['num_interes'] as int,
      jenis_hewan: json['jenis_hewan'] as String,
      adopters: json['adopter']
    );
  }
}
