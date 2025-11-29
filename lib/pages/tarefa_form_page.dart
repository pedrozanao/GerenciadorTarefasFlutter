import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../database/database_helper.dart';

class TarefaFormPage extends StatefulWidget {
  final Tarefa? tarefa;

  const TarefaFormPage({super.key, this.tarefa});

  @override
  State<TarefaFormPage> createState() => _TarefaFormPageState();
}

class _TarefaFormPageState extends State<TarefaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _categoriaController;
  String _prioridade = 'Media';

  @override
  void initState() {
    super.initState();

    _tituloController =
        TextEditingController(text: widget.tarefa?.titulo ?? '');
    _descricaoController =
        TextEditingController(text: widget.tarefa?.descricao ?? '');
    _categoriaController =
        TextEditingController(text: widget.tarefa?.categoriaProcesso ?? '');
    _prioridade = widget.tarefa?.prioridade ?? 'Media';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  // 🔥 SALVAR / ATUALIZAR TAREFA
  Future<void> _salvarTarefa() async {
    if (_formKey.currentState!.validate()) {
      final novaTarefa = Tarefa(
        id: widget.tarefa?.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        prioridade: _prioridade,
        categoriaProcesso: _categoriaController.text,
        criadoEm: widget.tarefa?.criadoEm ??
            DateTime.now().toString().substring(0, 16),
      );

      if (widget.tarefa == null) {
        // ➤ INSERT – Retorna o ID gerado
        int idGerado =
            await DatabaseHelper.instance.inserirTarefa(novaTarefa.toMap());

        // ➤ Atualiza objeto com o ID
        final tarefaComId = novaTarefa.copyWith(id: idGerado);

        print("🎯 Nova Tarefa Criada: ${tarefaComId.toJson()}");
      } else {
        // ➤ UPDATE
        await DatabaseHelper.instance.atualizarTarefa(novaTarefa.toMap());

        print("✏ Tarefa Atualizada: ${novaTarefa.toJson()}");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.tarefa == null
                ? 'Tarefa criada com sucesso!'
                : 'Tarefa atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange[50]!,
              Colors.brown[50]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _tituloController,
                          decoration: InputDecoration(
                            labelText: 'Título *',
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Título é obrigatório';
                            }
                            if (value.length < 3) {
                              return 'Título deve ter no mínimo 3 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descricaoController,
                          decoration: InputDecoration(
                            labelText: 'Descrição *',
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Descrição é obrigatória';
                            }
                            if (value.length < 10) {
                              return 'Descrição deve ter no mínimo 10 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _prioridade,
                          decoration: InputDecoration(
                            labelText: 'Prioridade *',
                            prefixIcon: const Icon(Icons.priority_high),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['Alta', 'Media', 'Baixa']
                              .map((prioridade) => DropdownMenuItem(
                                    value: prioridade,
                                    child: Text(prioridade),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => _prioridade = value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _categoriaController,
                          decoration: InputDecoration(
                            labelText: 'Categoria do Processo *',
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Ex: Desenvolvimento, Planejamento',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Categoria do Processo é obrigatória';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _salvarTarefa,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.tarefa == null ? 'Salvar' : 'Atualizar',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
