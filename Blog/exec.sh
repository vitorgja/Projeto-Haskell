#!/bin/bash
clear


# contador=1
# if [ "$1" = "" ]; then
# 	echo 
# 	echo "./exec.sh arg arg ... arg"
# 	exit
# fi
# while [ "$1" != "" ]; do
# 	echo "O $contator o. argumento é: $1"
# 	shift
# 	contador = `expr $contador + 1`
# done

Finish(){
	sleep 1
	echo "Acabou !"
	sleep 0.5
}

if [ "$*" != "" ]; then
	echo "Parametros: $*"
	while [ "$*" != "" ]; do
		echo "Position: '$1'"
		case $1 in
			1) echo "Clean"; sudo stack clean; Finish ;;
			2) echo "Build" ; sudo stack build ; Finish ;;
			3) echo "Clean and Build" ; sudo stack clean ; sudo stack build ; Finish ;;
			4) echo "Exec" ; sudo stack exec blog ; Finish ;;
			5) echo "Clean, Build and Exec" ; sudo stack clean ; sudo stack build ; sudo stack exec blog ; Finish ;;
			*) echo "Parametros invalidos"; Finish ;;
		esac
		shift
	done
	exit
fi




Programa(){



	Menu
	read opcao
	case $opcao in
		1) Clean ;;
		2) Compilar ;;
		3) Clear_Compilar ;;
		4) Executar ;;
		0) Exit ;;
		*) Erro ;;
	esac
}








Menu(){
	echo "|+---------------------+|"
	echo "| 1. Clear              |"
	echo "| 2. Compilar           |"
	echo "| 3. Clear and Compilar |"
	echo "| 4. Executar           |"
	echo "| 0. Sair               |"
	echo "|+---------------------+|"
	echo
	echo -n "Escolha uma Opc: "
}
Clean(){
	echo "Clean!"
	sudo stack clean
	sleep 1
	Programa
}
Compilar(){
	echo "Build Project!"
	echo "" 
	sudo stack build
	sleep 1
	Programa
}
Clear_Compilar(){
	echo "Clean!"
	sudo stack clean
	echo ""
	echo "Build Project!"
	echo "" 
	stack build
	
	sleep 1
	Programa
}
Executar(){
	echo "Execute"
	sudo stack exec blog
	sleep 1
	Programa
}
Exit(){
	# clear
	# exit
	echo "Sair"
}
Erro(){
	echo "Opção Invalida!"
	sleep 1
	Programa
}

Programa