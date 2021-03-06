#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat067()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_CFILTRO,CARQ,CKEY,_CCODVEI,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: RFATR21   쿌utor: Rosane Rodrigues       � Data:   03/02/00 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: RELATORIO DE BONIFICA��ES                                  � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento de Publicidade                       � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//�   Parametros Utilizados                   �
//�   mv_par01 = Da Data                      �
//�   mv_par02 = At� a Data                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cPerg    := "FAT022"
IF .NOT. PERGUNTE(CPERG)
   RETURN
ENDIF

cString  := "SZS"
cDesc1   := PADC("Este programa emite o relat줿io das bonifica뉏es",70)
cDesc2   := PADC("com data de circula눯o no per죓do selecionado",70)
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR21"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Bonifica뉏es"
cCabec1  := "Data de Circula눯o Inicial : " + DTOC(MV_PAR01) + SPACE(10) + "Data de Circula눯o Final : " + DTOC(MV_PAR02)
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR21_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(31)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// 쿎hama Relatorio                                �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝ptDetail � Autor � Ary Medeiros          � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

DBSELECTAREA("SZS")
_cFiltro := "ZS_FILIAL == '"+xFilial("SZS")+"'"
_cFiltro := _cFiltro+".and.DTOS(ZS_DTCIRC)>=DTOS(CTOD('"+DTOC(MV_PAR01)+"'))"
_cFiltro := _cFiltro+".and.DTOS(ZS_DTCIRC)<=DTOS(CTOD('"+DTOC(MV_PAR02)+"'))"
cArq     := CriaTrab(NIL,.F.)
cKey     := "ZS_NUMAV+ZS_ITEM+STR(ZS_EDICAO,4)"
IndRegua("SZS",cArq,cKey,,_cFiltro,"Selecionando registros .. ")
dbGotop()
SetRegua(Reccount())

Do While !eof()  
   IncRegua()

   If SZS->ZS_SITUAC == 'CC'
      DbSkip()
      Loop
   Endif

   _cCodVei := '01' + SUBSTR(SZS->ZS_CODREV,3,2)

   DbSelectArea("SC5")
   DbSeek(xFilial()+SZS->ZS_NUMAV)
   
   if .not. found() .or. sc5->c5_tptrans <> '03'
      dbselectarea("SZS")
      DBSKIP()
      LOOP
   ENDIF

   DbSelectArea("SA1")
   DbSeek(xFilial()+SZS->ZS_CODCLI)

   if nLin > 60
      nLin    := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
      nLin    := nLin + 2
      @ nlin,0 PSAY "Cliente   Nome do Cliente                            Num.AV   Item   Revista   Edi눯o   Dt.Circ.   Formato/Cores                     "
      nLin := nLin + 1
      @ nlin,0  PSAY "------   ----------------------------------------   ------   ----   -------   ------   --------   ----------------------------------"
      nLin := nLin + 1
   Endif
   nLin := nLin + 1

   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+_cCodVei)
   dbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SZS->ZS_CODPROD)

   @ nlin,000 PSAY SZS->ZS_CODCLI
   @ nlin,010 PSAY SA1->A1_NOME
   @ nlin,053 PSAY SZS->ZS_NUMAV
   @ nlin,063 PSAY SZS->ZS_ITEM
   @ nlin,069 PSAY SZJ->ZJ_DESCR
   @ nlin,079 PSAY SZS->ZS_EDICAO
   @ nlin,088 PSAY SZS->ZS_DTCIRC
   @ nlin,099 PSAY SB1->B1_DESC
   nLin   := nLin + 1

   DbSelectArea("SZS")
   DbSkip()
   IncRegua()
Enddo

DbSelectarea("SZS")
RetIndex("SZS")
DbSelectarea("SA1")
RetIndex("SA1")
DbSelectarea("SC5")
RetIndex("SC5")
DbSelectarea("SZJ")
RetIndex("SZJ")
DbSelectarea("SB1")
RetIndex("SB1")

Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



