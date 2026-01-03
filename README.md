# Bundle Pro - bundlepro

**Versão**: 1.2.0

Ferramenta CLI para criar projetos Databricks Asset Bundles padronizados.

## O que o Bundle Pro oferece?

O Bundle Pro cria projetos Databricks padronizados com os seguintes recursos:

| Recurso | Descrição | Quando usar |
|---------|-----------|-------------|
| **Notebook** | Sempre incluído | Base para análises e processamento |
| **Job** | Execução agendada | Pipelines ETL, processos recorrentes |
| **Dashboard** | Visualização de dados | KPIs, análises visuais, monitoramento |

**Flexibilidade total**: Você escolhe quais recursos criar ao executar o comando.

## Pré-requisitos

Antes de usar o Bundle Pro, certifique-se de ter:
- Git instalado e configurado
- Databricks CLI instalado
- Acesso ao seu workspace Databricks
- Chave SSH configurada para acesso ao repositório

## How it Works

The `bundlepro` script is a command-line tool that helps you create standardized Databricks Asset Bundle projects. It is designed to be used in conjunction with a Git repository, and it enforces a Gitflow-based development workflow.

When you run the `bundlepro` script with a project name, it will:

1.  Create a new feature branch in your Git repository.
2.  Create a new directory for your project.
3.  Create a `databricks.yml` file with the basic configuration for your project.
4.  Create a `src/notebook.py` file with a template notebook.
5.  Optionally, create a `resources/jobs.yml` file with a template for a Databricks Job.
6.  Optionally, create a `resources/dashboards.yml` file with a template for a Databricks Dashboard.

The script also provides a `configure` command that allows you to configure your Databricks workspace and authentication token. This information is stored in a configuration file in your home directory, and it is used by the `bundlepro` script to authenticate with your Databricks workspace.

## Instalação (Novos Usuários)

### Passo 1: Clonar este repositório
```bash
git clone git@github.com:<your-git-username>/<your-bundle-pro-repo>.git ~/bundlepro
```

### Passo 2: Instalar o bundlepro
```bash
cd ~/bundlepro
bash install.sh
```

**Nota**: O script `install.sh` corrige automaticamente as permissões necessárias.

### Passo 3: Configurar workspace e autenticação
```bash
bundlepro configure
```

