#!/bin/sh
#
#===============================================================================#
#  NOTA DE LICENÇA                                                              #
#                                                                               #
#  Este trabalho esta licenciado sob uma Licença Creative Commons               #
#  Atribuição: Compartilhamento pela mesma Licença 3.0 Brasil. Para ver uma     #
# copia desta licença, visite http://creativecommons.org/licenses/by/3.0/br/    #
# ou envie uma carta para Creative Commons, 171 Second Street, Suite 300,       #
# San Francisco, California 94105, USA.                                         #
# ----------------------------------------------------------------------------  #
#  Autor: Jhones Petter | jhones.petter@gmail.com                               #
#  Descrição: Instalacao e configuracao do Zabbix Agent 3.0.4 no pfSense		#
#  Data criação: 22/07/2016                                                     #
#  Versao: 1.0 - (./install-zabbix3.0.4-agent-freebsd.sh)                       #
# ----------------------------------------------------------------------------- #
#
#



if [ ! -z $(pkg info | grep ^zabbix22-agent | cut -d" " -f1) ]; then
        echo "Em execucao . . ."
        cd /tmp
        fetch http://jpcorp.eti.br/downloads/zabbix/zabbix3.0.4-agent-freebsd.tar.gz
        if [ -e zabbix3.0.4-agent-freebsd.tar.gz ]; then
                tar -zxf zabbix3.0.4-agent-freebsd.tar.gz
                cd zabbix3.0.4-agent-freebsd
                        if [ $(pwd) = /tmp/zabbix3.0.4-agent-freebsd ]; then
								killall -u zabbix
                                rm -f /usr/local/bin/zabbix_sender
                                rm -f /usr/local/bin/zabbix_get
                                rm -f /usr/local/sbin/zabbix_agent
                                rm -f /usr/local/sbin/zabbix_agentd

                                cp -f zabbix_get zabbix_sender /usr/local/bin/
                                cp -f zabbix_agentd /usr/local/sbin/
                                cp -f zabbix_agentd.conf /usr/local/etc/
                                cp -Rf zabbix_agentd.conf.d /usr/local/etc/
                                echo " "

                                echo "Arquivos movidos!"
								echo " "
								echo " "
								read -p "Informe o IP do Zabbix Server: " IPZBXS
								read -p "Informe o Hostname do client: " HOSTNAME
								sed -i.bu "s/127.0.0.1/$IPZBXS/g" /usr/local/etc/zabbix_agentd.conf
								sed -i.bu "s/Zabbix server/$HOSTNAME/g" /usr/local/etc/zabbix_agentd.conf
															
                                echo " "
                                echo " "
								echo "Versao do Zabbix Agent:"
                                zabbix_agentd -V && zabbix_agentd && sleep 4
                                echo " "
                                echo " "
								echo "Processos Zabbix Agent em execucao:"
								ps aux -U zabbix
								echo " "
                                echo " "
                                echo "                  Alteracoes efetuadas com sucesso!"
								echo " "
                                echo " "
                                exit
                        else
                                echo "Erro ao entrar no diretorio zabbix3.0.4-agent-freebsd!"
                                exit
                        fi
        else
                echo "Download do pacote zabbix3.0.4-agent-freebsd.tar.gz com erro!"
                exit
        fi
else
        echo "Pacote base zabbix22-agent-2.2.11_1 nao instalado, instalar pelo FrontEnd do pfSense e executar o script novamente!"
        exit
fi