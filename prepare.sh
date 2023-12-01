#!/bin/bash

# Cores para melhor visibilidade
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[0;33m'
NC='\033[0m' # Sem cor

# Função de log
log() {
    local nivel_log=$1
    local mensagem=$2

    case $nivel_log in
        "INFO")
            echo -e "${VERDE}[INFO]${NC} ${mensagem}"
            ;;
        "WARNING")
            echo -e "${AMARELO}[WARNING]${NC} ${mensagem}"
            ;;
        "ERROR")
            echo -e "${VERMELHO}[ERROR]${NC} ${mensagem}"
            ;;
        *)
            echo "[UNKNOWN] ${mensagem}"
            ;;
    esac
}

# Verificar se o script tem permissão de execução
verificar_permissao() {
    if [ ! -x "$0" ]; then
        log "ERROR" "O script não tem permissão de execução. Saindo... Execute com SUDO."
        exit 1
    fi
}

# Verificar se o sistema operacional é o Ubuntu
verificar_os() {
    if [ "$(lsb_release -is)" != "Ubuntu" ]; then
        log "ERROR" "Este script foi projetado para sistemas Ubuntu. Saindo."
        exit 1
    fi
}

# Configurar data e hora
configurar_data_hora() {
    log "INFO" "Configurando data e hora..."
    timedatectl set-timezone America/Sao_Paulo
    apt-get install -y ntp ntpdate
    service ntp stop
    ntpdate a.st1.ntp.br
    service ntp start
}

# Atualizar o sistema
atualizar_sistema() {
    log "INFO" "Atualizando o sistema..."
    sudo apt-get update && sudo apt-get upgrade -y
    apt-get -y autoremove
    apt-get -y autoclean
    apt-get -y clean
}

# Instalar o neofetch
instalar_neofetch() {
    log "INFO" "Instalando o neofetch..."
    sudo apt-get install neofetch -y
}

# Instalar o Webmin
instalar_webmin() {
    log "INFO" "Instalando o Webmin..."
    sudo sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
    wget -qO- http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install webmin -y
}

# Instalar o htop
instalar_htop() {
    log "INFO" "Instalando o htop..."
    sudo apt-get install htop -y
}

# Configurar neofetch como motd
neofetch_para_motd() {
    log "INFO" "Configurando o neofetch como MOTD..."
    sudo bash -c "echo 'neofetch' >> /etc/motd"
    sudo bash -c "echo 'neofetch' >> ~/.bashrc"
    echo "echo -e 'Acesse o Webmin em: ${VERDE}http://localhost:10000${NC}'" >> ~/.bashrc
}

# Função principal
principal() {
    verificar_permissao
    verificar_os
    configurar_data_hora
    atualizar_sistema
    instalar_neofetch
    instalar_webmin
    instalar_htop
    neofetch_para_motd
    log "INFO" "Execução do script concluída com sucesso."
}

# Executar a função principal
principal
