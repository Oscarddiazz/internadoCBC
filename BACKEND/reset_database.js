const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: './config.env' });

async function resetDatabase() {
  let connection;
  
  try {
    console.log('🗄️ Reiniciando base de datos...\n');
    
    // Conectar a MySQL sin especificar base de datos
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      port: process.env.DB_PORT || 3306
    });
    
    console.log('✅ Conectado a MySQL');
    
    // Eliminar base de datos si existe
    await connection.execute(`DROP DATABASE IF EXISTS ${process.env.DB_NAME || 'internadocbc'}`);
    console.log('✅ Base de datos eliminada');
    
    // Crear base de datos nueva
    await connection.execute(`CREATE DATABASE ${process.env.DB_NAME || 'internadocbc'}`);
    console.log('✅ Base de datos creada');
    
    // Usar la base de datos
    await connection.execute(`USE ${process.env.DB_NAME || 'internadocbc'}`);
    console.log('✅ Base de datos seleccionada');
    
    // Leer el archivo SQL
    const sqlFile = path.join(__dirname, '..', 'internadocbc.sql');
    console.log(`📁 Leyendo archivo: ${sqlFile}`);
    
    if (!fs.existsSync(sqlFile)) {
      throw new Error(`Archivo SQL no encontrado en: ${sqlFile}`);
    }
    
    const sqlContent = fs.readFileSync(sqlFile, 'utf8');
    console.log('✅ Archivo SQL leído');
    
    // Limpiar y dividir el SQL en comandos individuales
    const commands = sqlContent
      .replace(/--.*$/gm, '') // Remover comentarios de una línea
      .replace(/\/\*[\s\S]*?\*\//gm, '') // Remover comentarios multilínea
      .split(';')
      .map(cmd => cmd.trim())
      .filter(cmd => cmd.length > 0 && !cmd.startsWith('SET') && !cmd.startsWith('START') && !cmd.startsWith('COMMIT'));
    
    console.log(`📝 Ejecutando ${commands.length} comandos SQL...`);
    
    // Ejecutar cada comando
    for (let i = 0; i < commands.length; i++) {
      const command = commands[i];
      if (command.trim() && command.length > 10) { // Solo comandos significativos
        try {
          await connection.execute(command);
          console.log(`✅ Comando ${i + 1} ejecutado`);
        } catch (error) {
          console.log(`⚠️ Error en comando ${i + 1}: ${error.message}`);
        }
      }
    }
    
    console.log('\n🎉 Base de datos reiniciada correctamente!');
    
    // Verificar usuarios importados
    const [users] = await connection.execute('SELECT user_id, user_name, user_ape, user_email, user_rol FROM usuario');
    console.log(`\n📊 Usuarios importados: ${users.length}`);
    
    users.forEach(user => {
      console.log(`   - ${user.user_name} ${user.user_ape} (${user.user_email}) - ${user.user_rol}`);
    });
    
    // Verificar usuarios específicos
    const testEmails = [
      'pedro.suarez@sena.edu.co',
      'juan.martinez@sena.edu.co', 
      'carlos.gomez@sena.edu.co'
    ];
    
    console.log('\n🔍 Verificando usuarios de prueba...\n');
    
    for (const email of testEmails) {
      const [user] = await connection.execute('SELECT * FROM usuario WHERE user_email = ?', [email]);
      if (user.length > 0) {
        console.log(`✅ ${email} - ENCONTRADO`);
        console.log(`   Contraseña: ${user[0].user_pass}`);
        console.log(`   Rol: ${user[0].user_rol}`);
      } else {
        console.log(`❌ ${email} - NO ENCONTRADO`);
      }
      console.log('');
    }
    
  } catch (error) {
    console.error('❌ Error reiniciando base de datos:', error);
  } finally {
    if (connection) {
      await connection.end();
    }
    process.exit(0);
  }
}

resetDatabase();
