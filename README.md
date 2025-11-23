# Bundle Pro - bundlepro

Ferramenta CLI para criar projetos Databricks Asset Bundles padronizados.

## Instalacao (Novos Usuarios)

### Passo 1: Clonar este repositorio
```bash
git clone git@github.com:SEUGIT/seurepositorio.git ~/seurepositorio
```

### Passo 2: Instalar o bundlepro
```bash
cd ~/seurepositorio
bash install.sh
```

**Nota**: O script `install.sh` corrige automaticamente as permissões necessárias.

### Passo 3: Configurar workspace e autenticação
```bash
bundlepro configure
```

Você será solicitado a fornecer:
- **Endereço do Workspace**: URL do seu workspace Databricks
- **Token de Autenticação**: Token gerado em Settings > User Settings > Access Tokens

Essas informações serão salvas de forma segura em `~/.bundlepro/config` (somente para seu usuário).

### Passo 4: Clonar o repositorio de projetos (seu repositorio de trabalho)
```bash
git clone git@github.com:SEUGIT/seurepositorioprojetos.git ~/seurepositorioprojetos
```

## Atualizacao (Usuarios Existentes)
```bash
cd ~/seurepositorio
git pull origin main
bash install.sh
```

**Nota**: Seus dados de configuração (workspace e token) não são afetados por atualizações.

## Uso
```bash
# Entrar no repositorio de projetos
cd ~/seurepositorioprojetos

# Criar novo projeto
bundlepro meu-projeto
```

## Comandos Disponiveis
```bash
bundlepro <nome-projeto>   # Criar novo projeto
bundlepro configure        # Configurar workspace e autenticação
bundlepro --help           # Mostrar ajuda
bundlepro --version        # Mostrar versao
```

## Gerenciamento de Configuração

### Arquivo de Configuração

Após executar `bundlepro configure`, seus dados de conexão são armazenados em:

```
~/.bundlepro/config
```

Este arquivo:
- Contém endereço do workspace e token de autenticação
- Tem permissões restritas (readable apenas para o usuário)
- **NÃO é afetado** por atualizações ou pull do repositório
- Pode ser atualizado a qualquer momento com `bundlepro configure`

### Atualizar Configuração

Para mudar workspace, token ou qualquer configuração:

```bash
bundlepro configure
```

Será solicitado novamente o endereço do workspace e token.

## Desinstalacao
```bash
cd ~/seurepositorio
bash uninstall.sh
```

## Requisitos

- Git instalado
- Databricks CLI instalado
- Acesso ao repositorio BundlePro (chave SSH configurada)

## Fluxo de Desenvolvimento

O bundlepro utiliza um fluxo simples de desenvolvimento com feature branches:

### Passos Básicos

1. **Criar novo projeto**
   ```bash
   cd ~/seurepositorioprojetos
   bundlepro meu-projeto
   ```

2. **Desenvolver na feature branch**
   - O projeto é criado automaticamente em uma branch `feature/meu-projeto`
   - Estrutura criada: `meu-databricks/meu-projeto`
   - Edite seu notebook e configurações

3. **Validar e testar em DEV**
   ```bash
   databricks bundle validate -t dev
   databricks bundle deploy -t dev
   ```

4. **Fazer merge com master**
   ```bash
   git checkout master
   git pull origin master
   git merge feature/meu-projeto
   git push origin master
   ```

5. **Deploy em Produção**
   ```bash
   databricks bundle deploy -t prod
   ```

### Ambientes

- **dev**: Workspace de desenvolvimento (usa feature branch para testes)
- **prod**: Workspace de produção (usa master branch após merge)

## Criação de Jobs com Serverless

O **bundlepro** cria automaticamente jobs utilizando **Databricks Serverless Compute** para execução otimizada e sem gerenciamento de clusters.

### Configuração de Jobs

Ao criar um novo projeto com a opção de job (`bundlepro meu-projeto`), o arquivo `resources/jobs.yml` é gerado com:

- **Compute Serverless**: Referenciado via variável `${var.compute_id}`
- **Otimizações Delta**: Configuradas para melhor performance
- **Schedule**: Job agendado para executar diariamente (6:00 AM - timezone São Paulo)
- **Notificações**: Alertas de falha por email

### Configurar Compute ID

Edite o arquivo `databricks.yml` e adicione o ID do seu compute serverless:

```yaml
variables:
  compute_id:
    default: "YOUR_SERVERLESS_COMPUTE_ID"
```

Ou passe via CLI:

```bash
databricks bundle deploy -t dev -var compute_id=YOUR_SERVERLESS_COMPUTE_ID
```

### Exemplo de Job Criado

```yaml
tasks:
  - task_key: run_notebook
    notebook_task:
      notebook_path: ../src/notebook.py
    compute: ${var.compute_id}
    spark_conf:
      spark.databricks.delta.optimizeWrite.enabled: "true"
      spark.databricks.delta.autoCompact.enabled: "true"
```

## Troubleshooting

### Erro "Permission denied"

Se encontrar erro de permissão ao executar `install.sh`:
```bash
bash install.sh
```

O script corrige automaticamente as permissões necessárias.

## Suporte

Bundle Pro