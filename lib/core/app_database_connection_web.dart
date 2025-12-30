import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:drift/wasm.dart';

LazyDatabase connect() {
  return LazyDatabase(() async => WebDatabase('fittracker_db'));
}
