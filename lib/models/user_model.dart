class UserModel {
  final String id;
  final String email;
  final String nombre;
  final String tipo;
  final String? fotoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.nombre,
    required this.tipo,
    this.fotoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? 'paciente',
      fotoUrl: map['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'nombre': nombre, 'tipo': tipo, 'fotoUrl': fotoUrl};
  }
}
