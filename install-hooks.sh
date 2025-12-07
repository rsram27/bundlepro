#!/bin/bash

# ============================================
# Bundle Pro - Instalador de Git Hooks
# ============================================
# Este script instala os hooks do Bundle Pro
# no repositório de projetos
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Bundle Pro - Instalação de Git Hooks${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Verificar se estamos em um repositório git
if [ ! -d ".git" ]; then
    echo -e "${RED}[ERRO] Este diretório não é um repositório Git!${NC}"
    echo ""
    echo -e "${CYAN}Execute este script dentro do seu repositório de projetos:${NC}"
    echo "  cd ~/seurepositorioprojetos"
    echo "  bash /caminho/para/install-hooks.sh"
    echo ""
    exit 1
fi

# Criar diretório de hooks se não existir
mkdir -p .git/hooks

# Caminho dos hooks do Bundle Pro
HOOKS_SOURCE_DIR="/usr/local/share/bundlepro/.git-hooks"

# Verificar se o diretório de hooks fonte existe
if [ ! -d "$HOOKS_SOURCE_DIR" ]; then
    echo -e "${RED}[ERRO] Diretório de hooks não encontrado: $HOOKS_SOURCE_DIR${NC}"
    echo -e "${YELLOW}[DICA] Execute 'bash install.sh' para instalar o Bundle Pro corretamente${NC}"
    exit 1
fi

# Copiar hook pre-merge-commit
if [ -f "$HOOKS_SOURCE_DIR/pre-merge-commit" ]; then
    echo -e "${CYAN}[INSTALANDO] pre-merge-commit hook...${NC}"
    cp "$HOOKS_SOURCE_DIR/pre-merge-commit" .git/hooks/pre-merge-commit
    chmod +x .git/hooks/pre-merge-commit
    echo -e "${GREEN}[OK] Hook pre-merge-commit instalado${NC}"
else
    echo -e "${YELLOW}[AVISO] Hook pre-merge-commit não encontrado${NC}"
fi

# Criar hook prepare-commit-msg que chama pre-merge-commit
echo -e "${CYAN}[INSTALANDO] prepare-commit-msg hook...${NC}"
cat > .git/hooks/prepare-commit-msg << 'HOOKEOF'
#!/bin/bash
# Bundle Pro - Prepare Commit Message Hook
# Chama o pre-merge-commit para validar merges

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Se for um merge, executar validação
if [ "$COMMIT_SOURCE" = "merge" ]; then
    if [ -x .git/hooks/pre-merge-commit ]; then
        .git/hooks/pre-merge-commit
        exit $?
    fi
fi

exit 0
HOOKEOF

chmod +x .git/hooks/prepare-commit-msg
echo -e "${GREEN}[OK] Hook prepare-commit-msg instalado${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Hooks instalados com sucesso!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Regras de merge ativas:${NC}"
echo "  1. feature/* -> develop (permitido)"
echo "  2. develop -> main (permitido)"
echo "  3. feature/* -> main (bloqueado)"
echo "  4. outras branches -> develop/main (bloqueado)"
echo ""
echo -e "${YELLOW}Importante:${NC}"
echo "  - Crie a branch 'develop' se ainda não existir:"
echo "    git checkout -b develop"
echo "    git push origin develop"
echo ""
