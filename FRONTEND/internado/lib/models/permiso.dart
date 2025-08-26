enum EstadoPermiso { pendiente, aprobado, rechazado, cancelado }

class Permiso {
  final int? permisoId;
  final String permisoMotivo;
  final int permisoAprendizId;
  final String? permisoEvidencia;
  final EstadoPermiso permisoEstado;
  final DateTime? permisoFecAprobacion;
  final String? permisoObservaciones;
  final DateTime permisoFecCreacion;
  final DateTime? permisoFecInicio;
  final DateTime? permisoFecFin;

  Permiso({
    this.permisoId,
    required this.permisoMotivo,
    required this.permisoAprendizId,
    this.permisoEvidencia,
    this.permisoEstado = EstadoPermiso.pendiente,
    this.permisoFecAprobacion,
    this.permisoObservaciones,
    required this.permisoFecCreacion,
    this.permisoFecInicio,
    this.permisoFecFin,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
      permisoId: json['permiso_id'],
      permisoMotivo: json['permiso_motivo'] ?? '',
      permisoAprendizId: json['permiso_aprendiz_id'] ?? 0,
      permisoEvidencia: json['permiso_evidencia'],
      permisoEstado: _mapEstadoFromString(json['permiso_estado']),
      permisoFecAprobacion: json['permiso_fec_aprobacion'] != null
          ? DateTime.parse(json['permiso_fec_aprobacion'])
          : null,
      permisoObservaciones: json['permiso_observaciones'],
      permisoFecCreacion: json['permiso_fec_creacion'] != null
          ? DateTime.parse(json['permiso_fec_creacion'])
          : DateTime.now(),
      permisoFecInicio: json['permiso_fec_inicio'] != null
          ? DateTime.parse(json['permiso_fec_inicio'])
          : null,
      permisoFecFin: json['permiso_fec_fin'] != null
          ? DateTime.parse(json['permiso_fec_fin'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permiso_id': permisoId,
      'permiso_motivo': permisoMotivo,
      'permiso_aprendiz_id': permisoAprendizId,
      'permiso_evidencia': permisoEvidencia,
      'permiso_estado': _mapEstadoToString(permisoEstado),
      'permiso_fec_aprobacion': permisoFecAprobacion?.toIso8601String(),
      'permiso_observaciones': permisoObservaciones,
      'permiso_fec_creacion': permisoFecCreacion.toIso8601String(),
      'permiso_fec_inicio': permisoFecInicio?.toIso8601String(),
      'permiso_fec_fin': permisoFecFin?.toIso8601String(),
    };
  }

  static EstadoPermiso _mapEstadoFromString(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return EstadoPermiso.pendiente;
      case 'aprobado':
        return EstadoPermiso.aprobado;
      case 'rechazado':
        return EstadoPermiso.rechazado;
      case 'cancelado':
        return EstadoPermiso.cancelado;
      default:
        return EstadoPermiso.pendiente;
    }
  }

  static String _mapEstadoToString(EstadoPermiso estado) {
    switch (estado) {
      case EstadoPermiso.pendiente:
        return 'pendiente';
      case EstadoPermiso.aprobado:
        return 'aprobado';
      case EstadoPermiso.rechazado:
        return 'rechazado';
      case EstadoPermiso.cancelado:
        return 'cancelado';
    }
  }

  String get estadoDisplay {
    switch (permisoEstado) {
      case EstadoPermiso.pendiente:
        return 'Pendiente';
      case EstadoPermiso.aprobado:
        return 'Aprobado';
      case EstadoPermiso.rechazado:
        return 'Rechazado';
      case EstadoPermiso.cancelado:
        return 'Cancelado';
    }
  }

  bool get isPendiente => permisoEstado == EstadoPermiso.pendiente;
  bool get isAprobado => permisoEstado == EstadoPermiso.aprobado;
  bool get isRechazado => permisoEstado == EstadoPermiso.rechazado;
  bool get isCancelado => permisoEstado == EstadoPermiso.cancelado;

  bool get isActivo => isAprobado && 
      permisoFecInicio != null && 
      permisoFecFin != null &&
      DateTime.now().isAfter(permisoFecInicio!) &&
      DateTime.now().isBefore(permisoFecFin!);

  bool get isVencido => isAprobado && 
      permisoFecFin != null &&
      DateTime.now().isAfter(permisoFecFin!);

  Permiso copyWith({
    int? permisoId,
    String? permisoMotivo,
    int? permisoAprendizId,
    String? permisoEvidencia,
    EstadoPermiso? permisoEstado,
    DateTime? permisoFecAprobacion,
    String? permisoObservaciones,
    DateTime? permisoFecCreacion,
    DateTime? permisoFecInicio,
    DateTime? permisoFecFin,
  }) {
    return Permiso(
      permisoId: permisoId ?? this.permisoId,
      permisoMotivo: permisoMotivo ?? this.permisoMotivo,
      permisoAprendizId: permisoAprendizId ?? this.permisoAprendizId,
      permisoEvidencia: permisoEvidencia ?? this.permisoEvidencia,
      permisoEstado: permisoEstado ?? this.permisoEstado,
      permisoFecAprobacion: permisoFecAprobacion ?? this.permisoFecAprobacion,
      permisoObservaciones: permisoObservaciones ?? this.permisoObservaciones,
      permisoFecCreacion: permisoFecCreacion ?? this.permisoFecCreacion,
      permisoFecInicio: permisoFecInicio ?? this.permisoFecInicio,
      permisoFecFin: permisoFecFin ?? this.permisoFecFin,
    );
  }
}
