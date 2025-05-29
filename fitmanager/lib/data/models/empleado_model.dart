class Empleado {
  final int? id;
  final String nombre;
  final String sexo;
  final String fechaNacimiento;
  final String telefono;
  final String horaEntrada;
  final String horaSalida;
  final String area;
  final String diasTrabajo;
  final String usuario;
  final String clave;

  Empleado({
    this.id,
    required this.nombre,
    required this.sexo,
    required this.fechaNacimiento,
    required this.telefono,
    required this.horaEntrada,
    required this.horaSalida,
    required this.area,
    required this.diasTrabajo,
    required this.usuario,
    required this.clave,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'sexo': sexo,
      'fechaNacimiento': fechaNacimiento,
      'telefono': telefono,
      'horaEntrada': horaEntrada,
      'horaSalida': horaSalida,
      'area': area,
      'diasTrabajo': diasTrabajo,
      'usuario': usuario,
      'clave': clave,
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      id: map['id'],
      nombre: map['nombre'],
      sexo: map['sexo'],
      fechaNacimiento: map['fechaNacimiento'],
      telefono: map['telefono'],
      horaEntrada: map['horaEntrada'],
      horaSalida: map['horaSalida'],
      area: map['area'],
      diasTrabajo: map['diasTrabajo'],
      usuario: map['usuario'],
      clave: map['clave'],
    );
  }
}
