#!/bin/bash

# ============================================
# Advisors — Установщик (One-liner)
# ============================================
# Запуск: bash <(curl -s https://raw.githubusercontent.com/uspenskiisergei/Advisors/main/install Advisors.sh)
# ============================================

set -e

TARGET_DIR="${1:-$HOME/Advisors}"

echo ""
echo "🤖 Advisors — Система философского мышления"
echo "============================================"
echo ""

# Проверка Git
if ! command -v git &> /dev/null; then
    echo "❌ Git не установлен."
    echo "   Установите: https://git-scm.com/download/mac"
    exit 1
fi

# Проверка OpenCode
if ! command -v opencode &> /dev/null; then
    echo "❌ OpenCode не установлен."
    echo "   Установите: https://opencode.ai"
    exit 1
fi

# Установка
echo "📁 Клонирование в: $TARGET_DIR"

if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Папка уже существует. Обновляем..."
    cd "$TARGET_DIR"
    git pull origin main
else
    git clone git@github.com:uspenskiisergei/Advisors.git "$TARGET_DIR"
fi

echo ""
echo "✅ Готово!"
echo ""
echo "Запуск:"
echo "  cd $TARGET_DIR"
echo "  opencode ."
echo ""
echo "Или одной командой:"
echo ""
echo "  cd $TARGET_DIR && opencode ."
echo ""