enum EstadoTarea { pendiente, enProceso, completada, cancelada }

class Tarea {
  final int? tareaId;
  final String tareaDescripcion;
  final DateTime tareaFecEntrega;
  final int tareaAprendizId;
  final String? tareaEvidencia;
  final EstadoTarea tareaEstado;
  final DateTime? tareaFecCompletada;
  final DateTime tareaFecCreacion;
  final String? tareaObservaciones;

  Tarea({
    this.tareaId,
    required this.tareaDescripcion,
    required this.tareaFecEntrega,
    required this.tareaAprendizId,
    this.tareaEvidencia,
    this.tareaEstado = EstadoTarea.pendiente,
    this.tareaFecCompletada,
    required this.tareaFecCreacion,
    this.tareaObservaciones,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      tareaId: json['tarea_id'],
      tareaDescripcion: json['tarea_descripcion'] ?? '',
      tareaFecEntrega:
          json['tarea_fec_entrega'] != null
              ? DateTime.parse(json['tarea_fec_entrega'])
              : DateTime.now(),
      tareaAprendizId: json['tarea_aprendiz_id'] ?? 0,
      tareaEvidencia: json['tarea_evidencia'],
      tareaEstado: _mapEstadoFromString(json['tarea_estado']),
      tareaFecCompletada:
          json['tarea_fec_completada'] != null
              ? DateTime.parse(json['tarea_fec_completada'])
              : null,
      tareaFecCreacion:
          json['tarea_fec_creacion'] != null
              ? DateTime.parse(json['tarea_fec_creacion'])
              : DateTime.now(),
      tareaObservaciones: json['tarea_observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tarea_id': tareaId,
      'tarea_descripcion': tareaDescripcion,
      'tarea_fec_entrega': tareaFecEntrega.toIso8601String(),
      'tarea_aprendiz_id': tareaAprendizId,
      'tarea_evidencia': tareaEvidencia,
      'tarea_estado': _mapEstadoToString(tareaEstado),
      'tarea_fec_completada': tareaFecCompletada?.toIso8601String(),
      'tarea_fec_creacion': tareaFecCreacion.toIso8601String(),
      'tarea_observaciones': tareaObservaciones,
    };
  }

  static EstadoTarea _mapEstadoFromString(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return EstadoTarea.pendiente;
      case 'en_proceso':
      case 'en proceso':
        return EstadoTarea.enProceso;
      case 'completada':
        return EstadoTarea.completada;
      case 'cancelada':
        return EstadoTarea.cancelada;
      default:
        return EstadoTarea.pendiente;
    }
  }

  static String _mapEstadoToString(EstadoTarea estado) {
    switch (estado) {
      case EstadoTarea.pendiente:
        return 'pendiente';
      case EstadoTarea.enProceso:
        return 'en_proceso';
      case EstadoTarea.completada:
        return 'completada';
      case EstadoTarea.cancelada:
        return 'cancelada';
    }
  }

  String get estadoDisplay {
    switch (tareaEstado) {
      case EstadoTarea.pendiente:
        return 'Pendiente';
      case EstadoTarea.enProceso:
        return 'En Proceso';
      case EstadoTarea.completada:
        return 'Completada';
      case EstadoTarea.cancelada:
        return 'Cancelada';
    }
  }

  bool get isCompletada => tareaEstado == EstadoTarea.completada;
  bool get isPendiente => tareaEstado == EstadoTarea.pendiente;
  bool get isEnProceso => tareaEstado == EstadoTarea.enProceso;
  bool get isCancelada => tareaEstado == EstadoTarea.cancelada;

  bool get isVencida =>
      DateTime.now().isAfter(tareaFecEntrega) && !isCompletada;
  bool get isProximaVencer =>
      DateTime.now().isAfter(tareaFecEntrega.subtract(Duration(days: 1))) &&
      !isCompletada;

  Tarea copyWith({
    int? tareaId,
    String? tareaDescripcion,
    DateTime? tareaFecEntrega,
    int? tareaAprendizId,
    String? tareaEvidencia,
    EstadoTarea? tareaEstado,
    DateTime? tareaFecCompletada,
    DateTime? tareaFecCreacion,
    String? tareaObservaciones,
  }) {
    return Tarea(
      tareaId: tareaId ?? this.tareaId,
      tareaDescripcion: tareaDescripcion ?? this.tareaDescripcion,
      tareaFecEntrega: tareaFecEntrega ?? this.tareaFecEntrega,
      tareaAprendizId: tareaAprendizId ?? this.tareaAprendizId,
      tareaEvidencia: tareaEvidencia ?? this.tareaEvidencia,
      tareaEstado: tareaEstado ?? this.tareaEstado,
      tareaFecCompletada: tareaFecCompletada ?? this.tareaFecCompletada,
      tareaFecCreacion: tareaFecCreacion ?? this.tareaFecCreacion,
      tareaObservaciones: tareaObservaciones ?? this.tareaObservaciones,
    );
  }
}
