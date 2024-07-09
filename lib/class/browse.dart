
class Animal {
  final int id;
  final String nama;
  final String keterangan;
  final String foto;
  final int num_interes;
  final String jenis_hewan;

  Animal(
      {required this.id,
      required this.nama,
      required this.keterangan,
      required this.foto,
      required this.num_interes, 
      required this.jenis_hewan});
      
  factory Animal.fromJson(Map<String, dynamic> json) {
  return Animal(
   id: json['id'] as int,
   nama: json['nama'] as String,
   keterangan: json['keterangan'] as String,
   foto: json['foto'] as String,
   num_interes: json['num_interes'] as int,
   jenis_hewan: json['jenis_hewan'] as String,
  );
 }

}