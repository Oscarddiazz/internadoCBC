enum EstadoTarea { pendiente, enProceso, completada, cancelada }

class Tarea {
  final int? tareaId;
  final String tareaDescripcion;
  final DateTime tareaFecEntrega;
  final int tareaAprendizId;
  final int? tareaAdminId;
  final String? tareaEvidencia;
  final EstadoTarea tareaEstado;
  final DateTime? tareaFecCompletada;
  final DateTime? tareaFecAsignacion;
  final String? tareaObservaciones;
  // Campos adicionales del backend
  final String? adminName;
  final String? adminApe;
  final String? aprendizName;
  final String? aprendizApe;

  Tarea({
    this.tareaId,
    required this.tareaDescripcion,
    required this.tareaFecEntrega,
    required this.tareaAprendizId,
    this.tareaAdminId,
    this.tareaEvidencia,
    this.tareaEstado = EstadoTarea.pendiente,
    this.tareaFecCompletada,
    this.tareaFecAsignacion,
    this.tareaObservaciones,
    this.adminName,
    this.adminApe,
    this.aprendizName,
    this.aprendizApe,
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
      tareaAdminId: json['tarea_admin_id'],
      tareaEvidencia: json['tarea_evidencia'],
      tareaEstado: _mapEstadoFromString(json['tarea_estado']),
      tareaFecCompletada:
          json['tarea_fec_completado'] != null
              ? DateTime.parse(json['tarea_fec_completado'])
              : null,
      tareaFecAsignacion:
          json['tarea_fec_asignacion'] != null
              ? DateTime.parse(json['tarea_fec_asignacion'])
              : null,
      tareaObservaciones: json['tarea_observaciones'],
      adminName: json['admin_name'],
      adminApe: json['admin_ape'],
      aprendizName: json['aprendiz_name'],
      aprendizApe: json['aprendiz_ape'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tarea_id': tareaId,
      'tarea_descripcion': tareaDescripcion,
      'tarea_fec_entrega': tareaFecEntrega.toIso8601String(),
      'tarea_aprendiz_id': tareaAprendizId,
      'tarea_admin_id': tareaAdminId,
      'tarea_evidencia': tareaEvidencia,
      'tarea_estado': _mapEstadoToString(tareaEstado),
      'tarea_fec_completado': tareaFecCompletada?.toIso8601String(),
      'tarea_fec_asignacion': tareaFecAsignacion?.toIso8601String(),
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
    int? tareaAdminId,
    String? tareaEvidencia,
    EstadoTarea? tareaEstado,
    DateTime? tareaFecCompletada,
    DateTime? tareaFecAsignacion,
    String? tareaObservaciones,
    String? adminName,
    String? adminApe,
    String? aprendizName,
    String? aprendizApe,
  }) {
    return Tarea(
      tareaId: tareaId ?? this.tareaId,
      tareaDescripcion: tareaDescripcion ?? this.tareaDescripcion,
      tareaFecEntrega: tareaFecEntrega ?? this.tareaFecEntrega,
      tareaAprendizId: tareaAprendizId ?? this.tareaAprendizId,
      tareaAdminId: tareaAdminId ?? this.tareaAdminId,
      tareaEvidencia: tareaEvidencia ?? this.tareaEvidencia,
      tareaEstado: tareaEstado ?? this.tareaEstado,
      tareaFecCompletada: tareaFecCompletada ?? this.tareaFecCompletada,
      tareaFecAsignacion: tareaFecAsignacion ?? this.tareaFecAsignacion,
      tareaObservaciones: tareaObservaciones ?? this.tareaObservaciones,
      adminName: adminName ?? this.adminName,
      adminApe: adminApe ?? this.adminApe,
      aprendizName: aprendizName ?? this.aprendizName,
      aprendizApe: aprendizApe ?? this.aprendizApe,
    );
  }
}
