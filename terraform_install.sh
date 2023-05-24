#!/bin/bash

# Função para exibir status
echo_status() {
    echo "=================================="
    echo "$1"
    echo "=================================="
    sleep 2
}

# Verifica o script - deve ser executado como root para prosseguir
if [[ $(id -u) -ne 0 ]]; then
    echo_status "É necessário executar esse script como root user ou no modo sudo!"
    exit 1
fi

# Mensagem de boas-vindas
echo_status "Seja bem-vindo à instalação do Terraform! Vamos começar?"
sleep 2

# Importando chave GPG do HashiCorp 
# Verificação para ver se a chave já existe, se existir é removida de forma forçada -f (sem isso não funciona)
if [ -f "/usr/share/keyrings/hashicorp-archive-keyring.gpg" ]; then
    rm /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo_status "O serviço falhou ao importar a chave GPG"
    exit 1
fi


# Adicionar o repo da HashiCorp em sources.list.d
echo_status "Adicionando o repo da HashiCorp..."
sleep 2
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Atualizar os packages
echo_status "Atualizando os packages..."
sleep 2
sudo apt update
if [ $? -ne 0 ]; then
   echo_status "Falha ao atualizar os packages"
   exit 1
fi

# Para finalizar, instalar o Terraform
echo_status "Instalando o Terraform..."
sleep 2
sudo apt install terraform -y
if [ $? -ne 0 ]; then
    echo_status "Falha ao instalar o Terraform"
    exit 1
fi

echo_status "Instalação do Terraform concluída com sucesso!"

exit