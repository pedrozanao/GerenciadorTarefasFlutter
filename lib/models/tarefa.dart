class Tarefa {
  int? id;
  String titulo;
  String descricao;
  String prioridade;
  String categoriaProcesso;
  String criadoEm;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.categoriaProcesso,
    required this.criadoEm,
  });

  // ---- MAP PARA O BANCO ----
  Map<String, dynamic> toMap() {
    final map = {
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'categoriaProcesso': categoriaProcesso,
      'criadoEm': criadoEm,
    };

    if (id != null) {
      map['id'] = id as String;
    }

    return map;
  }

  // ---- SAÍDA JSON (para print, logs, export etc) ----
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'categoriaProcesso': categoriaProcesso,
      'criadoEm': criadoEm,
    };
  }

  // ---- FROM MAP (LER DO BANCO) ----
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      prioridade: map['prioridade'],
      categoriaProcesso: map['categoriaProcesso'],
      criadoEm: map['criadoEm'],
    );
  }

  // ---- COPYWITH ----
  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? prioridade,
    String? categoriaProcesso,
    String? criadoEm,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      prioridade: prioridade ?? this.prioridade,
      categoriaProcesso: categoriaProcesso ?? this.categoriaProcesso,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
