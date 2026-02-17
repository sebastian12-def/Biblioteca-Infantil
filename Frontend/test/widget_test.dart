// Test básico de la aplicación Biblioteca Infantil
import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_infantil/main.dart';

void main() {
  testWidgets('App se inicia correctamente', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BibliotecaApp());

    // Verificar que la app se carga (pantalla de carga o login)
    await tester.pump();
  });
}

