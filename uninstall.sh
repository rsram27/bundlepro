#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}Desinstalando bundlepro...${NC}"
echo ""

INSTALL_PATH="/usr/local/bin/bundlepro"

if [ -f "$INSTALL_PATH" ]; then
    sudo rm "$INSTALL_PATH"
    echo -e "${GREEN}[OK] bundlepro removido com sucesso!${NC}"
else
    echo -e "${YELLOW}[INFO] bundlepro nao estava instalado.${NC}"
fi