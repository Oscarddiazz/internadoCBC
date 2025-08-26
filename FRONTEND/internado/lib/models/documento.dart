enum TipoDocumento { 
  identificacion, 
  certificado_medico, 
  certificado_academico, 
  carta_presentacion, 
  otros 
}

class Documento {
  final int? documentoId;
  final String documentoNombre;
  final String documentoUrl;
  final TipoDocumento documentoTipo;
  final int documentoUsuarioId;
  final DateTime documentoFecSubida;
  final String? documentoDescripcion;
  final bool documentoActivo;

  Documento({
    this.documentoId,
    required this.documentoNombre,
    required this.documentoUrl,
    required this.documentoTipo,
    required this.documentoUsuarioId,
    required this.documentoFecSubida,
    this.documentoDescripcion,
    this.documentoActivo = true,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      documentoId: json['documento_id'],
      documentoNombre: json['documento_nombre'] ?? '',
      documentoUrl: json['documento_url'] ?? '',
      documentoTipo: _mapTipoFromString(json['documento_tipo']),
      documentoUsuarioId: json['documento_usuario_id'] ?? 0,
      documentoFecSubida: json['documento_fec_subida'] != null
          ? DateTime.parse(json['documento_fec_subida'])
          : DateTime.now(),
      documentoDescripcion: json['documento_descripcion'],
      documentoActivo: json['documento_activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documento_id': documentoId,
      'documento_nombre': documentoNombre,
      'documento_url': documentoUrl,
      'documento_tipo': _mapTipoToString(documentoTipo),
      'documento_usuario_id': documentoUsuarioId,
      'documento_fec_subida': documentoFecSubida.toIso8601String(),
      'documento_descripcion': documentoDescripcion,
      'documento_activo': documentoActivo,
    };
  }

  static TipoDocumento _mapTipoFromString(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'identificacion':
        return TipoDocumento.identificacion;
      case 'certificado_medico':
      case 'certificado médico':
        return TipoDocumento.certificado_medico;
      case 'certificado_academico':
      case 'certificado académico':
        return TipoDocumento.certificado_academico;
      case 'carta_presentacion':
      case 'carta presentación':
        return TipoDocumento.carta_presentacion;
      case 'otros':
        return TipoDocumento.otros;
      default:
        return TipoDocumento.otros;
    }
  }

  static String _mapTipoToString(TipoDocumento tipo) {
    switch (tipo) {
      case TipoDocumento.identificacion:
        return 'identificacion';
      case TipoDocumento.certificado_medico:
        return 'certificado_medico';
      case TipoDocumento.certificado_academico:
        return 'certificado_academico';
      case TipoDocumento.carta_presentacion:
        return 'carta_presentacion';
      case TipoDocumento.otros:
        return 'otros';
    }
  }

  String get tipoDisplay {
    switch (documentoTipo) {
      case TipoDocumento.identificacion:
        return 'Identificación';
      case TipoDocumento.certificado_medico:
        return 'Certificado Médico';
      case TipoDocumento.certificado_academico:
        return 'Certificado Académico';
      case TipoDocumento.carta_presentacion:
        return 'Carta de Presentación';
      case TipoDocumento.otros:
        return 'Otros';
    }
  }

  String get extension {
    final parts = documentoNombre.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension);
  bool get isPdf => extension == 'pdf';
  bool get isDocument => ['doc', 'docx', 'txt', 'rtf'].contains(extension);

  Documento copyWith({
    int? documentoId,
    String? documentoNombre,
    String? documentoUrl,
    TipoDocumento? documentoTipo,
    int? documentoUsuarioId,
    DateTime? documentoFecSubida,
    String? documentoDescripcion,
    bool? documentoActivo,
  }) {
    return Documento(
      documentoId: documentoId ?? this.documentoId,
      documentoNombre: documentoNombre ?? this.documentoNombre,
      documentoUrl: documentoUrl ?? this.documentoUrl,
      documentoTipo: documentoTipo ?? this.documentoTipo,
      documentoUsuarioId: documentoUsuarioId ?? this.documentoUsuarioId,
      documentoFecSubida: documentoFecSubida ?? this.documentoFecSubida,
      documentoDescripcion: documentoDescripcion ?? this.documentoDescripcion,
      documentoActivo: documentoActivo ?? this.documentoActivo,
    );
  }
}
