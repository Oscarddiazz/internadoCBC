enum EstadoEntrega { pendiente, entregada, cancelada, no_entregada }

class EntregaComida {
  final int? entregaId;
  final int entregaAprendizId;
  final DateTime entregaFecha;
  final String entregaTipo; // desayuno, almuerzo, cena
  final EstadoEntrega entregaEstado;
  final DateTime? entregaFecEntrega;
  final String? entregaObservaciones;
  final DateTime entregaFecCreacion;

  EntregaComida({
    this.entregaId,
    required this.entregaAprendizId,
    required this.entregaFecha,
    required this.entregaTipo,
    this.entregaEstado = EstadoEntrega.pendiente,
    this.entregaFecEntrega,
    this.entregaObservaciones,
    required this.entregaFecCreacion,
  });

  factory EntregaComida.fromJson(Map<String, dynamic> json) {
    return EntregaComida(
      entregaId: json['entrega_id'],
      entregaAprendizId: json['entrega_aprendiz_id'] ?? 0,
      entregaFecha: json['entrega_fecha'] != null
          ? DateTime.parse(json['entrega_fecha'])
          : DateTime.now(),
      entregaTipo: json['entrega_tipo'] ?? '',
      entregaEstado: _mapEstadoFromString(json['entrega_estado']),
      entregaFecEntrega: json['entrega_fec_entrega'] != null
          ? DateTime.parse(json['entrega_fec_entrega'])
          : null,
      entregaObservaciones: json['entrega_observaciones'],
      entregaFecCreacion: json['entrega_fec_creacion'] != null
          ? DateTime.parse(json['entrega_fec_creacion'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entrega_id': entregaId,
      'entrega_aprendiz_id': entregaAprendizId,
      'entrega_fecha': entregaFecha.toIso8601String(),
      'entrega_tipo': entregaTipo,
      'entrega_estado': _mapEstadoToString(entregaEstado),
      'entrega_fec_entrega': entregaFecEntrega?.toIso8601String(),
      'entrega_observaciones': entregaObservaciones,
      'entrega_fec_creacion': entregaFecCreacion.toIso8601String(),
    };
  }

  static EstadoEntrega _mapEstadoFromString(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return EstadoEntrega.pendiente;
      case 'entregada':
        return EstadoEntrega.entregada;
      case 'cancelada':
        return EstadoEntrega.cancelada;
      case 'no_entregada':
      case 'no entregada':
        return EstadoEntrega.no_entregada;
      default:
        return EstadoEntrega.pendiente;
    }
  }

  static String _mapEstadoToString(EstadoEntrega estado) {
    switch (estado) {
      case EstadoEntrega.pendiente:
        return 'pendiente';
      case EstadoEntrega.entregada:
        return 'entregada';
      case EstadoEntrega.cancelada:
        return 'cancelada';
      case EstadoEntrega.no_entregada:
        return 'no_entregada';
    }
  }

  String get estadoDisplay {
    switch (entregaEstado) {
      case EstadoEntrega.pendiente:
        return 'Pendiente';
      case EstadoEntrega.entregada:
        return 'Entregada';
      case EstadoEntrega.cancelada:
        return 'Cancelada';
      case EstadoEntrega.no_entregada:
        return 'No Entregada';
    }
  }

  String get tipoDisplay {
    switch (entregaTipo.toLowerCase()) {
      case 'desayuno':
        return 'Desayuno';
      case 'almuerzo':
        return 'Almuerzo';
      case 'cena':
        return 'Cena';
      default:
        return entregaTipo;
    }
  }

  bool get isPendiente => entregaEstado == EstadoEntrega.pendiente;
  bool get isEntregada => entregaEstado == EstadoEntrega.entregada;
  bool get isCancelada => entregaEstado == EstadoEntrega.cancelada;
  bool get isNoEntregada => entregaEstado == EstadoEntrega.no_entregada;

  bool get isHoy =>
      entregaFecha.day == DateTime.now().day &&
      entregaFecha.month == DateTime.now().month &&
      entregaFecha.year == DateTime.now().year;

  bool get isPasada => entregaFecha.isBefore(DateTime.now());

  EntregaComida copyWith({
    int? entregaId,
    int? entregaAprendizId,
    DateTime? entregaFecha,
    String? entregaTipo,
    EstadoEntrega? entregaEstado,
    DateTime? entregaFecEntrega,
    String? entregaObservaciones,
    DateTime? entregaFecCreacion,
  }) {
    return EntregaComida(
      entregaId: entregaId ?? this.entregaId,
      entregaAprendizId: entregaAprendizId ?? this.entregaAprendizId,
      entregaFecha: entregaFecha ?? this.entregaFecha,
      entregaTipo: entregaTipo ?? this.entregaTipo,
      entregaEstado: entregaEstado ?? this.entregaEstado,
      entregaFecEntrega: entregaFecEntrega ?? this.entregaFecEntrega,
      entregaObservaciones: entregaObservaciones ?? this.entregaObservaciones,
      entregaFecCreacion: entregaFecCreacion ?? this.entregaFecCreacion,
    );
  }
}
