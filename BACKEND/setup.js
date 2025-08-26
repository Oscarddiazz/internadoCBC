const fs = require('fs');
const path = require('path');

console.log('🚀 Configurando el backend del Sistema de Gestión de Internado CBC...\n');

// Crear directorio de uploads si no existe
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
  console.log('✅ Directorio uploads creado');
} else {
  console.log('📁 Directorio uploads ya existe');
}

// Verificar archivo de configuración
const configFile = path.join(__dirname, 'config.env');
if (!fs.existsSync(configFile)) {
  console.log('❌ Archivo config.env no encontrado');
  console.log('📝 Por favor, crea el archivo config.env con la configuración de tu base de datos');
} else {
  console.log('✅ Archivo config.env encontrado');
}

// Verificar package.json
const packageFile = path.join(__dirname, 'package.json');
if (!fs.existsSync(packageFile)) {
  console.log('❌ Archivo package.json no encontrado');
  console.log('📝 Ejecuta: npm install');
} else {
  console.log('✅ Archivo package.json encontrado');
}

console.log('\n📋 Pasos para completar la configuración:');
console.log('1. Asegúrate de que XAMPP esté ejecutándose');
console.log('2. Importa la base de datos internadocbc.sql en phpMyAdmin');
console.log('3. Verifica la configuración en config.env');
console.log('4. Ejecuta: npm install');
console.log('5. Ejecuta: npm run dev');
console.log('\n🔗 URLs importantes:');
console.log('- Backend: http://localhost:3000');
console.log('- Estado: http://localhost:3000/health');
console.log('- Documentación: http://localhost:3000/');

console.log('\n🎉 ¡Configuración completada!');
