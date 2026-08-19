# ReadTrack — Proyecto Integrador, Etapa 3

Implementación base de la aplicación móvil ReadTrack conforme a las etapas 1 y 2.

## Tecnologías
- Flutter + Dart
- Firebase Authentication
- Cloud Firestore
- FL Chart

## Configuración
1. Instalar Flutter y Android Studio/SDK.
2. Crear o seleccionar un proyecto en Firebase.
3. Ejecutar:
   `firebase login`
   `dart pub global activate flutterfire_cli`
   `flutterfire configure`
4. Ejecutar:
   `flutter pub get`
   `flutter run`

La configuración generada por FlutterFire (`lib/firebase_options.dart`) no se incluye porque contiene identificadores específicos del proyecto Firebase del propietario.

## CRUD implementado
- Create: alta de libros y sesiones.
- Read: consulta de libros y sesiones mediante snapshots de Firestore.
- Update: edición de libros.
- Delete: eliminación de libros.

## Seguridad
Se incluye `firestore.rules`, con acceso restringido al usuario autenticado y propietario de los documentos.

## Limitación de esta entrega
El entorno de preparación no dispone de Flutter SDK ni Android SDK, por lo que no se genera un APK real desde este entorno. No se inventan capturas ni resultados de ejecución. El proyecto está preparado para compilarse en un equipo con Flutter/Android instalado.
