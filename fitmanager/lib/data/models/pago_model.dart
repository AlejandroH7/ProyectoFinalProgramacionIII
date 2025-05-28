class Pago {
  final int? id;
  final int clienteId;
  final String fechaPago;

  Pago({this.id, required this.clienteId, required this.fechaPago});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clienteId': clienteId, 'fechaPago': fechaPago};
  }

  factory Pago.fromMap(Map<String, dynamic> map) {
    return Pago(
      id: map['id'],
      clienteId: map['clienteId'],
      fechaPago: map['fechaPago'],
    );
  }
}
