# Plan de pruebas de ReadTrack

## Prueba estática
Herramienta propuesta: MobSF + revisión del código fuente.
- Revisar permisos y configuración Android.
- Buscar secretos incrustados.
- Revisar autenticación y reglas de Firestore.
- Revisar manejo de datos y errores.
- Revisar dependencias.

## Pruebas dinámicas
1. Registro de usuario válido.
2. Inicio de sesión válido.
3. Inicio de sesión con contraseña incorrecta.
4. Alta de libro.
5. Consulta de libros.
6. Edición de libro.
7. Eliminación de libro.
8. Alta de sesión.
9. Comprobación de actualización de páginas.
10. Consulta de estadísticas.
11. Intento de acceder a datos de otro usuario.
12. Cierre de sesión y retorno a pantalla de autenticación.

## Criterio de aceptación
Cada operación CRUD debe completar sin pérdida de datos, los datos deben pertenecer al usuario autenticado y los intentos no autorizados deben ser rechazados por las reglas de Firestore.

## Nota de evidencia
Las pruebas dinámicas y el análisis MobSF requieren un APK/entorno Android. Este paquete no afirma resultados que no hayan sido ejecutados en este entorno.
