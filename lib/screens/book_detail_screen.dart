import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/reading_session.dart';
import '../services/book_service.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final service = BookService();
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookFormScreen(existing: book)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await service.deleteBook(book.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(book.author, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('${book.currentPage}/${book.totalPages} páginas · ${book.format}'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: book.progress),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _addSession(context, service),
            icon: const Icon(Icons.timer),
            label: const Text('Añadir sesión de lectura'),
          ),
          const SizedBox(height: 24),
          const Text('Sesiones de lectura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          StreamBuilder<List<ReadingSession>>(
            stream: service.watchSessions(book.id),
            builder: (_, snapshot) {
              final sessions = snapshot.data ?? [];
              return Column(
                children: sessions.map((s) => ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text('${s.pages} páginas · ${s.minutes} min'),
                  subtitle: Text('${s.date.day}/${s.date.month}/${s.date.year} · ${s.format}'),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addSession(BuildContext context, BookService service) async {
    final pages = TextEditingController();
    final minutes = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva sesión'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: pages, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Páginas leídas')),
            TextField(controller: minutes, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minutos')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );
    if (result == true) {
      await service.createSession(
        book.id,
        ReadingSession(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          date: DateTime.now(),
          pages: int.tryParse(pages.text) ?? 0,
          minutes: int.tryParse(minutes.text) ?? 0,
          format: book.format,
        ),
      );
    }
  }
}
