# Bundle Pro - bundlepro

**Versão**: 1.2.0

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
git pull origin master
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

## Criação de Jobs

O **bundlepro** pode criar automaticamente jobs para execução de notebooks no Databricks.

### Configuração de Jobs

Ao criar um novo projeto, você será perguntado se deseja criar um job. Se optar por criar, o arquivo `resources/jobs.yml` será gerado com:

- **Configuração de schedule**: Agendamento usando expressão Cron (padrão: diário às 6h, pausado)
- **Cluster**: Referencia um cluster existente via variável `${var.cluster_id}`
- **Notificações**: Configurado para enviar email em caso de falha
- **Timeout**: 2 horas de tempo máximo de execução

## Deploy e Validação de Bundles

**Validar bundle:**
```bash
cd ~/seurepositorioprojetos/meu-projeto
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

## Troubleshooting

### Erro "Permission denied"

Se encontrar erro de permissão ao executar `install.sh`:
```bash
bash install.sh
```

O script corrige automaticamente as permissões necessárias.

## Suporte

Bundle Pro