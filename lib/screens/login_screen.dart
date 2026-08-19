import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool register = false;
  bool loading = false;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      if (register) {
        await _auth.register(_email.text.trim(), _password.text);
      } else {
        await _auth.signIn(_email.text.trim(), _password.text);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'No fue posible autenticar.')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book, size: 72),
                const SizedBox(height: 16),
                Text('ReadTrack',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: loading ? null : submit,
                  child: Text(loading
                      ? 'Procesando...'
                      : (register ? 'Registrarse' : 'Iniciar sesión')),
                ),
                TextButton(
                  onPressed: loading ? null : () => setState(() => register = !register),
                  child: Text(register
                      ? '¿Ya tienes cuenta? Inicia sesión'
                      : '¿Sin cuenta? Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
