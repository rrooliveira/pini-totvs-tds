#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

User Function Contfat()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

// Alterado por Danilo C S Pala 20050520: CFB                                                                   
//Alterado por Danilo C S Pala em 20070315: CFE
//Alterado por Danilo C S Pala em 20070328: NFS
//Alterado por Danilo C S Pala em 20080220: SEN
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("MVLR,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇� 16/03/02 � Execblock utilizado na contabilizacao do faturamento    낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
mVlr:=0
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+SD2->D2_TES)
IF SF4->F4_DUPLIC=='S'
   If Trim(SD2->D2_SERIE) $'UNI/D1/CUP/CFS/CFA/CFB/ANG/CFE/NFS/SEN/8'  //20050520 : CFB //20061031 ANG  //20070315 CFE  //20070328 NFS //20080220 SEN
      mVlr:=SD2->D2_TOTAL
   Endif
ENDIF
// Substituido pelo assistente de conversao do AP5 IDE em 19/03/02 ==> __Return(mVlr)
Return(mVlr)        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02



