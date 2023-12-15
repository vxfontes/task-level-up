import 'package:flutter/material.dart';
import 'package:primeiroprojeto/components/tasks.dart';
import 'package:primeiroprojeto/data/task_dao.dart';
import 'package:primeiroprojeto/data/task_inherited.dart';
import 'package:primeiroprojeto/screens/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext contextTask) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        leading: const Icon(Icons.add_task),
        actions: [
          IconButton(onPressed: () {setState(() {});}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 208, 221, 237),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 70),
          child: FutureBuilder<List<Tasks>>(
              future: TaskDao().findAll(),
              builder: (context, snapshot) {
                List<Tasks>? items = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ]),
                    );

                  case ConnectionState.waiting:
                    return const Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ]),
                    );

                  case ConnectionState.active:
                    return const Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ]),
                    );

                  case ConnectionState.done:
                    if (snapshot.hasData && items != null) {
                      if (items.isNotEmpty) {
                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Tasks tarefa = items[index];
                              return tarefa;
                            });
                      }

                      return const Center(
                        child: Column(
                          children: [
                            Icon(Icons.error_outline),
                            Text('Não há nenhuma Tarefa',
                                style: TextStyle(fontSize: 32))
                          ],
                        ),
                      );
                    }
                    return const Text('Erro ao carregar tarefas');
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            contextTask,
            MaterialPageRoute(
                builder: (contextNew) => FormScreen(taskContext: contextTask)),
          ).then((value) => setState((){
            print('Recarregando tudo');
          }));
        },
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.add),
      ),
    );
  }
}
