import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../database/database_helper.dart';
import 'tarefa_form_page.dart';

class TarefasHomePage extends StatefulWidget {
  const TarefasHomePage({super.key});

  @override
  State<TarefasHomePage> createState() => _TarefasHomePageState();
}

class _TarefasHomePageState extends State<TarefasHomePage> {
  List<Tarefa> tarefas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  // Carrega todas as tarefas do banco
  Future<void> _carregarTarefas() async {
    setState(() => isLoading = true);
    tarefas = await DatabaseHelper.instance.listarTarefas();
    setState(() => isLoading = false);
  }

  // Exclui uma tarefa com confirmação
  Future<void> _excluirTarefa(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await DatabaseHelper.instance.excluirTarefa(id);
      _carregarTarefas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarefa excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // Retorna cor baseada na prioridade
  Color _getCorPrioridade(String prioridade) {
    switch (prioridade) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefas Profissionais',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tarefas.isEmpty
                ? _buildTelaVazia()
                : _buildListaTarefas(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navegarParaFormulario(null),
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
    );
  }

  // Widget para tela vazia
  Widget _buildTelaVazia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 100,
            color: Colors.orange[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhuma tarefa cadastrada',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Clique no + para adicionar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Widget da lista de tarefas
  Widget _buildListaTarefas() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _getCorPrioridade(tarefa.prioridade),
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título e botões de ação
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tarefa.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () => _navegarParaFormulario(tarefa),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _excluirTarefa(tarefa.id!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Descrição
                Text(
                  tarefa.descricao,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),

                // Chips de prioridade e categoria
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        tarefa.prioridade,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: _getCorPrioridade(tarefa.prioridade),
                    ),
                    Chip(
                      label: Text(
                        '📋 ${tarefa.categoriaProcesso}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.orange[100],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Data de criação
                Text(
                  '🕒 ${tarefa.criadoEm}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navega para o formulário e recarrega ao voltar
  Future<void> _navegarParaFormulario(Tarefa? tarefa) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TarefaFormPage(tarefa: tarefa),
      ),
    );
    _carregarTarefas();
  }
}
