import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookFormScreen extends StatefulWidget {
  final Book? existing;
  const BookFormScreen({super.key, this.existing});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final title = TextEditingController();
  final author = TextEditingController();
  final pages = TextEditingController();
  final current = TextEditingController(text: '0');
  final genre = TextEditingController();
  String format = 'Físico';

  @override
  void initState() {
    super.initState();
    final b = widget.existing;
    if (b != null) {
      title.text = b.title;
      author.text = b.author;
      pages.text = b.totalPages.toString();
      current.text = b.currentPage.toString();
      genre.text = b.genre;
      format = b.format;
    }
  }

  Future<void> save() async {
    final total = int.tryParse(pages.text) ?? 0;
    final currentPage = int.tryParse(current.text) ?? 0;
    if (title.text.trim().isEmpty || author.text.trim().isEmpty || total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa título, autor y páginas.')),
      );
      return;
    }
    final old = widget.existing;
    final book = Book(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.text.trim(),
      author: author.text.trim(),
      totalPages: total,
      currentPage: currentPage.clamp(0, total),
      genre: genre.text.trim(),
      format: format,
      startDate: old?.startDate ?? DateTime.now(),
    );
    final service = BookService();
    if (old == null) {
      await service.createBook(book);
    } else {
      await service.updateBook(book);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Agregar libro' : 'Editar libro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Título')),
          TextField(controller: author, decoration: const InputDecoration(labelText: 'Autor')),
          TextField(controller: pages, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de páginas')),
          TextField(controller: current, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Página actual')),
          TextField(controller: genre, decoration: const InputDecoration(labelText: 'Género')),
          DropdownButtonFormField<String>(
            value: format,
            items: const [
              DropdownMenuItem(value: 'Físico', child: Text('Físico')),
              DropdownMenuItem(value: 'Digital', child: Text('Digital')),
              DropdownMenuItem(value: 'Audio', child: Text('Audio')),
              DropdownMenuItem(value: 'Tándem', child: Text('Tándem')),
            ],
            onChanged: (v) => setState(() => format = v ?? format),
            decoration: const InputDecoration(labelText: 'Formato'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Guardar libro'),
          ),
        ],
      ),
    );
  }
}
