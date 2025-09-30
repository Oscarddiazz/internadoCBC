const { executeQuery } = require('../config/database');
const socketService = require('../services/socketService');

// Obtener todas las tareas
const getAllTasks = async (req, res) => {
  try {
    const { estado, aprendiz_id, admin_id } = req.query;
    let query = `
      SELECT t.*, 
             a.user_name as admin_name, a.user_ape as admin_ape,
             apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
      FROM tareas t
      LEFT JOIN usuario a ON t.tarea_admin_id = a.user_id
      LEFT JOIN usuario apr ON t.tarea_aprendiz_id = apr.user_id
    `;
    let params = [];
    let conditions = [];

    // Filtros opcionales
    if (estado) {
      conditions.push('t.tarea_estado = ?');
      params.push(estado);
    }

    if (aprendiz_id) {
      conditions.push('t.tarea_aprendiz_id = ?');
      params.push(aprendiz_id);
    }

    if (admin_id) {
      conditions.push('t.tarea_admin_id = ?');
      params.push(admin_id);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    query += ' ORDER BY t.tarea_fec_asignacion DESC';

    const tasks = await executeQuery(query, params);

    res.json({
      success: true,
      data: tasks
    });

  } catch (error) {
    console.error('Error obteniendo tareas:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Obtener tarea por ID
const getTaskById = async (req, res) => {
  try {
    const { id } = req.params;

    const tasks = await executeQuery(
      `SELECT t.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM tareas t
       LEFT JOIN usuario a ON t.tarea_admin_id = a.user_id
       LEFT JOIN usuario apr ON t.tarea_aprendiz_id = apr.user_id
       WHERE t.tarea_id = ?`,
      [id]
    );

    if (tasks.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tarea no encontrada'
      });
    }

    res.json({
      success: true,
      data: tasks[0]
    });

  } catch (error) {
    console.error('Error obteniendo tarea:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Crear nueva tarea
const createTask = async (req, res) => {
  try {
    const {
      tarea_descripcion,
      tarea_fec_entrega,
      tarea_estado,
      tarea_aprendiz_id
    } = req.body;

    const admin_id = req.user.user_id;

    // Validar campos requeridos
    if (!tarea_descripcion || !tarea_fec_entrega || !tarea_aprendiz_id) {
      return res.status(400).json({
        success: false,
        message: 'Descripción, fecha de entrega y aprendiz son requeridos'
      });
    }

    // Verificar que el aprendiz existe
    const aprendiz = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_id = ? AND user_rol = "Aprendiz"',
      [tarea_aprendiz_id]
    );

    if (aprendiz.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'El aprendiz especificado no existe'
      });
    }

    // Insertar tarea
    const result = await executeQuery(
      `INSERT INTO tareas (
        tarea_descripcion, tarea_fec_entrega, tarea_estado, tarea_admin_id, tarea_aprendiz_id
      ) VALUES (?, ?, ?, ?, ?)`,
      [
        tarea_descripcion,
        tarea_fec_entrega,
        tarea_estado || 'Pendiente',
        admin_id,
        tarea_aprendiz_id
      ]
    );

    // Obtener la tarea creada
    const newTask = await executeQuery(
      `SELECT t.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM tareas t
       LEFT JOIN usuario a ON t.tarea_admin_id = a.user_id
       LEFT JOIN usuario apr ON t.tarea_aprendiz_id = apr.user_id
       WHERE t.tarea_id = ?`,
      [result.insertId]
    );

    // Enviar notificación en tiempo real
    socketService.notifyNewTask(newTask[0]);

    res.status(201).json({
      success: true,
      message: 'Tarea creada exitosamente',
      data: newTask[0]
    });

  } catch (error) {
    console.error('Error creando tarea:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Actualizar tarea
const updateTask = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      tarea_descripcion,
      tarea_fec_entrega,
      tarea_estado,
      tarea_evidencia,
      tarea_fec_completado
    } = req.body;

    // Verificar si la tarea existe
    const existingTask = await executeQuery(
      'SELECT tarea_id FROM tareas WHERE tarea_id = ?',
      [id]
    );

    if (existingTask.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tarea no encontrada'
      });
    }

    // Construir query de actualización dinámicamente
    const updateFields = [];
    const updateValues = [];

    if (tarea_descripcion) {
      updateFields.push('tarea_descripcion = ?');
      updateValues.push(tarea_descripcion);
    }
    if (tarea_fec_entrega) {
      updateFields.push('tarea_fec_entrega = ?');
      updateValues.push(tarea_fec_entrega);
    }
    if (tarea_estado) {
      updateFields.push('tarea_estado = ?');
      updateValues.push(tarea_estado);
    }
    if (tarea_evidencia !== undefined) {
      updateFields.push('tarea_evidencia = ?');
      updateValues.push(tarea_evidencia);
    }
    if (tarea_fec_completado !== undefined) {
      updateFields.push('tarea_fec_completado = ?');
      updateValues.push(tarea_fec_completado);
    }

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No se proporcionaron campos para actualizar'
      });
    }

    updateValues.push(id);

    const query = `UPDATE tareas SET ${updateFields.join(', ')} WHERE tarea_id = ?`;
    await executeQuery(query, updateValues);

    // Obtener la tarea actualizada
    const updatedTask = await executeQuery(
      `SELECT t.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM tareas t
       LEFT JOIN usuario a ON t.tarea_admin_id = a.user_id
       LEFT JOIN usuario apr ON t.tarea_aprendiz_id = apr.user_id
       WHERE t.tarea_id = ?`,
      [id]
    );

    res.json({
      success: true,
      message: 'Tarea actualizada exitosamente',
      data: updatedTask[0]
    });

  } catch (error) {
    console.error('Error actualizando tarea:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Eliminar tarea
const deleteTask = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar si la tarea existe
    const existingTask = await executeQuery(
      'SELECT tarea_id FROM tareas WHERE tarea_id = ?',
      [id]
    );

    if (existingTask.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tarea no encontrada'
      });
    }

    // Eliminar tarea
    await executeQuery('DELETE FROM tareas WHERE tarea_id = ?', [id]);

    res.json({
      success: true,
      message: 'Tarea eliminada exitosamente'
    });

  } catch (error) {
    console.error('Error eliminando tarea:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Marcar tarea como completada
const completeTask = async (req, res) => {
  try {
    const { id } = req.params;
    const { tarea_evidencia } = req.body;

    // Verificar si la tarea existe
    const existingTask = await executeQuery(
      'SELECT tarea_id FROM tareas WHERE tarea_id = ?',
      [id]
    );

    if (existingTask.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tarea no encontrada'
      });
    }

    // Actualizar tarea como completada
    await executeQuery(
      `UPDATE tareas SET 
        tarea_estado = 'Completada',
        tarea_evidencia = ?,
        tarea_fec_completado = NOW()
       WHERE tarea_id = ?`,
      [tarea_evidencia, id]
    );

    // Obtener la tarea actualizada
    const updatedTask = await executeQuery(
      `SELECT t.*, 
              a.user_name as admin_name, a.user_ape as admin_ape,
              apr.user_name as aprendiz_name, apr.user_ape as aprendiz_ape
       FROM tareas t
       LEFT JOIN usuario a ON t.tarea_admin_id = a.user_id
       LEFT JOIN usuario apr ON t.tarea_aprendiz_id = apr.user_id
       WHERE t.tarea_id = ?`,
      [id]
    );

    // Enviar notificación en tiempo real
    socketService.notifyTaskCompleted(updatedTask[0]);

    res.json({
      success: true,
      message: 'Tarea marcada como completada',
      data: updatedTask[0]
    });

  } catch (error) {
    console.error('Error completando tarea:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  getAllTasks,
  getTaskById,
  createTask,
  updateTask,
  deleteTask,
  completeTask
};
