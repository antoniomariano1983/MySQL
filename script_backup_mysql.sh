declare DATA=`date +%Y%m%d_%H%M%S`
declare DIR_BACKUP="/backup/"  #  Define o diretório de backup
declare SENHA="*****************"
declare USER="root"
DIR_DEST_BACKUP=$DIR_BACKUP$DATA
##### Rotinas secundarias
mkdir -p $DIR_BACKUP/$DATA # Cria o diretório de backup diário
##################################################################
executa_backup(){
echo "Inicio do backup $DATA"
 #Recebe os nomes dos bancos de dados na maquina destino
 BANCOS=$(mysql -u $USER -p$SENHA -e "show databases")
 #retira palavra database
 #BANCOS=${BANCOS:9:${#BANCOS}}
declare CONT=0

for banco in $BANCOS
 do
 if [ $CONT -ne 0 ]; then    # ignora o primeiro item do array, cujo conteudo é "databases"
     NOME="backup_my_"$banco"_"$DATA".sql"


    echo "Iniciando backup do banco de dados [$banco]"

	mysqldump --hex-blob --lock-all-tables -u $USER -p$SENHA --databases $banco > $DIR_DEST_BACKUP/$NOME

   if [ $? -eq 0 ]; then
      echo "Backup Banco de dados [$banco] completo"
   else
      echo "ERRO ao realizar o Backup do Banco de dados [$banco]"
   fi

fi
 CONT=`expr $CONT + 1`
 done

DATA=`date +%Y%m%d_%H%M%S`

echo "Final do backup: $DATA"
}

executa_backup 2>> $DIR_BACKUP/$DATA/backup.log 1>> $DIR_BACKUP/$DATA/backup.log
