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

link do video: https://drive.google.com/file/d/1nWQxEZ_KTSv7QpKAjv1htTJNkZKLshTf/view?usp=sharing

<img width="299" height="235" alt="BancoCriado" src="https://github.com/user-attachments/assets/5767225b-9338-4d89-a1e1-bf7bd9af89c3" />

![formulariopreenchido](https://github.com/user-attachments/assets/fefd212f-b8a8-49bb-9dcd-a4ed3e46e163)

![FunçãoBancoCriado](https://github.com/user-attachments/assets/c6014eac-2e01-4ada-a539-b46a5b7b3edb)

![Tela de Listagem](https://github.com/user-attachments/assets/a068f301-ef46-4ed1-b3c3-78b37f0058b1)

<img width="1458" height="29" alt="TesteJSON" src="https://github.com/user-attachments/assets/a084e5e4-5dac-4dbb-9f97-08a048d06899" />







