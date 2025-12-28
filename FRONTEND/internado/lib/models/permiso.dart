enum EstadoPermiso { pendiente, aprobado, rechazado, cancelado }

class Permiso {
  final int? permisoId;
  final String permisoMotivo;
  final int permisoAprendizId;
  final int? permisoAdminId;
  final String? permisoEvidencia;
  final EstadoPermiso permisoEstado;
  final DateTime? permisoFecAprobacion;
  final DateTime? permisoFecRespuesta;
  final String? permisoObservaciones;
  final DateTime? permisoFecSolicitud;
  final DateTime? permisoFecInicio;
  final DateTime? permisoFecFin;
  // Campos adicionales del backend
  final String? adminName;
  final String? adminApe;
  final String? aprendizName;
  final String? aprendizApe;

  Permiso({
    this.permisoId,
    required this.permisoMotivo,
    required this.permisoAprendizId,
    this.permisoAdminId,
    this.permisoEvidencia,
    this.permisoEstado = EstadoPermiso.pendiente,
    this.permisoFecAprobacion,
    this.permisoFecRespuesta,
    this.permisoObservaciones,
    this.permisoFecSolicitud,
    this.permisoFecInicio,
    this.permisoFecFin,
    this.adminName,
    this.adminApe,
    this.aprendizName,
    this.aprendizApe,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
      permisoId: json['permiso_id'],
      permisoMotivo: json['permiso_motivo'] ?? '',
      permisoAprendizId: json['permiso_aprendiz_id'] ?? 0,
      permisoAdminId: json['permiso_admin_id'],
      permisoEvidencia: json['permiso_evidencia'],
      permisoEstado: _mapEstadoFromString(json['permiso_estado']),
      permisoFecAprobacion: json['permiso_fec_aprobacion'] != null
          ? DateTime.parse(json['permiso_fec_aprobacion'])
          : null,
      permisoFecRespuesta: json['permiso_fec_res'] != null
          ? DateTime.parse(json['permiso_fec_res'])
          : null,
      permisoObservaciones: json['permiso_observaciones'],
      permisoFecSolicitud: json['permiso_fec_solic'] != null
          ? DateTime.parse(json['permiso_fec_solic'])
          : null,
      permisoFecInicio: json['permiso_fec_inicio'] != null
          ? DateTime.parse(json['permiso_fec_inicio'])
          : null,
      permisoFecFin: json['permiso_fec_fin'] != null
          ? DateTime.parse(json['permiso_fec_fin'])
          : null,
      adminName: json['admin_name'],
      adminApe: json['admin_ape'],
      aprendizName: json['aprendiz_name'],
      aprendizApe: json['aprendiz_ape'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permiso_id': permisoId,
      'permiso_motivo': permisoMotivo,
      'permiso_aprendiz_id': permisoAprendizId,
      'permiso_admin_id': permisoAdminId,
      'permiso_evidencia': permisoEvidencia,
      'permiso_estado': _mapEstadoToString(permisoEstado),
      'permiso_fec_aprobacion': permisoFecAprobacion?.toIso8601String(),
      'permiso_fec_res': permisoFecRespuesta?.toIso8601String(),
      'permiso_observaciones': permisoObservaciones,
      'permiso_fec_solic': permisoFecSolicitud?.toIso8601String(),
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

  // Getters para nombres completos
  String get adminNombreCompleto => 
      adminName != null && adminApe != null 
          ? '$adminName $adminApe' 
          : 'Administrador';

  String get aprendizNombreCompleto => 
      aprendizName != null && aprendizApe != null 
          ? '$aprendizName $aprendizApe' 
          : 'Aprendiz';

  Permiso copyWith({
    int? permisoId,
    String? permisoMotivo,
    int? permisoAprendizId,
    int? permisoAdminId,
    String? permisoEvidencia,
    EstadoPermiso? permisoEstado,
    DateTime? permisoFecAprobacion,
    DateTime? permisoFecRespuesta,
    String? permisoObservaciones,
    DateTime? permisoFecSolicitud,
    DateTime? permisoFecInicio,
    DateTime? permisoFecFin,
    String? adminName,
    String? adminApe,
    String? aprendizName,
    String? aprendizApe,
  }) {
    return Permiso(
      permisoId: permisoId ?? this.permisoId,
      permisoMotivo: permisoMotivo ?? this.permisoMotivo,
      permisoAprendizId: permisoAprendizId ?? this.permisoAprendizId,
      permisoAdminId: permisoAdminId ?? this.permisoAdminId,
      permisoEvidencia: permisoEvidencia ?? this.permisoEvidencia,
      permisoEstado: permisoEstado ?? this.permisoEstado,
      permisoFecAprobacion: permisoFecAprobacion ?? this.permisoFecAprobacion,
      permisoFecRespuesta: permisoFecRespuesta ?? this.permisoFecRespuesta,
      permisoObservaciones: permisoObservaciones ?? this.permisoObservaciones,
      permisoFecSolicitud: permisoFecSolicitud ?? this.permisoFecSolicitud,
      permisoFecInicio: permisoFecInicio ?? this.permisoFecInicio,
      permisoFecFin: permisoFecFin ?? this.permisoFecFin,
      adminName: adminName ?? this.adminName,
      adminApe: adminApe ?? this.adminApe,
      aprendizName: aprendizName ?? this.aprendizName,
      aprendizApe: aprendizApe ?? this.aprendizApe,
    );
  }
}
