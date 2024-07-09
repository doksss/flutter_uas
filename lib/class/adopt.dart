
class Adopts {
  final int id;
  final String nama;
  final String keterangan;
  final String foto;
  final int num_interes;
  final String jenis_hewan;
  final String status;

  Adopts(
      {required this.id,
      required this.nama,
      required this.keterangan,
      required this.foto,
      required this.num_interes, 
      required this.jenis_hewan,
      required this.status,
      });
      
  factory Adopts.fromJson(Map<String, dynamic> json) {
  return Adopts(
   id: json['id'] as int,
   nama: json['nama'] as String,
   keterangan: json['keterangan'] as String,
   foto: json['foto'] as String,
   num_interes: json['num_interes'] as int,
   jenis_hewan: json['jenis_hewan'] as String,
   status: json['status'] as String,
  );
 }

}