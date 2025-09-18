enum RolType { administrador, delegado, aprendiz }

enum DiscapacidadType { visual, auditiva, fisica, ninguna }

enum EtapaType { lectiva, productiva }

enum GeneroType { masculino, femenino }

enum EtniaType { indigina, afrodescendiente, noAplica }

class Usuario {
  final int? userId;
  final String userNumIdent;
  final String userName;
  final String userApe;
  final String userEmail;
  final String? userTel;
  final String userPass;
  final RolType userRol;
  final DiscapacidadType userDiscap;
  final EtapaType etpFormApr;
  final GeneroType userGen;
  final EtniaType userEtn;
  final String userImg;
  final DateTime fecIniFormApr;
  final DateTime fecFinFormApr;
  final int fichaApr;
  final DateTime? fecRegistro;

  Usuario({
    this.userId,
    required this.userNumIdent,
    required this.userName,
    required this.userApe,
    required this.userEmail,
    this.userTel,
    required this.userPass,
    required this.userRol,
    required this.userDiscap,
    required this.etpFormApr,
    required this.userGen,
    required this.userEtn,
    required this.userImg,
    required this.fecIniFormApr,
    required this.fecFinFormApr,
    required this.fichaApr,
    this.fecRegistro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      userId: json['user_id'],
      userNumIdent: json['user_num_ident'],
      userName: json['user_name'],
      userApe: json['user_ape'],
      userEmail: json['user_email'],
      userTel: json['user_tel'],
      userPass: json['user_pass'],
      userRol: _mapRolFromString(json['user_rol']),
      userDiscap: _mapDiscapacidadFromString(json['user_discap']),
      etpFormApr: _mapEtapaFromString(json['etp_form_Apr']),
      userGen: _mapGeneroFromString(json['user_gen']),
      userEtn: _mapEtniaFromString(json['user_etn']),
      userImg: json['user_img'],
      fecIniFormApr: DateTime.parse(json['fec_ini_form_Apr']),
      fecFinFormApr: DateTime.parse(json['fec_fin_form_Apr']),
      fichaApr: json['ficha_Apr'],
      fecRegistro:
          json['fec_registro'] != null
              ? DateTime.parse(json['fec_registro'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_num_ident': userNumIdent,
      'user_name': userName,
      'user_ape': userApe,
      'user_email': userEmail,
      'user_tel': userTel,
      'user_pass': userPass,
      'user_rol': userRol.toString().split('.').last,
      'user_discap': userDiscap.toString().split('.').last,
      'etp_form_Apr': etpFormApr.toString().split('.').last,
      'user_gen': userGen.toString().split('.').last,
      'user_etn': userEtn.toString().split('.').last,
      'user_img': userImg,
      'fec_ini_form_Apr': fecIniFormApr.toIso8601String(),
      'fec_fin_form_Apr': fecFinFormApr.toIso8601String(),
      'ficha_Apr': fichaApr,
      'fec_registro': fecRegistro?.toIso8601String(),
    };
  }

  // Métodos de mapeo para enums
  static RolType _mapRolFromString(String? rol) {
    switch (rol?.toLowerCase()) {
      case 'administrador':
        return RolType.administrador;
      case 'delegado':
        return RolType.delegado;
      case 'aprendiz':
        return RolType.aprendiz;
      default:
        return RolType.aprendiz;
    }
  }

  static DiscapacidadType _mapDiscapacidadFromString(String? discap) {
    switch (discap?.toLowerCase()) {
      case 'visual':
        return DiscapacidadType.visual;
      case 'auditiva':
        return DiscapacidadType.auditiva;
      case 'fisica':
        return DiscapacidadType.fisica;
      case 'ninguna':
      default:
        return DiscapacidadType.ninguna;
    }
  }

  static EtapaType _mapEtapaFromString(String? etapa) {
    switch (etapa?.toLowerCase()) {
      case 'lectiva':
        return EtapaType.lectiva;
      case 'productiva':
        return EtapaType.productiva;
      default:
        return EtapaType.lectiva;
    }
  }

  static GeneroType _mapGeneroFromString(String? genero) {
    switch (genero?.toLowerCase()) {
      case 'masculino':
        return GeneroType.masculino;
      case 'femenino':
        return GeneroType.femenino;
      default:
        return GeneroType.masculino;
    }
  }

  static EtniaType _mapEtniaFromString(String? etnia) {
    switch (etnia?.toLowerCase()) {
      case 'indigena':
        return EtniaType.indigina;
      case 'afrodescendiente':
        return EtniaType.afrodescendiente;
      case 'no aplica':
      default:
        return EtniaType.noAplica;
    }
  }
}
