import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import 'book_form_screen.dart';
import 'book_detail_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BookService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReadTrack'),
        actions: [
          IconButton(
            tooltip: 'Estadísticas generales',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            ),
            icon: const Icon(Icons.pie_chart),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Book>>(
        stream: service.watchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(
              child: Text('No hay libros. Pulsa + para agregar el primero.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (_, index) {
              final book = books[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(book.title),
                  subtitle: Text(
                    '${book.author} · ${book.currentPage}/${book.totalPages} páginas',
                  ),
                  trailing: SizedBox(
                    width: 70,
                    child: LinearProgressIndicator(value: book.progress),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
