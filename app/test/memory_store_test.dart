import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:work_memory/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('stores and searches memories locally', () async {
    final store = MemoryStore(databasePath: inMemoryDatabasePath);
    await store.open();

    await store.insert('Supplier asked if the drawing changed');
    await store.insert('Product A BOM check still unresolved');

    final today = await store.today();
    expect(today, hasLength(2));
    expect(today.first.content, 'Product A BOM check still unresolved');

    final matches = await store.search('drawing');
    expect(matches, hasLength(1));
    expect(matches.single.content, 'Supplier asked if the drawing changed');

    await store.close();
  });
}