Você será solicitado a fornecer:
- **Endereço do Workspace**: URL do seu workspace Databricks (ex: https://adb-1234567890123456.7.azuredatabricks.net)
- **Token de Autenticação**: Token gerado em Settings > User Settings > Access Tokens

Essas informações serão salvas de forma segura em `~/.bundlepro/config` (somente para seu usuário).

### Passo 4: Clonar o repositório de projetos (seu repositório de trabalho)
```bash
git clone git@github.com:<your-git-username>/<your-projects-repo>.git ~/<your-projects-repo>
```

## Atualização (Usuários Existentes)
```bash
cd ~/bundlepro
git pull origin master
bash install.sh
```

**Nota**: Seus dados de configuração (workspace e token) não são afetados por atualizações.

## Uso
```bash
# Entrar no repositório de projetos
cd ~/<your-projects-repo>

# Criar novo projeto
bundlepro meu-projeto
```

Durante a criação do projeto, você será perguntado se deseja criar:
- **Job**: Para execução agendada de notebooks
- **Dashboard**: Para visualização de dados e análises

Você pode criar:
- Apenas notebook (responder N para ambos)
- Notebook + Job
- Notebook + Dashboard
- Notebook + Job + Dashboard (responder S para ambos)

**Exemplo de execução:**
```bash
$ bundlepro analise-vendas
Deseja criar um Job para este projeto? (S/N): N
Deseja criar um Dashboard para este projeto? (S/N): N
Projeto 'analise-vendas' criado com sucesso!
```

## Comandos Disponíveis
```bash
bundlepro <nome-projeto>   # Criar novo projeto
bundlepro configure        # Configurar workspace e autenticação
bundlepro config           # Mostrar configuração atual
bundlepro --help           # Mostrar ajuda
bundlepro --version        # Mostrar versão
```

## Gerenciamento de Configuração

### Arquivo de Configuração

Após executar `bundlepro configure`, seus dados de conexão são armazenados em:

```
~/.bundlepro/config
```

Este arquivo:
- Contém endereço do workspace e token de autenticação
- Tem permissões restritas (600 - apenas leitura/escrita para o usuário)
- **NÃO é afetado** por atualizações ou pull do repositório
- Pode ser atualizado a qualquer momento com `bundlepro configure`
- **NUNCA deve ser compartilhado ou adicionado ao Git**

**Exemplo de conteúdo do arquivo:**
```bash
#!/bin/bash
# Bundle Pro Configuration
# ATENÇÃO: Este arquivo contém credenciais sensíveis
# Não compartilhe este arquivo ou adicione ao Git

export DATABRICKS_HOST="https://seu-workspace.databricks.com"
export DATABRICKS_TOKEN="seu-token-aqui"
export DATABRICKS_EMAIL="seu-email@empresa.com"
```

### Variáveis de Ambiente

O Bundle Pro agora suporta duas formas de configuração:

**Opção 1: Configuração via arquivo (recomendado para segurança)**
```bash
bundlepro configure
```

**Opção 2: Configuração manual via variáveis de ambiente**
```bash
# Configure manualmente as variáveis de ambiente
export DATABRICKS_HOST="https://seu-workspace.databricks.com"
export DATABRICKS_TOKEN="seu-token-aqui"
export DATABRICKS_EMAIL="seu-email@empresa.com"

# Verifique a configuração
bundlepro config
```

**Opção 3: Carregar variáveis de ambiente automaticamente**
```bash
# Adicione ao seu ~/.bashrc ou ~/.zshrc
source ~/.bundlepro/env.sh

# Recarregue o shell
source ~/.bashrc
```

### Atualizar Configuração

Para mudar workspace, token ou qualquer configuração:

```bash
bundlepro configure
```

Será solicitado novamente o endereço do workspace e token.

## Desinstalação
```bash
cd ~/bundlepro
bash uninstall.sh
```

## Requisitos

- Git instalado e configurado
- Databricks CLI instalado
- Acesso ao repositório BundlePro (chave SSH configurada)
- Python 3.7+ (para execução de scripts)

## Segurança

### Melhores Práticas de Segurança

1. **Nunca compartilhe seu token de autenticação**
   - O token dá acesso completo ao seu workspace Databricks
   - Se comprometido, revogue imediatamente no Databricks

2. **Proteja o arquivo de configuração**
   - O arquivo `~/.bundlepro/config` tem permissões 600 (apenas você pode ler/escrever)
   - Nunca adicione este arquivo ao Git
   - Nunca compartilhe este arquivo

3. **Use variáveis de ambiente com cuidado**
   - Evite colocar tokens em scripts ou arquivos de configuração
   - Prefira usar o comando `bundlepro configure` para configuração segura

4. **Revogação de tokens**
   - Se suspeitar de comprometimento, revogue o token imediatamente:
   ```bash
   # No Databricks: Settings > User Settings > Access Tokens
   # Revogue o token e gere um novo
   ```

5. **Limpeza de histórico**
   - Se acidentalmente cometer o token no Git:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch ~/.bundlepro/config' \
     --prune-empty --tag-name-filter cat -- --all
   ```

### Como o Bundle Pro protege suas credenciais

- **Permissões restritas**: Arquivo de configuração criado com `chmod 600`
- **Sem armazenamento em texto claro**: Tokens são exportados como variáveis de ambiente
- **Aviso de segurança**: Mensagens claras sobre proteção de credenciais
- **Opção de variáveis de ambiente**: Permite configuração manual sem armazenamento

### Verificação de Segurança

Para verificar suas configurações de segurança:
```bash
# Verifique permissões do arquivo de configuração
ls -la ~/.bundlepro/config

# Deve mostrar: -rw------- (permissões 600)

# Verifique se o arquivo não está no Git
cat ~/.gitignore | grep bundlepro

# Verifique configuração atual (sem mostrar token)
bundlepro config
```

## Fluxo de Desenvolvimento

O bundlepro utiliza um fluxo de desenvolvimento com **validação obrigatória de branches** seguindo Git Flow:

### Regras de Branch (Validadas Automaticamente)

O Bundle Pro valida automaticamente o fluxo de merge para garantir qualidade:

1. ✅ **feature/*** → **develop** (Permitido)
2. ✅ **develop** → **main** (Permitido)
3. ❌ **feature/*** → **main** (Bloqueado - deve passar por develop primeiro)
4. ❌ **outras branches** → **develop/main** (Bloqueado - apenas branches feature/* são permitidas)

**Diagrama do fluxo:**
```
main ← develop ← feature/meu-projeto
```

### Instalação dos Hooks de Validação

Após clonar o repositório de projetos, instale os hooks de validação:

```bash
cd ~/<your-projects-repo>

# Instalar hooks do Bundle Pro
bash <(curl -s https://raw.githubusercontent.com/<your-git-username>/<your-bundle-pro-repo>/master/install-hooks.sh)

# OU se você já tem o bundlepro instalado localmente:
bash ~/bundlepro/install-hooks.sh
```

### Passos Básicos

1. **Criar novo projeto**
   ```bash
   cd ~/<your-projects-repo>
   bundlepro meu-projeto
   ```
   - O projeto é criado automaticamente em uma branch `feature/meu-projeto` a partir de `develop`
   - Se `develop` não existir, será criada automaticamente
   - Durante a criação, responda às perguntas sobre criação de Job e Dashboard conforme sua necessidade

2. **Desenvolver na feature branch**
   - Estrutura criada: `meu-databricks/meu-projeto`
   - Edite seu notebook e configurações
   - Se criou job: edite `resources/jobs.yml` (schedule, cluster, notificações)
   - Se criou dashboard: edite `resources/dashboards.yml` e `src/dashboard.lvdash.json`
   - Configure IDs necessários em `databricks.yml`:
     - `cluster_id` (se criou job)
     - `warehouse_id` (se criou dashboard)
   - Commit suas alterações

3. **Validar e testar em DEV**
   ```bash
   databricks bundle validate -t dev
   databricks bundle deploy -t dev

   # Se criou job, executar:
   databricks bundle run -t dev notebook_job

   # Se criou dashboard, acessar URL exibida após deploy
   ```

4. **Fazer merge com develop (OBRIGATÓRIO)**
   ```bash
   git checkout develop
   git pull origin develop
   git merge feature/meu-projeto
   git push origin develop
   ```
   ⚠️ **Importante**: O hook de validação bloqueia merge direto de feature para main!

5. **Testar em develop**
   ```bash
   databricks bundle deploy -t dev
   # Executar testes de validação
   ```

6. **Fazer merge com main (Produção)**
   ```bash
   git checkout main
   git pull origin main
   git merge develop
   git push origin main
   ```

7. **Deploy em Produção**
   ```bash
   databricks bundle deploy -t prod
   ```

### Ambientes

- **develop**: Branch de integração (testes de features)
- **main**: Branch de produção (código estável e validado)
- **feature/***: Branches de desenvolvimento (uma por projeto/funcionalidade)

### Exemplos de Cenários de Uso

#### Cenário 1: Notebook simples para análise exploratória
```bash
bundlepro analise-vendas
# Responder: N para Job, N para Dashboard
```
**Resultado**: Projeto com apenas notebook, ideal para análises ad-hoc.

#### Cenário 2: Pipeline de dados agendado
```bash
bundlepro pipeline-etl
# Responder: S para Job, N para Dashboard
```
**Resultado**: Projeto com notebook + job agendado, ideal para ETL recorrente.

#### Cenário 3: Dashboard de visualização
```bash
bundlepro dashboard-vendas
# Responder: N para Job, S para Dashboard
```
**Resultado**: Projeto com notebook + dashboard, ideal para análises visuais.

#### Cenário 4: Pipeline completo com monitoramento
```bash
bundlepro pipeline-completo
# Responder: S para Job, S para Dashboard
```
**Resultado**: Projeto completo com notebook, job agendado e dashboard de monitoramento.

## Recursos Disponíveis

O **bundlepro** pode criar automaticamente diferentes tipos de recursos do Databricks:

### Criação de Jobs

Jobs permitem a execução agendada e automatizada de notebooks no Databricks.

**Configuração Automática:**

Ao criar um novo projeto, você será perguntado se deseja criar um job. Se optar por criar, o arquivo `resources/jobs.yml` será gerado com:

- **Configuração de schedule**: Agendamento usando expressão Cron (padrão: diário às 6h, pausado)
- **Cluster**: Referencia um cluster existente via variável `${var.cluster_id}`
- **Notificações**: Configurado para enviar email em caso de falha
- **Timeout**: 2 horas de tempo máximo de execução

### Criação de Dashboards

Dashboards permitem a visualização de dados e análises usando Databricks Lakeview.

**Configuração Automática:**

Ao criar um novo projeto, você será perguntado se deseja criar um dashboard. Se optar por criar, os seguintes arquivos serão gerados:

- **`resources/dashboards.yml`**: Configuração do dashboard
  - **SQL Warehouse**: Referencia um warehouse via variável `${var.warehouse_id}`
  - **Permissões**: Configurado com níveis CAN_MANAGE, CAN_RUN e CAN_VIEW
  - **Embed credentials**: Configurável para compartilhamento

- **`src/dashboard.lvdash.json`**: Definição do dashboard Lakeview
  - Template básico com página de overview
  - Widget de texto configurável
  - Estrutura para adicionar queries e visualizações

**Editando o Dashboard:**

Você pode editar o arquivo JSON manualmente ou:
1. Criar o dashboard na interface do Databricks
2. Exportar a definição JSON
3. Substituir o conteúdo de `src/dashboard.lvdash.json`

## Deploy e Validação de Bundles

**Validar bundle:**
```bash
cd ~/<your-projects-repo>/meu-projeto
databricks bundle validate -t dev
```

**Deploy para dev:**
```bash
# Defina as variáveis de ambiente (já configuradas via 'bundlepro configure')
databricks bundle deploy -t dev
```

**Deploy para prod:**
```bash
databricks bundle deploy -t prod
```

**Executar job:**
```bash
databricks bundle run -t dev notebook_job
```

**Executar com debug (para ver logs detalhados):**
```bash
databricks bundle run -t dev notebook_job --debug
```

### Configurar Cluster ID para Jobs

**Importante**: Se você criou um projeto com job, é necessário configurar o ID do cluster que executará o job antes do primeiro deploy.

**Opção 1: Via linha de comando**
```bash
databricks bundle deploy -t dev -var cluster_id=YOUR_CLUSTER_ID
```

**Opção 2: Editar databricks.yml** (recomendado para configuração permanente)

Edite o arquivo `databricks.yml` do seu projeto e defina o `cluster_id` em cada target:

```yaml
targets:
  dev:
    variables:
      cluster_id: "1234-567890-abc123"
  prod:
    variables:
      cluster_id: "9876-543210-xyz789"
```

**Como encontrar o Cluster ID:**
```bash
databricks clusters list
```

Copie o valor da coluna `ID` do cluster desejado.

### Configurar Warehouse ID para Dashboards

**Importante**: Se você criou um projeto com dashboard, é necessário configurar o ID do warehouse que será usado pelo dashboard antes do primeiro deploy.

**Opção 1: Via linha de comando**
```bash
databricks bundle deploy -t dev -var warehouse_id=YOUR_WAREHOUSE_ID
```

**Opção 2: Editar databricks.yml** (recomendado para configuração permanente)

Edite o arquivo `databricks.yml` do seu projeto e defina o `warehouse_id` em cada target:

```yaml
targets:
  dev:
    variables:
      warehouse_id: "abc123def456"
  prod:
    variables:
      warehouse_id: "xyz789uvw012"
```

**Como encontrar o Warehouse ID:**
```bash
databricks warehouses list
```

Copie o valor da coluna `id` do warehouse desejado.

## Estrutura de Arquivos dos Projetos

A estrutura de arquivos criada pelo bundlepro varia de acordo com os recursos selecionados:

### Projeto com Notebook apenas
```
meu-projeto/
├── databricks.yml           # Bundle config (apenas catalog)
├── src/
│   └── notebook.py          # Notebook principal
├── README.md
├── .gitignore
└── INSTRUCOES.txt
```

### Projeto com Notebook + Job
```
meu-projeto/
├── databricks.yml           # Bundle config (catalog + cluster_id)
├── src/
│   └── notebook.py          # Notebook principal
├── resources/
│   └── jobs.yml             # Configuração do job
├── README.md
├── .gitignore
└── INSTRUCOES.txt
```

### Projeto com Notebook + Dashboard
```
meu-projeto/
├── databricks.yml           # Bundle config (catalog + warehouse_id)
├── src/
│   ├── notebook.py          # Notebook principal
│   └── dashboard.lvdash.json # Definição do dashboard
├── resources/
│   └── dashboards.yml       # Configuração do dashboard
├── README.md
├── .gitignore
└── INSTRUCOES.txt
```

### Projeto Completo (Notebook + Job + Dashboard)
```
meu-projeto/
├── databricks.yml           # Bundle config (catalog + cluster_id + warehouse_id)
├── src/
│   ├── notebook.py          # Notebook principal
│   └── dashboard.lvdash.json # Definição do dashboard
├── resources/
│   ├── jobs.yml             # Configuração do job
│   └── dashboards.yml       # Configuração do dashboard
├── README.md
├── .gitignore
└── INSTRUCOES.txt
```

## Exemplo de Saída Validação

Após as correções, o bundle valida sem erros:

```bash
$ databricks bundle validate -t dev
Name: meu-projeto
Target: dev
Workspace:
  User: seu-usuario@example.com
  Path: /Workspace/Users/seu-usuario@example.com/.bundle/meu-projeto/dev
```

**Exemplo de erro comum (cluster_id não configurado):**
```bash
$ databricks bundle validate -t dev
Error: Variable 'cluster_id' is not defined in target 'dev'
```

## Dicas e Melhores Práticas

### Quando usar cada recurso?

**Notebooks:**
- Sempre incluído em todos os projetos
- Base para análises, transformações e processamento de dados
- Pode ser executado manualmente ou via job

**Jobs:**
- ✅ Use quando precisar de execução agendada (diário, semanal, etc.)
- ✅ Use para pipelines de ETL/ELT automatizados
- ✅ Use para processos que devem rodar sem intervenção manual
- ❌ Não use para análises exploratórias pontuais

**Dashboards:**
- ✅ Use para visualização de dados e KPIs
- ✅ Use para compartilhar análises com stakeholders
- ✅ Use para monitoramento de métricas em tempo real
- ✅ Combine com Jobs para atualização automática de dados
- ❌ Não use para processamento pesado de dados

### Fluxo de Trabalho Recomendado

**Pipeline ETL completo:**
1. Criar projeto com Job + Dashboard
2. Notebook processa dados (ETL)
3. Job agenda execução diária
4. Dashboard visualiza resultados

**Análise exploratória:**
1. Criar projeto apenas com Notebook
2. Executar análises interativamente
3. Se necessário, converter em Job posteriormente

**Dashboard de negócio:**
1. Criar projeto com Dashboard
2. Notebook prepara dados
3. Dashboard exibe visualizações
4. Adicionar Job se precisar de atualização automática

### Configuração de Variáveis

**Importante**: Sempre configure as variáveis necessárias antes do primeiro deploy:

```yaml
# databricks.yml
targets:
  dev:
    variables:
      catalog: dev_catalog
      cluster_id: "seu-cluster-id"      # Se criou Job
      warehouse_id: "seu-warehouse-id"  # Se criou Dashboard

  prod:
    variables:
      catalog: prd_catalog
      cluster_id: "seu-cluster-prod-id"
      warehouse_id: "seu-warehouse-prod-id"
```

### Gerenciamento de Permissões

**Jobs:**
- Configurar email de notificação em `resources/jobs.yml`
- Ajustar timeout conforme necessidade do processamento

**Dashboards:**
- Ajustar níveis de permissão em `resources/dashboards.yml`:
  - `CAN_MANAGE`: Administradores (editar e compartilhar)
  - `CAN_RUN`: Desenvolvedores (executar queries)
  - `CAN_VIEW`: Usuários de negócio (apenas visualizar)

## Troubleshooting

### Erro "Permission denied"

Se encontrar erro de permissão ao executar `install.sh`:
```bash
bash install.sh
```

O script corrige automaticamente as permissões necessárias.

### Erro ao validar bundle com Dashboard

**Problema**: `warehouse_id` não configurado

**Solução**:
```bash
# Opção 1: Via CLI
databricks bundle deploy -t dev -var warehouse_id=YOUR_WAREHOUSE_ID

# Opção 2: Editar databricks.yml
# Adicionar warehouse_id no target desejado
```

### Erro ao validar bundle com Job

**Problema**: `cluster_id` não configurado

**Solução**:
```bash
# Listar clusters disponíveis
databricks clusters list

# Usar o ID no deploy
databricks bundle deploy -t dev -var cluster_id=YOUR_CLUSTER_ID
```

### Dashboard não exibe dados

**Verificações**:
1. Warehouse está rodando? `databricks warehouses list`
2. Permissões do warehouse estão corretas?
3. Dashboard JSON está com sintaxe válida?
4. Dados foram processados pelo notebook?

### Job falha ao executar

**Verificações**:
1. Cluster está disponível? `databricks clusters list`
2. Cluster ID está correto no databricks.yml?
3. Timeout configurado é suficiente?
4. Verificar logs: `databricks bundle run -t dev notebook_job --debug`

### Erro de autenticação

**Problema**: Token expirado ou inválido

**Solução**:
```bash
# Atualizar token
bundlepro configure

# Verificar configuração
cat ~/.bundlepro/config
```

## Troubleshooting

**Problem: `bundlepro` command not found**

If you get an error message saying that the `bundlepro` command is not found, it means that the script is not in your `PATH`. To fix this, you need to add the directory where you cloned the `bundlepro` repository to your `PATH`.

For example, if you cloned the repository to `~/bundlepro`, you would add the following line to your `~/.bashrc` or `~/.zshrc` file:

```bash
export PATH="$HOME/bundlepro:$PATH"
```

**Problem: "Permission denied" error when running `install.sh`**

If you get a "Permission denied" error when running the `install.sh` script, it means that the script does not have execute permissions. To fix this, you need to give the script execute permissions by running the following command:

```bash
chmod +x install.sh
```

**Problem: "Permission denied" error when running `bundlepro`**

If you get a "Permission denied" error when running the `bundlepro` script, it means that the script does not have execute permissions. To fix this, you need to give the script execute permissions by running the following command:

```bash
chmod +x bundlepro
```

## Contributing

Contributions are welcome! If you would like to contribute to this project, please follow these steps:

1. Fork the repository
2. Create a new feature branch: `git checkout -b feature/minha-nova-funcionalidade`
3. Make your changes and commit: `git commit -m "feat: adiciona nova funcionalidade"`
4. Push to the branch: `git push origin feature/minha-nova-funcionalidade`
5. Submit a pull request

**Conventional Commits**: Siga o padrão de commits para mensagens claras:
- `feat:` para novas funcionalidades
- `fix:` para correções de bugs
- `docs:` para documentação
- `refactor:` para refatoração de código

## Suporte

Bundle Pro

Para dúvidas ou problemas, abra uma issue no GitHub ou entre em contato com a equipe de suporte.

**Documentação adicional:**
- [Databricks CLI Documentation](https://docs.databricks.com/dev-tools/cli/index.html)
- [Databricks Asset Bundles](https://docs.databricks.com/dev-tools/bundles/index.html)
- [Git Flow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

## FAQ (Perguntas Frequentes)

**P: Posso criar um projeto sem usar Git?**
R: Não, o Bundle Pro requer Git para gerenciamento de branches e fluxo de desenvolvimento.

**P: Como faço para atualizar o Bundle Pro?**
R: Execute `cd ~/bundlepro && git pull origin master && bash install.sh`

**P: Onde são armazenados os dados de configuração?**
R: Em `~/.bundlepro/config` com permissões restritas (apenas seu usuário pode ler).

**P: Posso usar o mesmo token para múltiplos workspaces?**
R: Não recomendado. Cada workspace deve ter seu próprio token de autenticação.

**P: Como faço para remover um projeto criado?**
R: Basta excluir a branch feature e o diretório do projeto no seu repositório.

**P: Qual a diferença entre Job e Dashboard?**
R: Job executa código agendado, Dashboard exibe visualizações de dados. Ambos podem ser criados juntos.

**P: Posso criar múltiplos notebooks em um projeto?**
R: Sim, você pode adicionar manualmente mais notebooks na pasta `src/` após a criação do projeto.

**P: Como faço para configurar as variáveis de ambiente manualmente?**
R: Você pode exportar as variáveis diretamente no shell:
```bash
export DATABRICKS_HOST='https://seu-workspace.databricks.com'
export DATABRICKS_TOKEN='seu-token-aqui'
export DATABRICKS_EMAIL='seu-email@empresa.com'
```

**P: É seguro armazenar o token no arquivo de configuração?**
R: O arquivo é protegido com permissões 600 e contém avisos de segurança. No entanto, a opção mais segura é usar variáveis de ambiente temporárias ou configurar manualmente a cada sessão.

**P: Como faço para verificar minha configuração atual?**
R: Execute `bundlepro config` para ver as informações de configuração sem expor o token.

**P: O que fazer se meu token for comprometido?**
R: Revogue imediatamente no Databricks (Settings > User Settings > Access Tokens) e gere um novo token. Em seguida, execute `bundlepro configure` para atualizar a configuração.