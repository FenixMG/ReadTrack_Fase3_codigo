import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/book.dart';
import '../models/reading_session.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _books =>
      _db.collection('users').doc(_uid).collection('books');

  Stream<List<Book>> watchBooks() => _books.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Book.fromMap(doc.id, doc.data()))
            .toList(),
      );

  Future<void> createBook(Book book) => _books.doc(book.id).set(book.toMap());

  Future<void> updateBook(Book book) => _books.doc(book.id).update(book.toMap());

  Future<void> deleteBook(String bookId) => _books.doc(bookId).delete();

  Stream<List<ReadingSession>> watchSessions(String bookId) =>
      _books.doc(bookId).collection('sessions').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => ReadingSession.fromMap(doc.id, doc.data()))
                .toList(),
          );

  Future<void> createSession(String bookId, ReadingSession session) async {
    final bookRef = _books.doc(bookId);
    await bookRef.collection('sessions').doc(session.id).set(session.toMap());
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(bookRef);
      final current = (snapshot.data()?['currentPage'] as num?)?.toInt() ?? 0;
      final total = (snapshot.data()?['totalPages'] as num?)?.toInt() ?? 0;
      transaction.update(bookRef, {
        'currentPage': (current + session.pages).clamp(0, total),
      });
    });
  }
}
