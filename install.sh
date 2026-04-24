#!/bin/bash

# Advisors — Быстрая установка
# Скачивает проект в текущую папку

set -e

echo ""
echo "🤖 Advisors — Система философского мышления"
echo "============================================"
echo ""

echo "Этот скрипт скачает проект Advisors"
echo "в текущую папку: $(pwd)"
echo ""

if [ -f "opencode.jsonc" ]; then
    echo "⚠️  Папка уже содержит проект. Откройте её в OpenWork."
    exit 0
fi

echo "Скачиваем..."
git clone git@github.com:uspenskiisergei/Advisors.git .

echo ""
echo "============================================"
echo "✅ Готово!"
echo "============================================"
echo ""
echo "1. Откройте эту папку в OpenWork"
echo "2. Напишите: «Хочу философскую сессию»"
echo ""