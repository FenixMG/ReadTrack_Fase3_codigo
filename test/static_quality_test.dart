import 'dart:io';

void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  final violations = <String>[];
  for (final file in files) {
    final content = file.readAsStringSync();
    if (content.contains('TODO')) {
      violations.add('${file.path}: contiene TODO');
    }
    if (RegExp(r'(password|api[_-]?key)\s*[:=]\s*["' + "'" + r'][^"' + "'" + r']+["' + "'" + r']',
            caseSensitive: false)
        .hasMatch(content)) {
      violations.add('${file.path}: posible secreto hardcodeado');
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln(violations.join('\n'));
    exitCode = 1;
  } else {
    stdout.writeln('STATIC_CHECK: PASS');
  }
}
