import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConectarDatabase {
  Database? bancoDeDados;

  Future<Database> abrirBanco() async {
    if (bancoDeDados != null) {
      return bancoDeDados!;
    }

    final caminho = join(await getDatabasesPath(), 'app_database.db');
    bancoDeDados = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        // Criando a tabela de carrinho
        await db.execute('''CREATE TABLE carrinho (
            id TEXT PRIMARY KEY,
            nome TEXT,
            valor REAL,
            quantidade INTEGER
          )''');
      },
    );
    return bancoDeDados!;
  }
}
