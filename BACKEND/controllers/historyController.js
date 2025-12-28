const { executeQuery } = require('../config/database');

// Obtener historial de actividad de aprendices (para delegados)
const getAprendicesHistory = async (req, res) => {
  try {
    // Por ahora, vamos a simular un historial con datos de usuarios
    // En el futuro esto podría conectarse con una tabla de logs o actividad
    const query = `
      SELECT 
        u.user_id,
        u.user_num_ident,
        u.user_name,
        u.user_ape,
        u.user_email,
        u.user_tel,
        u.ficha_Apr,
        u.etp_form_Apr,
        u.fec_registro,
        'Activo' as status,
        NOW() as last_activity
      FROM usuario u 
      WHERE u.user_rol = 'Aprendiz'
      ORDER BY u.user_name, u.user_ape
    `;

    const aprendices = await executeQuery(query);

    // Simular diferentes estados de actividad
    const statusOptions = ['Ahora mismo', 'Hace 15 minutos', 'Ayer', 'Hace 6 horas', 'Hace 30 minutos'];
    const aprendicesWithStatus = aprendices.map((aprendiz, index) => ({
      ...aprendiz,
      status: statusOptions[index % statusOptions.length]
    }));

    res.json({
      success: true,
      data: aprendicesWithStatus
    });

  } catch (error) {
    console.error('Error obteniendo historial de aprendices:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Obtener historial de actividad de un aprendiz específico
const getAprendizHistory = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar que el usuario existe y es un aprendiz
    const user = await executeQuery(
      'SELECT user_id, user_name, user_ape, user_rol FROM usuario WHERE user_id = ?',
      [id]
    );

    if (user.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    if (user[0].user_rol !== 'Aprendiz') {
      return res.status(400).json({
        success: false,
        message: 'El usuario no es un aprendiz'
      });
    }

    // Por ahora, retornar información básica del aprendiz
    // En el futuro esto podría incluir logs de actividad, tareas completadas, etc.
    const aprendizInfo = await executeQuery(
      `SELECT 
        u.user_id,
        u.user_num_ident,
        u.user_name,
        u.user_ape,
        u.user_email,
        u.user_tel,
        u.ficha_Apr,
        u.etp_form_Apr,
        u.fec_registro,
        COUNT(t.tarea_id) as total_tareas,
        COUNT(CASE WHEN t.tarea_estado = 'Completada' THEN 1 END) as tareas_completadas,
        COUNT(p.permiso_id) as total_permisos,
        COUNT(CASE WHEN p.permiso_estado = 'Aprobado' THEN 1 END) as permisos_aprobados
      FROM usuario u
      LEFT JOIN tarea t ON u.user_id = t.tarea_aprendiz_id
      LEFT JOIN permiso p ON u.user_id = p.permiso_aprendiz_id
      WHERE u.user_id = ?
      GROUP BY u.user_id`,
      [id]
    );

    res.json({
      success: true,
      data: aprendizInfo[0]
    });

  } catch (error) {
    console.error('Error obteniendo historial del aprendiz:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  getAprendicesHistory,
  getAprendizHistory
};
