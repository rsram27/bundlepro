# Bundle Pro - bundlepro

Ferramenta CLI para criar projetos Databricks Asset Bundles padronizados.

## Instalacao (Novos Usuarios)

### Passo 1: Clonar este repositorio
```bash
git clone git@github.com:BundlePro/bundlepro-databricks-dab.git ~/bundlepro-databricks-dab
```

### Passo 2: Instalar o bundlepro
```bash
cd ~/bundlepro-databricks-dab
bash install.sh
```

**Nota**: O script `install.sh` corrige automaticamente as permissões necessárias.

### Passo 3: Clonar o repositorio de projetos
```bash
git clone git@github.com:BundlePro/bundlepro-databricks.git ~/bundlepro-databricks
```

## Atualizacao (Usuarios Existentes)
```bash
cd ~/bundlepro-databricks-dab
git pull origin main
bash install.sh
```

## Uso
```bash
# Entrar no repositorio de projetos
cd ~/bundlepro-databricks

# Criar novo projeto
bundlepro meu-projeto
```

## Comandos Disponiveis
```bash
bundlepro <nome-projeto>   # Criar novo projeto
bundlepro --help           # Mostrar ajuda
bundlepro --version        # Mostrar versao
```

## Desinstalacao
```bash
cd ~/bundlepro-databricks-dab
bash uninstall.sh
```

## Requisitos

- Git instalado
- Databricks CLI instalado
 - Acesso ao repositorio BundlePro (chave SSH configurada)

## Troubleshooting

### Erro "Permission denied"

Se encontrar erro de permissão ao executar `install.sh`:
```bash
bash install.sh
```

O script corrige automaticamente as permissões necessárias.

## Suporte

Bundle Pro