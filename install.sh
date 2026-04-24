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
step "Проверяем OpenCode..."
if command -v opencode &> /dev/null; then
    ok "OpenCode уже установлен"
else
    step "Устанавливаем OpenCode..."
    if command -v brew &> /dev/null; then
        brew install opencode-ai/opencode/opencode 2>/dev/null || {
            ARCH=$([[ $(uname -m) == 'arm64' ]] && echo "arm64" || echo "x64")
            curl -L -o /tmp/opencode "https://github.com/opencode-ai/opencode/releases/latest/download/opencode-darwin-${ARCH}"
            chmod +x /tmp/opencode
            [ -w /usr/local/bin ] && sudo mv /tmp/opencode /usr/local/bin/opencode || {
                mkdir -p "$HOME/bin"
                mv /tmp/opencode "$HOME/bin/opencode"
            }
        }
        ok "OpenCode установлен"
    fi
fi

# Проект
step "Скачиваем проект..."
if [ -d "$PROJECT_DIR" ]; then
    cd "$PROJECT_DIR" && git pull origin main 2>/dev/null
    ok "Проект обновлён"
else
    git clone git@github.com:uspenskiisergei/Advisors.git "$PROJECT_DIR"
    ok "Проект скачан"
fi

echo ""
echo "============================================"
ok "Установка завершена!"
echo "============================================"
echo ""
echo "Запуск:"
echo "  cd $PROJECT_DIR && opencode ."
echo ""
echo "Затем скажите: «Хочу философскую сессию»"
echo ""