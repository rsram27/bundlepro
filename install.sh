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

# Verificar se o arquivo bundlepro existe
if [ ! -f "$SCRIPT_DIR/bundlepro" ]; then
    echo -e "${RED}[ERRO] Arquivo bundlepro nao encontrado!${NC}"
    exit 1
fi

# Instalar
echo -e "${CYAN}Copiando bundlepro para $INSTALL_PATH...${NC}"
sudo cp "$SCRIPT_DIR/bundlepro" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

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
    echo "  1. Clone o repositorio de projetos:"
    echo "     git clone git@github.com:SEUGIT/seurepositorioprojetos.git ~/seurepositorioprojetos"
    echo ""
    echo "  2. Entre no diretorio:"
    echo "     cd ~/seurepositorioprojetos"
    echo ""
    echo "  3. Crie seu projeto:"
    echo "     bundlepro meu-projeto"
    echo ""
else
    echo -e "${RED}[ERRO] Falha na instalacao!${NC}"
    exit 1
fi