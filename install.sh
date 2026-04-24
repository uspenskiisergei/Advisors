#!/bin/bash

# ============================================
# Advisors — Установщик для macOS
# ============================================
# curl -s https://.../install.sh | bash
# ============================================

set -e

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$HOME/Advisors"

# Печать
step() { echo -e "${GREEN}➜${NC} $1"; }
ok() { echo -e "${GREEN}✅${NC} $1"; }
warn() { echo -e "${YELLOW}⚠️${NC} $1"; }
fail() { echo -e "${RED}❌${NC} $1"; }

# Проверка macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    fail "Только для macOS!"
    exit 1
fi

echo ""
echo "🤖 Advisors — Система философского мышления"
echo "============================================"
echo ""

# OpenCode
step "Проверяем OpenWork..."
if command -v opencode &> /dev/null; then
    ok "OpenWork уже установлен"
else
    step "Устанавливаем OpenWork..."
    if command -v brew &> /dev/null; then
        brew install opencode-ai/opencode/opencode 2>/dev/null || install_direct
    else
        install_direct
    fi
    ok "OpenWork установлен"
fi

install_direct() {
    ARCH=$([[ $(uname -m) == 'arm64' ]] && echo "arm64" || echo "x64")
    TMP="/tmp/opencode-$$"
    curl -L -o "$TMP" "https://github.com/opencode-ai/opencode/releases/latest/download/opencode-darwin-${ARCH}"
    chmod +x "$TMP"
    if [ -w /usr/local/bin ]; then
        sudo mv "$TMP" /usr/local/bin/opencode
    else
        mkdir -p "$HOME/bin"
        mv "$TMP" "$HOME/bin/opencode"
        export PATH="$HOME/bin:$PATH"
    fi
}

# Проект
step "Скачиваем проект..."
if [ -d "$PROJECT_DIR" ]; then
    cd "$PROJECT_DIR" && git pull origin main 2>/dev/null
    ok "Проект обновлён в $PROJECT_DIR"
else
    git clone git@github.com:uspenskiisergei/Advisors.git "$PROJECT_DIR"
    ok "Проект скачан в $PROJECT_DIR"
fi

echo ""
echo "============================================"
ok "Всё готово!"
echo "============================================"
echo ""
echo "Запускаем OpenWork с проектом..."
echo ""

# Запускаем OpenWork
cd "$PROJECT_DIR"
opencode "$PROJECT_DIR"