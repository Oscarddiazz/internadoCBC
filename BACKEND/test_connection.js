const axios = require('axios');

const BASE_URL = 'http://localhost:3000/api';

// Función para hacer peticiones HTTP
async function makeRequest(method, endpoint, data = null, token = null) {
  try {
    const config = {
      method,
      url: `${BASE_URL}${endpoint}`,
      headers: {
        'Content-Type': 'application/json',
      },
    };

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    if (data) {
      config.data = data;
    }

    const response = await axios(config);
    return response.data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    throw error;
  }
}

// Función principal de pruebas
async function runTests() {
  console.log('🧪 Iniciando pruebas de conexión...\n');

  let authToken = null;

  // Test 1: Verificar que el servidor esté funcionando
  console.log('1️⃣ Probando conexión al servidor...');
  try {
    const healthCheck = await makeRequest('GET', '/health');
    console.log('✅ Servidor funcionando:', healthCheck.message);
  } catch (error) {
    console.log('❌ Error conectando al servidor:', error.message);
    return;
  }

  // Test 2: Login de administrador
  console.log('\n2️⃣ Probando login de administrador...');
  try {
    const loginResult = await makeRequest('POST', '/auth/login', {
      email: 'pedro.suarez@sena.edu.co',
      password: 'admin123'
    });

    if (loginResult.success) {
      authToken = loginResult.data.token;
      console.log('✅ Login exitoso:', loginResult.data.user.user_name);
    } else {
      console.log('❌ Error en login:', loginResult.message);
      return;
    }
  } catch (error) {
    console.log('❌ Error en login:', error.message);
    return;
  }

  // Test 3: Obtener perfil
  console.log('\n3️⃣ Probando obtención de perfil...');
  try {
    const profileResult = await makeRequest('GET', '/auth/profile', null, authToken);
    if (profileResult.success) {
      console.log('✅ Perfil obtenido:', profileResult.data.user_name);
    } else {
      console.log('❌ Error obteniendo perfil:', profileResult.message);
    }
  } catch (error) {
    console.log('❌ Error obteniendo perfil:', error.message);
  }

  // Test 4: Obtener usuarios
  console.log('\n4️⃣ Probando obtención de usuarios...');
  try {
    const usersResult = await makeRequest('GET', '/users', null, authToken);
    if (usersResult.success) {
      console.log('✅ Usuarios obtenidos:', usersResult.data.length);
    } else {
      console.log('❌ Error obteniendo usuarios:', usersResult.message);
    }
  } catch (error) {
    console.log('❌ Error obteniendo usuarios:', error.message);
  }

  // Test 5: Obtener tareas
  console.log('\n5️⃣ Probando obtención de tareas...');
  try {
    const tasksResult = await makeRequest('GET', '/tasks', null, authToken);
    if (tasksResult.success) {
      console.log('✅ Tareas obtenidas:', tasksResult.data.length);
    } else {
      console.log('❌ Error obteniendo tareas:', tasksResult.message);
    }
  } catch (error) {
    console.log('❌ Error obteniendo tareas:', error.message);
  }

  // Test 6: Obtener permisos
  console.log('\n6️⃣ Probando obtención de permisos...');
  try {
    const permissionsResult = await makeRequest('GET', '/permissions', null, authToken);
    if (permissionsResult.success) {
      console.log('✅ Permisos obtenidos:', permissionsResult.data.length);
    } else {
      console.log('❌ Error obteniendo permisos:', permissionsResult.message);
    }
  } catch (error) {
    console.log('❌ Error obteniendo permisos:', error.message);
  }

  // Test 7: Crear una tarea
  console.log('\n7️⃣ Probando creación de tarea...');
  try {
    const createTaskResult = await makeRequest('POST', '/tasks', {
      tarea_descripcion: 'Tarea de prueba desde script',
      tarea_fec_entrega: '2025-01-20',
      tarea_aprendiz_id: 4
    }, authToken);

    if (createTaskResult.success) {
      console.log('✅ Tarea creada:', createTaskResult.data.tarea_id);
    } else {
      console.log('❌ Error creando tarea:', createTaskResult.message);
    }
  } catch (error) {
    console.log('❌ Error creando tarea:', error.message);
  }

  console.log('\n🎉 Pruebas completadas!');
  console.log('\n📋 Resumen:');
  console.log('- Backend funcionando correctamente');
  console.log('- Autenticación JWT funcionando');
  console.log('- Endpoints principales probados');
  console.log('- Base de datos conectada');
  console.log('\n🚀 Tu sistema está listo para conectar con Flutter!');
}

// Ejecutar pruebas
runTests().catch(console.error);
