# Bundle Pro - Validação de Branches

## Visão Geral

O Bundle Pro implementa **validação automática de branches** através de Git hooks para garantir a qualidade e consistência do fluxo de desenvolvimento.

## Regras de Validação

### ✅ Merges Permitidos

1. **feature/*** → **develop**
   - Branches de feature DEVEM ser mergeadas primeiro com develop
   - Permite testes de integração antes de ir para produção
   - Exemplo:
     ```bash
     git checkout develop
     git merge feature/meu-projeto
     ```

2. **develop** → **main**
   - Após validação em develop, o código pode ir para produção
   - Garante que apenas código testado chegue em main
   - Exemplo:
     ```bash
     git checkout main
     git merge develop
     ```

### ❌ Merges Bloqueados

1. **feature/*** → **main**
   - Bloqueado automaticamente pelo hook
   - Features DEVEM passar por develop primeiro
   - Mensagem de erro será exibida orientando o fluxo correto

2. **Branches sem padrão feature/*** → **develop/main**
   - Apenas branches nomeadas como `feature/*` podem ser mergeadas
   - Garante nomenclatura consistente
   - Exemplo de branch inválida: `meu-projeto`, `fix-bug`, `teste`
   - Exemplo de branch válida: `feature/meu-projeto`, `feature/fix-bug`

## Instalação dos Hooks

### Primeira vez (após clonar repositório de projetos)

```bash
cd ~/seurepositorioprojetos
bash /usr/local/share/bundlepro/install-hooks.sh
```

### Verificar se os hooks estão instalados

```bash
ls -la .git/hooks/
# Deve mostrar:
# - prepare-commit-msg
# - pre-merge-commit
```

## Fluxo Completo de Desenvolvimento

### 1. Criar nova feature

```bash
cd ~/seurepositorioprojetos
bundlepro meu-projeto
# Automaticamente cria branch: feature/meu-projeto
```

### 2. Desenvolver e testar

```bash
# Editar arquivos
# Validar
databricks bundle validate -t dev
databricks bundle deploy -t dev

# Commit
git add .
git commit -m "feat: adicionar meu-projeto"
git push origin feature/meu-projeto
```

### 3. Merge com develop

```bash
git checkout develop
git pull origin develop
git merge feature/meu-projeto

# O hook valida: ✅ feature/* -> develop PERMITIDO
git push origin develop
```

### 4. Testar em develop

```bash
databricks bundle deploy -t dev
# Executar testes de integração
```

### 5. Merge com main (produção)

```bash
git checkout main
git pull origin main
git merge develop

# O hook valida: ✅ develop -> main PERMITIDO
git push origin main
```

### 6. Deploy em produção

```bash
databricks bundle deploy -t prod
```

## Mensagens de Erro Comuns

### Tentativa de merge feature/* → main

```
========================================
[ERRO] Merge bloqueado!
========================================

Features devem ser mergeadas primeiro com 'develop'
antes de irem para 'main'.

Fluxo correto:
  1. git checkout develop
  2. git merge feature/meu-projeto
  3. git push origin develop
  4. # Testar em ambiente de desenvolvimento
  5. git checkout main
  6. git merge develop
  7. git push origin main
```

### Tentativa de merge de branch sem padrão feature/*

```
========================================
[ERRO] Merge bloqueado!
========================================

Branch 'meu-projeto' não segue o padrão de nomenclatura.

Regras:
  - Apenas branches 'feature/*' podem ser mergeadas com develop
  - Apenas branch 'develop' pode ser mergeada com main

Exemplo de branch válida:
  feature/meu-projeto
  feature/nova-funcionalidade
```

## Criação da Branch Develop

Se a branch `develop` não existir no repositório, o Bundle Pro a criará automaticamente:

```bash
cd ~/seurepositorioprojetos
bundlepro meu-projeto

# Output:
# [AVISO] A branch 'develop' não existe.
# [CRIANDO] branch 'develop'...
# [OK] Branch 'develop' criada
# Envie para o repositório remoto: git push origin develop
```

### Criar develop manualmente (opcional)

```bash
git checkout main
git checkout -b develop
git push origin develop
```

## Benefícios das Validações

1. **Qualidade**: Garante que todo código passe por develop antes de produção
2. **Consistência**: Força nomenclatura padronizada de branches
3. **Segurança**: Previne deploys acidentais direto para produção
4. **Rastreabilidade**: Facilita identificar features por nome de branch
5. **Colaboração**: Todos seguem o mesmo fluxo de trabalho

## Troubleshooting

### Hook não está funcionando

Verifique se os hooks estão instalados e executáveis:

```bash
cd ~/seurepositorioprojetos
ls -la .git/hooks/prepare-commit-msg
ls -la .git/hooks/pre-merge-commit

# Se não existirem, reinstale:
bash /usr/local/share/bundlepro/install-hooks.sh
```

### Desabilitar validação temporariamente (não recomendado)

```bash
# ATENÇÃO: Isso desabilita as proteções!
# Use apenas em casos excepcionais
git commit --no-verify -m "mensagem"
```

### Remover hooks

```bash
cd ~/seurepositorioprojetos
rm .git/hooks/prepare-commit-msg
rm .git/hooks/pre-merge-commit
```

## Suporte

Para reportar problemas ou sugestões sobre as validações de branches:
- Repositório: https://github.com/SEUGIT/seurepositorio/issues
- Time Data Engineering - Bundle Pro
