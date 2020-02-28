#!/bin/bash -e

export PROJECT_FOLDER=/home/consumer
export DEPLOY_USER=consumer

echo "############################################################################################################"
echo "######################### ConsumerCard Publicando no Ambiente de Produção ##################################"
echo "############################################################################################################"

source /etc/profile

if [ "$USER" != "$DEPLOY_USER" ]; then
  echo "Você deve rodar este script com o usuário $DEPLOY_USER"
  exit 1
fi

cd $PROJECT_FOLDER

echo 'Atualizando arquivos via GIT do repostiório'
git checkout Gemfile.lock
git pull origin master

echo 'Executando Bundle'
bundle -V --without development test

echo 'Rodando db:migrate'
RAILS_ENV=production bundle exec rake db:migrate

if [ -f "config/schedule.rb" ]; then
  echo 'Atualizando Crontab'
  RAILS_ENV=production bundle exec whenever -i
fi

echo 'Reiniciando Serviços'
./run.sh

echo "############################################################################################################"
echo "################################# ConsumerCard Publicado Com Sucesso \o/ ###################################"
echo "############################################################################################################"
