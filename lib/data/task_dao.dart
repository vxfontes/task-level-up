import 'package:primeiroprojeto/components/tasks.dart';
import 'package:primeiroprojeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSQL = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTERGER, '
      '$_image TEXT)';

  static const String _tablename = 'taskTable';
  static const String _name = 'nome';
  static const String _image = 'imagem';
  static const String _difficulty = 'difficulty';

  List<Tasks> toList(List<Map<String, dynamic>> listaDeTarefas) {
    print('Convertendo to List: ');

    final List<Tasks> tarefas = [];

    for (Map<String, dynamic> linha in listaDeTarefas) {
      final Tasks tarefa =
          Tasks(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }

    print(' Lista de Tarefas $tarefas');
    return tarefas;
  }

  Map<String, dynamic> toMap(Tasks tarefa) {
    print('Convertendo tarefas em map');

    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_image] = tarefa.foto;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;

    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  save(Tasks tarefa) async {
    print('Iniciando o save: ');
    final Database banco = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);

    if (itemExists.isEmpty) {
      print('Tarefa não existe');
      return await banco.insert(_tablename, taskMap);
    } else {
      print('Tarefa ja existe');
      return await banco.update(_tablename, taskMap,
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }
  }

  Future<List<Tasks>> findAll() async {
    print('Acessando findAll');
    final Database banco = await getDatabase();
    final List<Map<String, dynamic>> result = await banco.query(_tablename);
    print('Procurando dados: $result');

    return toList(result);
  }

  Future<List<Tasks>> find(String nomeTarefa) async {
    print(' Acessando find: ');
    final Database banco = await getDatabase();
    final List<Map<String, dynamic>> result = await banco
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeTarefa]);

    print('Tarefa encontrada: ${toList(result)}');
    return toList(result);
  }

  delete(String nomeTarefa) async {
    print('Deletando tarefa: $nomeTarefa');
    final Database banco = await getDatabase();

    return banco.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeTarefa],
    );
  }
}
