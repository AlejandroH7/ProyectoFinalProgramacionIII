class Cliente {
  int? id;
  String nombre;
  String sexo;
  String fechaNacimiento;
  String telefono;
  String fechaInicioMembresia;
  String estado;

  Cliente({
    this.id,
    required this.nombre,
    required this.sexo,
    required this.fechaNacimiento,
    required this.telefono,
    required this.fechaInicioMembresia,
    required this.estado,
  });

  // Convertir Cliente en Map (para guardar en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'sexo': sexo,
      'fechaNacimiento': fechaNacimiento,
      'telefono': telefono,
      'fechaInicioMembresia': fechaInicioMembresia,
      'estado': estado,
    };
  }

  // Convertir un Map en objeto Cliente (cuando se lee desde SQLite)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
      sexo: map['sexo'],
      fechaNacimiento: map['fechaNacimiento'],
      telefono: map['telefono'],
      fechaInicioMembresia: map['fechaInicioMembresia'],
      estado: map['estado'],
    );
  }

  get codigo => null;
}
