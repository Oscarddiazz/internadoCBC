const { executeQuery } = require('../config/database');
const socketService = require('../services/socketService');

// Obtener todos los permisos
const getAllPermissions = async (req, res) => {
  try {
    const { estado, aprendiz_id } = req.query;
    let query = `
      SELECT p.*, 
             a.user_name as admin_name, a.user_ape as admin_ape,
             apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
      FROM permiso p
      LEFT JOIN usuario a ON p.permiso_admin_id = a.user_id
      LEFT JOIN usuario apr ON p.permiso_aprendiz_id = apr.user_id
    `;
    let params = [];
    let conditions = [];

    // Filtros opcionales
    if (estado) {
      if (estado === 'pendiente') {
        conditions.push('p.permiso_fec_res IS NULL');
      } else if (estado === 'aprobado') {
        conditions.push('p.permiso_fec_res IS NOT NULL');
      }
    }

    if (aprendiz_id) {
      conditions.push('p.permiso_aprendiz_id = ?');
      params.push(aprendiz_id);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    query += ' ORDER BY p.permiso_fec_solic DESC';

    const permissions = await executeQuery(query, params);

    res.json({
      success: true,
      data: permissions
    });

  } catch (error) {
    console.error('Error obteniendo permisos:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Obtener permiso por ID
const getPermissionById = async (req, res) => {
  try {
    const { id } = req.params;

    const permissions = await executeQuery(
      `SELECT p.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM permiso p
       LEFT JOIN usuario a ON p.permiso_admin_id = a.user_id
       LEFT JOIN usuario apr ON p.permiso_aprendiz_id = apr.user_id
       WHERE p.permiso_id = ?`,
      [id]
    );

    if (permissions.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Permiso no encontrado'
      });
    }

    res.json({
      success: true,
      data: permissions[0]
    });

  } catch (error) {
    console.error('Error obteniendo permiso:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Crear nuevo permiso
const createPermission = async (req, res) => {
  try {
    const {
      permiso_motivo,
      permiso_evidencia
    } = req.body;

    const aprendiz_id = req.user.user_id;

    // Validar campos requeridos
    if (!permiso_motivo) {
      return res.status(400).json({
        success: false,
        message: 'El motivo del permiso es requerido'
      });
    }

    // Verificar que el usuario es un aprendiz
    if (req.user.user_rol !== 'Aprendiz') {
      return res.status(403).json({
        success: false,
        message: 'Solo los aprendices pueden solicitar permisos'
      });
    }

    // Insertar permiso
    const result = await executeQuery(
      `INSERT INTO permiso (
        permiso_motivo, permiso_evidencia, permiso_aprendiz_id
      ) VALUES (?, ?, ?)`,
      [permiso_motivo, permiso_evidencia, aprendiz_id]
    );

    // Obtener el permiso creado
    const newPermission = await executeQuery(
      `SELECT p.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM permiso p
       LEFT JOIN usuario a ON p.permiso_admin_id = a.user_id
       LEFT JOIN usuario apr ON p.permiso_aprendiz_id = apr.user_id
       WHERE p.permiso_id = ?`,
      [result.insertId]
    );

    // Enviar notificación en tiempo real
    socketService.notifyNewPermission(newPermission[0]);

    res.status(201).json({
      success: true,
      message: 'Permiso solicitado exitosamente',
      data: newPermission[0]
    });

  } catch (error) {
    console.error('Error creando permiso:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Aprobar/Rechazar permiso
const respondToPermission = async (req, res) => {
  try {
    const { id } = req.params;
    const { respuesta } = req.body; // 'aprobado' o 'rechazado'

    const admin_id = req.user.user_id;

    // Verificar que el usuario es administrador
    if (req.user.user_rol !== 'Administrador') {
      return res.status(403).json({
        success: false,
        message: 'Solo los administradores pueden responder a los permisos'
      });
    }

    // Verificar si el permiso existe
    const existingPermission = await executeQuery(
      'SELECT permiso_id FROM permiso WHERE permiso_id = ?',
      [id]
    );

    if (existingPermission.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Permiso no encontrado'
      });
    }

    // Actualizar permiso
    await executeQuery(
      `UPDATE permiso SET 
        permiso_fec_res = NOW(),
        permiso_admin_id = ?
       WHERE permiso_id = ?`,
      [admin_id, id]
    );

    // Obtener el permiso actualizado
    const updatedPermission = await executeQuery(
      `SELECT p.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM permiso p
       LEFT JOIN usuario a ON p.permiso_admin_id = a.user_id
       LEFT JOIN usuario apr ON p.permiso_aprendiz_id = apr.user_id
       WHERE p.permiso_id = ?`,
      [id]
    );

    // Enviar notificación en tiempo real
    socketService.notifyPermissionResponse(updatedPermission[0], respuesta);

    res.json({
      success: true,
      message: `Permiso ${respuesta} exitosamente`,
      data: updatedPermission[0]
    });

  } catch (error) {
    console.error('Error respondiendo permiso:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Eliminar permiso
const deletePermission = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar si el permiso existe
    const existingPermission = await executeQuery(
      'SELECT permiso_id FROM permiso WHERE permiso_id = ?',
      [id]
    );

    if (existingPermission.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Permiso no encontrado'
      });
    }

    // Eliminar permiso
    await executeQuery('DELETE FROM permiso WHERE permiso_id = ?', [id]);

    res.json({
      success: true,
      message: 'Permiso eliminado exitosamente'
    });

  } catch (error) {
    console.error('Error eliminando permiso:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  getAllPermissions,
  getPermissionById,
  createPermission,
  respondToPermission,
  deletePermission
};
