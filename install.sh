#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Instalando bundlepro${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# SCRIPT_DIR and install path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="/usr/local/bin/bundlepro"
HOOKS_INSTALL_PATH="/usr/local/share/bundlepro"

# Verificar se o arquivo bundlepro existe
if [ ! -f "$SCRIPT_DIR/bundlepro" ]; then
    echo -e "${RED}[ERRO] Arquivo bundlepro nao encontrado!${NC}"
    exit 1
fi

# Instalar bundlepro
echo -e "${CYAN}Copiando bundlepro para $INSTALL_PATH...${NC}"
sudo cp "$SCRIPT_DIR/bundlepro" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

# Instalar hooks e scripts auxiliares
echo -e "${CYAN}Instalando hooks e scripts auxiliares...${NC}"
sudo mkdir -p "$HOOKS_INSTALL_PATH"
if [ -d "$SCRIPT_DIR/.git-hooks" ]; then
    sudo cp -r "$SCRIPT_DIR/.git-hooks" "$HOOKS_INSTALL_PATH/"
fi
if [ -f "$SCRIPT_DIR/install-hooks.sh" ]; then
    sudo cp "$SCRIPT_DIR/install-hooks.sh" "$HOOKS_INSTALL_PATH/"
    sudo chmod +x "$HOOKS_INSTALL_PATH/install-hooks.sh"
fi

# Verificar instalacao
if [ -f "$INSTALL_PATH" ]; then
    echo ""
    echo -e "${GREEN}[OK] bundlepro instalado com sucesso!${NC}"
    echo ""
    echo -e "${CYAN}Versao instalada:${NC}"
    bundlepro --version
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}CONFIGURACAO INICIAL${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo "Execute 'bundlepro configure' para configurar o workspace e autenticação:"
    echo ""
    echo "  bundlepro configure"
    echo ""
    echo "Em seguida, siga os passos:"
    echo ""
    echo "  1. Clone o seu repositório de projetos:"
    echo "     git clone git@github.com:<your-git-username>/<your-projects-repo>.git ~/<your-projects-repo>"
    echo ""
    echo "  2. Entre no diretório do seu repositório de projetos e instale os hooks de validação:"
    echo "     cd ~/<your-projects-repo>"
    echo "     bash /usr/local/share/bundlepro/install-hooks.sh"
    echo ""
    echo "  3. Configure o caminho para o seu repositório de projetos:"
    echo "     bundlepro configure-projects-repo ~/<your-projects-repo>"
    echo ""
    echo "  4. Crie seu primeiro projeto:"
    echo "     bundlepro meu-projeto"
    echo ""
    echo -e "${YELLOW}IMPORTANTE:${NC} Os hooks de validação garantem que:"
    echo "  - Apenas branches feature/* podem ser mergeadas"
    echo "  - feature/* deve ser mergeada com develop primeiro"
    echo "  - develop deve ser mergeada com main para producao"
    echo ""
else
    echo -e "${RED}[ERRO] Falha na instalacao!${NC}"
    exit 1
fi