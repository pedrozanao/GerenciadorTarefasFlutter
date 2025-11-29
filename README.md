Nome: PEDRO AFONSO ZANAO
RA: 202310249

Descrição
    O app permite criar, listar, editar e excluir tarefas, armazenando tudo em um arquivo .db 
    Cada tarefa possui id, título, descrição, prioridade, data de criação e um campo extra definido por CategoriaProcesso

Estrutura do projeto
lib/database/database_helper.dart: configuração do SQLite, criação do banco e da tabela de tarefas.​

lib/models/tarefa.dart: modelo da entidade Tarefa e conversão para/desde Map (JSON).​

lib/pages/tarefa_home_page.dart: tela inicial com ListView.builder para listar, atualizar e excluir tarefas.​

lib/pages/tarefa_form_page.dart: formulário com validações para cadastrar e editar tarefas.​

lib/main.dart: ponto de entrada da aplicação e configuração de tema/rotas.​

Funcionalidades
CRUD completo de tarefas (inserir, listar, atualizar e excluir).​

Atualização automática da lista após operações de cadastro, edição ou exclusão.​

Validações básicas nos campos obrigatórios do formulário.​

Dificuldades encontradas
    Principais desafios envolveram a configuração do sqflite com o path_provider, a implementação correta dos métodos do CRUD e a sincronização da interface devido ser uma aplicação que requesite muito processamento e memória do disco.