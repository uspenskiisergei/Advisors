#!/bin/bash

# ============================================
# Advisors (Советники) — Установщик для macOS
# ============================================
# Автоматически устанавливает OpenCode и проект
# ============================================

set -e

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Папки
PROJECT_DIR="$HOME/Advisors"
OPENCODE_APP="$HOME/Applications/OpenCode.app"

# Функции печати
print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}     🤖 Advisors — Система философского мышления ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}➜ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Проверка macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "Этот скрипт работает только на macOS!"
        exit 1
    fi
}

# Проверка/установка Homebrew
check_brew() {
    if ! command -v brew &> /dev/null; then
        print_step "Устанавливаем Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Установка OpenCode
install_opencode() {
    if command -v opencode &> /dev/null; then
        print_success "OpenCode уже установлен: $(opencode --version 2>/dev/null || echo 'OK')"
        return 0
    fi

    print_step "Устанавливаем OpenCode..."

    # Способ 1: Homebrew
    if command -v brew &> /dev/null; then
        print_warning "Устанавливаем через Homebrew..."
        brew install opencode-ai/opencode/opencode
        print_success "OpenCode установлен через Homebrew!"
        return 0
    fi

    # Способ 2: Direct download
    print_step "Скачиваем OpenCode..."

    # Определяем архитектуру
    if [[ $(uname -m) == 'arm64' ]]; then
        ARCH="arm64"
    else
        ARCH="x64"
    fi

    TMP_DIR="/tmp/opencode-install"
    mkdir -p "$TMP_DIR"

    DOWNLOAD_URL="https://github.com/opencode-ai/opencode/releases/latest/download/opencode-darwin-${ARCH}"

    curl -L -o "$TMP_DIR/opencode" "$DOWNLOAD_URL"
    chmod +x "$TMP_DIR/opencode"

    # Устанавливаем в /usr/local/bin или ~/bin
    if [ -w /usr/local/bin ]; then
        sudo mv "$TMP_DIR/opencode" /usr/local/bin/opencode
    else
        mkdir -p "$HOME/bin"
        mv "$TMP_DIR/opencode" "$HOME/bin/opencode"
        export PATH="$HOME/bin:$PATH"
    fi

    rm -rf "$TMP_DIR"
    print_success "OpenCode установлен!"
}

# Клонирование проекта
clone_project() {
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Проект уже существует в $PROJECT_DIR"
        echo "   Обновляем..."
        cd "$PROJECT_DIR"
        git pull origin main
    else
        print_step "Клонируем проект в $PROJECT_DIR..."
        git clone git@github.com:uspenskiisergei/Advisors.git "$PROJECT_DIR"
    fi
    print_success "Проект готов!"
}

# Запуск проекта
launch_project() {
    print_step "Запускаем OpenCode с проектом..."

    cd "$PROJECT_DIR"

    # Проверяем, установлен ли OpenCode
    if ! command -v opencode &> /dev/null; then
        print_error "OpenCode не найден. Добавьте в PATH:"
        echo "   export PATH=\"\$HOME/bin:\$PATH\""
        exit 1
    fi

    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}              🎉 Все готово!                     ${GREEN}║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    # Запускаем OpenCode
    opencode "$PROJECT_DIR"
}

# Главное меню
show_menu() {
    print_header

    echo "Выберите действие:"
    echo ""
    echo "  1) 🚀 Установить и запустить"
    echo "  2) 📥 Только скачать проект"
    echo "  3) 🔄 Обновить существующий проект"
    echo "  4) ❌ Выход"
    echo ""
}

# Основной скрипт
main() {
    check_macos

    case "${1:-}" in
        1|--install)
            check_brew
            install_opencode
            clone_project
            launch_project
            ;;
        2|--download)
            check_brew
            install_opencode
            clone_project
            echo ""
            echo "Проект скачан. Запуск:"
            echo "  cd $PROJECT_DIR && opencode ."
            ;;
        3|--update)
            if [ -d "$PROJECT_DIR" ]; then
                cd "$PROJECT_DIR"
                git pull origin main
                print_success "Проект обновлён!"
            else
                print_error "Проект не найден. Используйте установку."
                exit 1
            fi
            ;;
        4|--help|-h)
            show_menu
            echo "Использование:"
            echo "  ./install.sh           — интерактивное меню"
            echo "  ./install.sh --install — установить и запустить"
            echo "  ./install.sh --update  — обновить проект"
            ;;
        *)
            show_menu
            read -p "Введите номер (1-4): " choice
            case "$choice" in
                1) main --install ;;
                2) main --download ;;
                3) main --update ;;
                4) exit 0 ;;
                *) print_error "Неверный выбор"; exit 1 ;;
            esac
            ;;
    esac
}

main "$@"