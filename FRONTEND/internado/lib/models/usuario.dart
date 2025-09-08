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
      userRol: RolType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_rol'],
      ),
      userDiscap: DiscapacidadType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_discap'],
      ),
      etpFormApr: EtapaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['etp_form_Apr'],
      ),
      userGen: GeneroType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_gen'],
      ),
      userEtn: EtniaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_etn'],
      ),
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
}
