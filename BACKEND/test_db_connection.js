const mysql = require('mysql2/promise');
require('dotenv').config({ path: './config.env' });

async function testConnection() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: process.env.DB_PORT
    });

    console.log('✅ Conexión a la base de datos exitosa');
    
    // Probar una consulta simple
    const [rows] = await connection.execute('SELECT COUNT(*) as count FROM usuario');
    console.log(`📊 Total de usuarios en la base de datos: ${rows[0].count}`);
    
    // Verificar estructura de la tabla usuario
    const [columns] = await connection.execute('DESCRIBE usuario');
    console.log('📋 Estructura de la tabla usuario:');
    columns.forEach(col => {
      console.log(`  - ${col.Field}: ${col.Type} ${col.Null === 'NO' ? '(NOT NULL)' : ''}`);
    });

    await connection.end();
    console.log('✅ Prueba completada exitosamente');
    
  } catch (error) {
    console.error('❌ Error conectando a la base de datos:', error.message);
    console.error('Detalles del error:', error);
  }
}

testConnection();
