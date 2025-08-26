const { executeQuery } = require('./config/database');

async function checkUsers() {
  try {
    console.log('🔍 Verificando usuarios en la base de datos...\n');
    
    const users = await executeQuery('SELECT user_id, user_name, user_ape, user_email, user_rol, user_pass FROM usuario');
    
    console.log(`📊 Total de usuarios encontrados: ${users.length}\n`);
    
    users.forEach((user, index) => {
      console.log(`${index + 1}. ID: ${user.user_id}`);
      console.log(`   Nombre: ${user.user_name} ${user.user_ape}`);
      console.log(`   Email: ${user.user_email}`);
      console.log(`   Rol: ${user.user_rol}`);
      console.log(`   Contraseña: ${user.user_pass}`);
      console.log('');
    });
    
    // Verificar usuarios específicos
    const testEmails = [
      'pedro.suarez@sena.edu.co',
      'juan.martinez@sena.edu.co', 
      'carlos.gomez@sena.edu.co'
    ];
    
    console.log('🔍 Verificando usuarios de prueba...\n');
    
    for (const email of testEmails) {
      const user = await executeQuery('SELECT * FROM usuario WHERE user_email = ?', [email]);
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
    console.error('❌ Error verificando usuarios:', error);
  } finally {
    process.exit(0);
  }
}

checkUsers();
