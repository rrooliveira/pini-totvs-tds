#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

User Function Fatc01d()        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_APOSARQ,_NVEZ,_PAR01,_PAR02,MV_PAR01,MV_PAR02")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: FATC01D   쿌utor: Mauricio Mendes        쿏ata:    13/11/01 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: Chamada para o pedido de Vendas                            � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so          : Especifico PINI Editora Ltda.                          � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
_aPosArq   := { {Alias(),0,0}, {"SC5",0,0}, {"SC6",0,0}, {"SA1",0,0}, {"SC9",0,0}, {"SE1",0,0} }
For _nVez := 1 to Len(_aPosArq)
	dbSelectArea( _aPosArq[_nVez,1] )
	_aPosArq[_nVez,2] := IndexOrd()
	_aPosArq[_nVez,3] := Recno()
Next

_PAR01 := MV_PAR01
_PAR02 := MV_PAR02

MATA410()


For _nVez := 2 to Len(_aPosArq)
    dbSelectArea(_aPosArq[_nVez,1])
    dbSetOrder(_aPosArq[_nVez,2])
    dbGoTo(_aPosArq[_nVez,3])
Next
dbSelectArea(_aPosArq[1,1])
dbSetOrder(_aPosArq[1,2])
dbGoTo(_aPosArq[1,3])

MV_PAR01 := _PAR01
MV_PAR02 := _PAR02

Return

