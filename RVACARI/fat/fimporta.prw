#INCLUDE "protheus.ch"                                                                              
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"  
#INCLUDE "AP5MAIL.ch"   

/*                                                                                                                                                    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PEDSITEC1()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro 	:= "Controle de Pedido de Vendas ContentStaff" 
Private aCores		:= {} 
Private dDataI		:= ddatabase

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar"				,"AxPesqui"			,0,1} ,;
		             {"Visualizar"				,"AxVisual"			,0,2} ,;
		             {"Importar Arquivo"		,"U_fImporta()"		,0,3} ,;
		             {"Alterar"					,"AxAltera"			,0,4} ,;
		             {"Excluir"					,"AxDeleta"			,0,5} ,;
		             {"Cad Cliente"				,"U_PEDSITTEL()"	,0,6} ,;
		             {"Gera P.V.P"				,"U_CADPEDS1()"		,0,7} ,; 
		             {"Debloquear"				,"U_PEDSITDBL()"	,0,8} ,; 
		             {"Forma PGTO"				,"U_PEDSITPG()"		,0,9} ,;
		             {"Legenda" 				,"U_PEDL()"			,0,10}}
                                                                        
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC1"

dbSelectArea("ZC1")
dbSetOrder(1) 

Private nCombo := 1

DEFINE MSDIALOG oDlg TITLE "Controle de Importa��o de Pedido de Venda" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
			    
	@ 025, 012 SAY oSay1 PROMPT "Data dos Pedidos:" SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
	//@ 025, 088 MSCOMBOBOX oCombo VAR nCombo ITEMS {"1=NF-e","2=CT-e","3=NFS-e","4=NTSC-e"} SIZE 076, 010 OF oDlg COLORS 0, 16777215 PIXEL //MSGET oSay2 VAR cCodPG SIZE 025, 010 OF oDlg COLORS 0, 16777215 F3 "SE4" PIXEL
	@ 025, 088 MSGET oSay2 VAR dDataI SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 150 BUTTON oButton1 PROMPT "&OK" SIZE 037, 012 ACTION (oDlg:End()) OF oDlg PIXEL  
	    
ACTIVATE MSDIALOG oDlg CENTERED  

cExprFilTop    := "ZC1_DATA = " + DTOS(dDataI)
                      
////////////////////////////////////////////////////////////////////////////////////////////////////
// Cria��o das cores para controle                                                                //
// BR_AMARELOBR_AZULBR_BRANCOBR_CINZZBR_LARANJABR_MARRONBR_VERDEBR_VERMELHOBR_PINKBR_PRETO		  //
////////////////////////////////////////////////////////////////////////////////////////////////////                                        

AADD(aCores,{"ZC1_STATUS == '1'" ,"BR_VERDE" 	}) //Pedido de Venda Importado para SC5 e SC6
AADD(aCores,{"ZC1_STATUS == '2'" ,"BR_AMARELO" 	}) //Pedido de Venda n�o processado
AADD(aCores,{"ZC1_STATUS == '3'" ,"BR_AZUL" 	}) //Cliente Localizado
//AADD(aCores,{"ZC1_STATUS == '4'" ,"BR_LARANJA" 	}) //Pedido de Venda com problema
AADD(aCores,{"ZC1_STATUS == '4'" ,"BR_VERMELHO"	}) //Pedido de Venda com ERRO


dbSelectArea(cString)

//mBrowse( 6,1,22,75,"ZC1",,,,,6,aCores,,,,,,,,)
MBrowse( 6,1,22,75,cString,,,,,6,aCores,,,,,,,,cExprFilTop)

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
   

User Function PEDL()

Local aLegenda := {}

//Montagem da legenda das ocorr�ncias da importa��o
AADD(aLegenda,{"BR_VERDE" 	,"Pedido de Venda Importado" 	})
AADD(aLegenda,{"BR_AMARELO"	,"Pedido de Venda Com Erro"		}) 
AADD(aLegenda,{"BR_AZUL"	,"Pedido de Venda Cliente"		})
AADD(aLegenda,{"BR_VERMELHO","PV Processado Protheus"		})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return           
       
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 

User Function fImporta()

Local lPrim   		:= .T.
Local aDados 		:= {}
Local aCampos 		:= {} 
Local _cArquivo 	:= ""
Private cLocal 		:= ""
Private cFileOpen 
private _aTitulos 	:= {}
private _aTitErro 	:= {}  
Private aCabec		:= {}
Private aTrailer 	:= {}
Private _aDet 
Private aItens		:= {}
       
PRIVATE lMSErroAuto := .f. 


  DEFINE MSDIALOG oDlg TITLE "Controle de Importa��o ContentStaff" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 039, 005 SAY oSay1 PROMPT "Arquivo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 037, 033 MSGET oGet1 VAR cLocal SIZE 170, 010 OF oDlg VALID (IIF(EMPTY(cLocal),.F.,.T.)) COLORS 0, 16777215 READONLY PIXEL
    @ 036, 210 BUTTON oButton1 PROMPT "&Buscar" SIZE 037, 012 ACTION ( cFileOpen := ALLTRIM(cGetFile('*.txt',,,,,GETF_NETWORKDRIVE+GETF_LOCALHARD)),cLocal := cFileOpen ) OF oDlg PIXEL
    @ 077, 210 BUTTON oButton2 PROMPT "&Importar" SIZE 037, 012 ACTION (oDlg:End(),	Processa( {|lEnd|  IMPORTA(cFileOpen)}, "Aguarde...","Efetuando leitura do arquivo...", .T. ) )  OF oDlg PIXEL
  
  ACTIVATE MSDIALOG oDlg CENTERED
  
Nmoviment := 1
Ntrans	  := 1							
cLINHA :=" "

Return(cFileOpen)

Static Function IMPORTA(cArquivo)

Local _cCodCli := "" 
Local aCabec  := {}  
Local aItens  := {}
Local aCliente:= {}
Local aFornece:= {}
Local nCont   := 0	
LOCAL nHdl:= nHdlA := 0
Local nX
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local lExiste := .T.
Local lHabil  := .F.
Private nHdl  := 0
Private cEOL  := "CHR(8)"
Private nItem	:= 0001
Private aCabec1	:= {}
Private aTrail	:= {}                          
Private cNumPed := ""

	
	If Empty(Alltrim(cArquivo))
		Alert("Nao existem arquivos para importar. Processo ABORTADO")
		Return.F.	
	EndIf

	//+---------------------------------------------------------------------+
	//| Abertura do arquivo texto                                           |
	//+---------------------------------------------------------------------+
	
	cArqTxt := cArquivo

	nHdl := fOpen(cArqTxt,0 )
	IF nHdl == -1
		IF FERROR()== 516
			ALERT("Feche o programa que gerou o arquivo.")
		EndIF
	EndIf
	
	//+---------------------------------------------------------------------+
	//| Verifica se foi poss�vel abrir o arquivo                            |
	//+---------------------------------------------------------------------+
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!" )
		Return
	Endif
	

	FSEEK(nHdl,0,0 )
	nTamArq:=FSEEK(nHdl,0,2 )
	FSEEK(nHdl,0,0 )
	fClose(nHdl)

	FT_FUse(cArquivo )  //abre o arquivo
	FT_FGoTop()         //posiciona na primeira linha do arquivo
   	nTamLinha := Len(FT_FREADLN() ) //Ve o tamanho da linha
	FT_FGOTOP()
	
	//+---------------------------------------------------------------------+
	//| Verifica quantas linhas tem o arquivo                               |
	//+---------------------------------------------------------------------+
	nLinhas := FT_FLastRec() 

	ProcRegua(nLinhas)

	While !FT_FEOF()
		IF nCont > nLinhas
			exit
		endif   
		IncProc("Lendo arquivo texto...Linha "+Alltrim(str(nCont)))
		cLinha := Alltrim(FT_FReadLn())
		nRecno := FT_FRecno() // Retorna a linha corrente

		If !empty(cLinha )
		
			If Substr(cLinha,1,1 ) == "1"
				
				aadd(aTrail, {Substr(cLinha,2,10 )})	
			
			Endif 
		
			If Substr(cLinha,1,1 )=="2"    
			
				aadd(aCabec,	{	Substr(cLinha,2,8	),;		//1Numero do Pedido
									Substr(cLinha,10,8	),; 	//2Codigo do Cliente
									Substr(cLinha,18,50	),; 	//3Nome do Cliente				
									Substr(cLinha,68,70	),; 	//4E-Mail do Cliente				
									Substr(cLinha,138,14),; 	//5CPF/CGC				
									Substr(cLinha,152,4 ),; 	//6DDD
									Substr(cLinha,156,8 ),; 	//7Telefone
									Substr(cLinha,165,4 ),; 	//8Ramal
									Substr(cLinha,168,4 ),; 	//9DDD Ceular
									Substr(cLinha,172,8 ),; 	//10Celular  
									Substr(cLinha,180,1 ),; 	//11Tipo de Cliente
									Substr(cLinha,181,1 ),; 	//12Sexo    
									Substr(cLinha,182,8 ),; 	//13CEP     
									Substr(cLinha,190,50),; 	//14Endere�o
									Substr(cLinha,240,10),; 	//15Numero  
									Substr(cLinha,250,50),; 	//16Complemento da Entrega
									Substr(cLinha,300,30),; 	//17Bairro  
									Substr(cLinha,330,30),; 	//18Cidade De Entrega
									Substr(cLinha,360,2 ),;		//19UF Entrega
									Substr(cLinha,362,1 ),; 	//20Forma de pagamento
									Substr(cLinha,363,5 ),; 	//21Quantidade de Parcelas
									Substr(cLinha,368,10 ),; 	//22Data do Pedido
									Substr(cLinha,378,10 ),; 	//23Valor do Pedido
									Substr(cLinha,388,15 ),; 	//24Modalidade de Entrega para msg NF-e
									Substr(cLinha,413,1  ),; 	//25Bandeira do Cartao   
									Substr(cLinha,471,10 ),; 	//26Data pamento do Pedido
									Substr(cLinha,481,10 ),; 	//27Valor Pago            
									Substr(cLinha,491,10 ),; 	//28Valor Boleto
									Substr(cLinha,501,12 ),; 	//29I.E/RG                 
									Substr(cLinha,403,10 )}) 	//30Valor do Frete         
									
			ElseIf Substr(cLinha,1,1 )=="3"
			
				aadd(aItens,{		Substr(cLinha,2,8 	),;		//1Numero do Pedido
						            Substr(cLinha,10,8	),;     //2Codigo do Produto ContentStaff
						            Substr(cLinha,18,15 	),;     //3Codigo do Produto Protheus
						            Substr(cLinha,33,50 	),;     //4Descri��o Produto ContentStaff
						            Substr(cLinha,83,5  	),;     //5Qauntidade do Item
						            Substr(cLinha,88,10 	),;     //6Valor de Venda do Produto
						            Substr(cLinha,98,10 	),;		//7Peso do Produto ContentStaff
						            nItem++})                  	//8Soma dos Item
						              
						            
			ElseIf Substr(cLinha,1,1 )=="5"
			
				aadd(aTrailer,{		Substr(cLinha,2,8 	),;		//1Numero do Pedido
						            Substr(cLinha,10,4	),;     //2Quantidade de Parcelas       
						            Substr(cLinha,14,10 ),;     //3Data do Vencimento        
						            Substr(cLinha,24,10 ),;     //4Data do Pagamento              
						            Substr(cLinha,34,10 ),;     //5Situa��o da Parcela
						            Substr(cLinha,45,4  ),;     //6Parcelas                 
						            Substr(cLinha,48,10 ),;     //7Valor da Parcela              
						            Substr(cLinha,58,10 )})     //8Valor da Pago   
										            
				//+---------------------------------------------------------------------+
				//| Grava dados do Pedido do Site ContentStaff gerado via TXT           |
				//+---------------------------------------------------------------------+
				
				ZC1->(DBSELECTAREA("ZC1"))
				ZC1->(DBSETORDER(1))
				
				ZC2->(DBSELECTAREA("ZC2"))
				ZC2->(DBSETORDER(1))
				
				//Begin Transaction		
                    
                	//ZC1_FILIAL+ZC1_PEDSIT+ZC1_IDCLIE
					If ! ZC1->(DBSEEK(xfilial("ZC1") + aCabec[1][1] + aCabec[1][2] ))  


						//+---------------------------------------------------------------------+
						//| Gera Pedido e Cadastra Cliente                                      |
						//+---------------------------------------------------------------------+
		               /*
						_cCodCli 	:= U_CADCLIS1(aCabec)
						If ! EMPTY(_cCodCli)
							cNumPed 	:= U_CADPEDS1(aCabec,aItens)
						EndIf
                        */
						Reclock(("ZC1"),.T.)
						
							ZC1->ZC1_FILIAL		:= xFilial("ZC1")
							ZC1->ZC1_STATUS 		:= "1"	
							ZC1->ZC1_DATA			:= STOD(SUBSTR(aTrail[1][1],7,4 ) + SUBSTR(aTrail[1][1],4,2 ) +SUBSTR(aTrail[1][1],1,2 ))
							ZC1->ZC1_PEDSIT		:= aCabec[1][1]				
							ZC1->ZC1_IDCLIE		:= aCabec[1][2]
							ZC1->ZC1_NOMES		:= aCabec[1][3] 
							ZC1->ZC1_EMAILS 		:= aCabec[1][4] 
							ZC1->ZC1_CGCS  		:= aCabec[1][5]
							ZC1->ZC1_DDD 			:= aCabec[1][6]  
							ZC1->ZC1_TELSIT		:= aCabec[1][7]
							ZC1->ZC1_RAMALS		:= aCabec[1][8]
							ZC1->ZC1_DDDCES		:= aCabec[1][9]
							ZC1->ZC1_CELSIT		:= aCabec[1][10]
							ZC1->ZC1_TIPOSI		:= aCabec[1][11]
							ZC1->ZC1_SEXOS		:= aCabec[1][12] 
							ZC1->ZC1_CEP			:= aCabec[1][13]   
							ZC1->ZC1_ENDSIT		:= aCabec[1][14]
							ZC1->ZC1_NUMSIT		:= aCabec[1][15]
							ZC1->ZC1_COMSIT		:= aCabec[1][16]
							ZC1->ZC1_BAIRSI		:= aCabec[1][17]
							ZC1->ZC1_CIDSIT		:= aCabec[1][18]
							ZC1->ZC1_ESTSIT		:= aCabec[1][19]
							ZC1->ZC1_FORMAS		:= aCabec[1][20]
							ZC1->ZC1_ZPARS		:= VAL(aCabec[1][21])
							ZC1->ZC1_DATAPS     	:= STOD(SUBSTR(aCabec[1][22],7,4 ) + SUBSTR(aCabec[1][22],4,2 ) + SUBSTR(aCabec[1][22],1,2 ))  //STOD(aCabec[1][22])
							ZC1->ZC1_VALORS    	:= VAL(aCabec[1][23])/100
							ZC1->ZC1_TFS       	:= aCabec[1][24]
							ZC1->ZC1_BANDCS		:= aCabec[1][25]
							ZC1->ZC1_DTPGTS		:= STOD(SUBSTR(aCabec[1][26],7,4 ) + SUBSTR(aCabec[1][26],4,2 ) +SUBSTR(aCabec[1][26],1,2 )) //STOD(aCabec[1][26])
							ZC1->ZC1_VALPGS		:= VAL(aCabec[1][27])/100
							ZC1->ZC1_VALBS 		:= VAL(aCabec[1][28])/100
							ZC1->ZC1_IERGS		:= aCabec[1][29]
							ZC1->ZC1_TOPS  		:= VAL(aTrailer[1][2])/100
							ZC1->ZC1_DTVESI		:= STOD(SUBSTR(aTrail[1][1],7,4 ) + SUBSTR(aTrail[1][1],4,2 ) +SUBSTR(aTrail[1][1],1,2 )) //STOD(aTrailer[1][3])
							ZC1->ZC1_SPS 			:= aTrailer[1][5]  
							ZC1->ZC1_PARCSI		:= VAL(aTrailer[1][6])/100
							ZC1->ZC1_VALPSI     	:= VAL(aTrailer[1][8])/100
							ZC1->ZC1_VALFRE		:= VAL(aCabec[1][30])/100

						 	//+---------------------------------------------------------------------+
							//| Entra na Rotina para Cadastrar Clientes                             |
							//+---------------------------------------------------------------------+
							
							ZC1->ZC1_CLIEPR := _cCodCli		 
							
						 	//+---------------------------------------------------------------------+
							//| Entra na Rotina para Gerar Pedido de Venda                          |
							//+---------------------------------------------------------------------+
							
							If ! EMPTY( cNumPed )			
								ZC1->ZC1_PEDIDO 	:= cNumPed
								ZC1->ZC1_STATUS 	:= IIF(EMPTY(ZC1->ZC1_PEDIDO),"1","2")
							Endif
						
						MSUnLock()
                    
					Endif
                   
						 For n := 1 To Len(aItens)
		    				If ! ZC2->(DBSEEK(xfilial("ZC2") + aItens[N][2] + STRZERO(aItens[N][8],4)))  	
			                
						   		Reclock(("ZC2"),.T.)
								
									ZC2->ZC2_FILIAL 		:= xFilial("ZC2")
									ZC2->ZC2_ITEM       	:= STRZERO(aItens[N][8],4)
									ZC2->ZC2_PEDSIT    	:= aItens[N][1]
									ZC2->ZC2_CODSIT		:= aItens[N][2]
									ZC2->ZC2_CODTSI		:= aItens[N][3]
									ZC2->ZC2_DESCS		:= aItens[N][4] 
									ZC2->ZC2_QTDESI		:= VAL(aItens[N][5])
									ZC2->ZC2_PRECOS		:= VAL(aItens[N][6])/100
									ZC2->ZC2_PESOS 		:= VAL(aItens[N][7])/1000
									          
								MSUnLock()
		                    
		                    Endif
                        Next n
                        

				//End Transaction 
				            
			 	//+---------------------------------------------------------------------+
				//| Zera os arrays para o novo pedido                                   |
				//+---------------------------------------------------------------------+
				
					aCabec 		:= {}
					aItens		:= {}
					aTrailer	:= {}
					nItem		:= 0 							                   
					
			Endif
		
		EndIf
		FT_FSKIP()  
		nCont++
	EndDo		
	FT_FUSE()
	fClose(nHdl )   
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADCLIS1(_cEnd,_cBairro,_cCep,_cEstado,_cMunip,_cCodMun,_cComplem)

Local aVetor := {}
                               
Private _cMail := "sandra@pini.com.br;priscilarodrigues@pini.com.br;douglas@rvacari.com.br"
Private cNumCod := GETSX8NUM("SA1","A1_COD")
Private _cCPFCGC
Private lMsErroAuto := .F.  
Private _cFP	:= ""
Private _cBloq	:= "1"


	//+---------------------------------------------------------------------+
	//| Verifica status atual do pedido de venda                            |
	//+---------------------------------------------------------------------+
	    
    If ZC1->ZC1_STATUS == "2"
    	Alert("Pedido de Venda Bloqueado!")
		Return
	EndIf


//��������������������������������������������������������������Ŀ
//| Abertura do ambiente                                         |
//����������������������������������������������������������������

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SA1"
                                                                           
SA1->(DBSELECTAREA("SA1"))
SA1->(DBSETORDER(3)) 

_cCPFCGC := IIF(ZC1->ZC1_TIPOSI = "2", ZC1->ZC1_CGCS,SUBSTR(ZC1->ZC1_CGCS,4,11))

If VAL(_cCPFCGC) == 0
	Alert("Verificar CPF do Cliente " + ZC1->ZC1_PEDSIT)
	Return
EndIf

	If ! SA1->(DBSEEK(xFilial("SA1") + _cCPFCGC ))
	
		SZ0->(DBSELECTAREA("SZ0"))
		SZ0->(DBSETORDER(1))
             
	 	//+---------------------------------------------------------------------+
		//| Verifica se CEP existe na base dos Correios (SZ0)                   |
		//+---------------------------------------------------------------------+
'
		If ! SZ0->(DBSEEK(xFilial("SZ0") + ZC1->ZC1_CEP ))  
			If MSGYESNO("CEP do Cliente " +  SUBSTR(ZC1->ZC1_CEP,1,5) + "-" + SUBSTR(ZC1->ZC1_CEP,6,3)  + " n�o localizado na tabela dos correios, deseja continuar?")
				MsgAlert("Cliente bloqueado favor revisar as informa��es do mesmo!")
				_cBloq := "2"
			Else
				Return
			EndIf
		EndIf		


	 	//+---------------------------------------------------------------------+
		//| Verifica se encontra o codigo do munincipio IBGE (SZ0)              |
		//+---------------------------------------------------------------------+
'                                                                 
		CC2->(DBSELECTAREA("CC2"))
		CC2->(DBSETORDER(1))
		If ! CC2->(DBSEEK(xFilial("CC2") + _cEstado + _cCodMun ))  
			MsgAlert("Codigo de Munincipio : " + _cCodMun + " N�o localizado, favor verificar a tela de Endere�o!")
			Return
		EndIf		

		 	//+---------------------------------------------------------------------+
			//| Preenche vetor com dados do Cliente                                 |
			//+---------------------------------------------------------------------+
			ConfirmSX8()
           //_cEnd,_cBairro,_cCep,_cEstado,_cMunip,_cCodMun,_cComplem
			aVetor:={	{"A1_COD"       	,cNumCod		       	,Nil},; // Codigo				 
						{"A1_LOJA"      	,"01"               	,Nil},; // Loja				 
						{"A1_NOME"      	,ZC1->ZC1_NOMES 	  	,Nil},; // Nome				 
						{"A1_NREDUZ"    	,ALLTRIM(ZC1->ZC1_NOMES ),Nil},; // Nome reduz.				 
						{"A1_TIPO"      	,"F"					,Nil},; // Tipo				 
						{"A1_END"       	,_cEnd					,Nil},; // Endereco				 
 						{"A1_MUN"       	,_cMunip				,Nil},; // Munincipio					 
						{"A1_PESSOA"    	,IIF(LEN(_cCPFCGC) == 11, "F", "J")		,Nil},; // Tipo do Cliente
						{"A1_CGC"    		,_cCPFCGC				,Nil},; // CGC
						{"A1_BAIRRO"   		,_cBairro				,Nil},; // Bairro
						{"A1_CEP"   		,_cCep			   		,Nil},; // Cep
						{"A1_DDD"   		,ZC1->ZC1_DDD   		,Nil},; // DDD								
						{"A1_TEL"   		,ZC1->ZC1_TELSIT+"/"+ZC1->ZC1_CELSIT		,Nil},; // Telefone
						{"A1_PAIS"   		,"1058"					,Nil},; // Pais
						{"A1_CODPAIS"  		,"01058"					,Nil},; // Pais						
						{"A1_INSCR"   		,ZC1->ZC1_IERGS 		,Nil},; // Incri��o Estadual
						{"A1_EMAIL"   		,ZC1->ZC1_EMAILS		,Nil},; // Email
						{"A1_COMPLEM"   	,_cComplem				,Nil},; // Complemento
						{"A1_EST"       	,_cEstado				,Nil},; // Estado
  						{"A1_COND"      	,"201"					,Nil},; // Codi��o de Pagamento
						{"A1_NATUREZ"   	,"0108      "			,Nil},; // Estado
						{"A1_FLAGGID"   	,"2"					,Nil},; // Estado
						{"A1_ATIVIDA"  		,"9999004"				,Nil},; // Estado
						{"A1_TPCLI"   		,"F"					,Nil},; // Estado						
						{"A1_CLASSE"   		,"A"					,Nil},; // Estado												
						{"A1_RISCO"   		,"A"					,Nil},; // Estado						
						{"A1_TPCLI"   		,"F"					,Nil},; // Estado						
						{"A1_SATIV1"   		,"1"					,Nil},; // Estado						
  						{"A1_SATIV2"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV3"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV4"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV5"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV6"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV7"   		,"1"					,Nil},; // Estado						
						{"A1_SATIV8"   		,"1"					,Nil},; // Estado						
						{"A1_COD_MUN"  		,_cCodMun				,Nil},; // Estado						
						{"A1_RECISS"   		,"2"					,Nil},; // Estado						
						{"A1_TPLOG"   		,SZO->ZO_TPLOG			,Nil},; // Estado						
						{"A1_LOGR"   		,ALLTRIM(_cEnd)			,Nil},; // Estado						
						{"A1_NLOGR"   		,ZC1->ZC1_NUMSIT		,Nil},; // Estado						
						{"A1_COMPL"   		,_cComplem				,Nil},; // Estado						
						{"A1_TPASS"   		,"1"					,Nil},; // Estado
						{"A1_TPUTI"   		,"6"					,Nil},; // Estado
						{"A1_GRPTEN"   		,"00"					,Nil},; // Estado  
						{"A1_FLAGID"   		,"2"					,Nil},; // Estado  A1_FLAGID 
						{"A1_COD_MUN"   	,_cCodMun				,Nil},; // Codigo do Munincipio
						{"A1_MSBLQL"		,_cBloq					,Nil}} // Bloquei do Cliente
				
						MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclus�o, 4- Altera��o, 5- Exclus�o 
						                                     
						//+---------------------------------------------------------------------+
						//| Se houve erro na gra��o do novo cliente � mostrado na tela          |
						//+---------------------------------------------------------------------+
												
						If lMsErroAuto	
							MostraErro()
							cNumCod := ""
						Else   
							//U_MailNotify(_cMail,,"IMPORTA��O PEDIDO DE VENDA EDITORA PINI CADASTRO DE CLIENTE ",{"CEP DIFERENTE DA BASE PROTHEUS X PEDIDO TXT " + Time() + " --- " + Memoread( "Cliente: " + SA1->A1_COD + " CEP TXT " + SUBSTR(aCabec[1][13],1,5) + "-" + SUBSTR(aCabec[1][13],6,3) + " CEP PROTHEUS " + SUBSTR(SA1->A1_CEP,1,5) + "-" + SUBSTR(SA1->A1_CEP,6,3)  ) },,.F.)
						Endif

	Else
	
		If ! SA1->A1_CEP == ZC1->ZC1_CEP
			If MSGYESNO("CEP do Cliente Codigo " + SA1->A1_COD + " Loja " + SA1->A1_LOJA + " CEP: " + SUBSTR(SA1->A1_CEP,1,5) + "-" + SUBSTR(SA1->A1_CEP,6,3) + " diferente do Arquivo TXT: " + SUBSTR(ZC1->ZC1_CEP,1,5) + "-" + SUBSTR(ZC1->ZC1_CEP,6,3)  + " , deseja continuar?")
				//MsgAlert("Cliente bloqueado favor revisar as informa��es do mesmo!")
				//_cBloq := "2"  
			
				U_PEDSITALT(lResp,_cEnd,_cBairro,_cCep,_cEstado,_cMunip,_cCodMun,_cComplem)  
				
				If lResp
					RECLOCK("SA1",.F.)
	
						SA1->A1_END	 	:= _cEnd	
						SA1->A1_BAIRRO	:= _cBairro
						SA1->A1_CEP 	:= _cCep
						SA1->A1_EST		:= _cEstado
						SA1->A1_MUN 	:= _cMunip
						SA1->A1_COD_MUN	:= _cCodMun
						SA1->A1_COMPL	:= _cComplem  
						SA1->A1_LOGR	:= _cEnd 
						SA1->A1_NLOGR	:= ALLTRIM(ZC1->ZC1_NUMSIT) 
									
					SA1->(MSUNLOCK())        
				EndIf 
				cNumCod := SA1->A1_COD + SA1->A1_LOJA   
				
			Else
				Return
			EndIf			
			_cBloq := "2"
		Else
			                                     
			MsgInfo("Cliente Localizado, status: " + IIF(SA1->A1_MSBLQL == "1", " Bloqueado, favor conferir o cadastro! " , " Debloqueado!"))
			cNumCod := SA1->A1_COD + SA1->A1_LOJA   			
		EndIf
		
	EndIf
	
	RECLOCK("ZC1",.F.)
			ZC1->ZC1_CLIEPR := IIF(EMPTY(cNumCod),cNumCod,(IIF(LEN(cNumCod) = 6, cNumCod + "01", cNumCod)) )
			ZC1->ZC1_STATUS := "3"
	ZC1->(MSUNLOCK())  
	    
Return( )
                                                                                      
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADPEDS1()

Local cNumPed 
Local aItens2 := {}  

Private cObs      := space(40)
Private cPagto    := "201"
Private c1Comis   := space(06)
Private c2Comis   := space(06)
Private cTipoOper := space(03)
Private nDias := 30 
Private nItem	:= 1 
Private dDataLote := ddatabase 
Private _nSomaI	:= 0
Private _nQtdeI	:= 0         
Private _nTotalD := 0 
Private _nDescP := 0
                               
	//+---------------------------------------------------------------------+
	//| Verifica status atual do pedido de venda                            |
	//+---------------------------------------------------------------------+
	    
    If ZC1->ZC1_STATUS == "2" 
    	Alert("Pedido de Venda Bloqueado!")
		Return
	EndIf


	//+---------------------------------------------------------------------+
	//| Verifica se codigo do cliente est� preenchido						|
	//+---------------------------------------------------------------------+	 

	If ! EMPTY(ZC1->ZC1_CLIEPR)
	                                                     
		If EMPTY(ZC1->ZC1_PEDIDO)
		
			//+---------------------------------------------------------------------+
			//| Query para verificar se j� existe o pedido nas tabelas SC5 OU SC6   |
			//+---------------------------------------------------------------------+	 
		     	
		 	cQuery := "SELECT SC5.C5_NUM "
			cQuery += "FROM "+RETSQLNAME("SC5")+" SC5 "
			cQuery += "WHERE SC5.D_E_L_E_T_ != '*' "
			cQuery += "AND SC5.C5_FILIAL = '01' "
			cQuery += "AND SC5.C5_NUMEXT = '"+ZC1->ZC1_PEDSIT+"' "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRB",.F.,.T.)    
			
			If EMPTY(TRB->C5_NUM)
				//cNumPed := SC5->C5_NUM
				cNumPed := GETSXENUM("SC5","C5_NUM")
				TRB->(DBCLOSEAREA("TRB"))
			Else   
			
				//+---------------------------------------------------------------------+
				//| Verifica se pedido j� est� no protheus                              |
				//+---------------------------------------------------------------------+	 
				
				MsgInfo("Pedido Site localizado na base Protheus, Pedido Site:  " + ZC1->ZC1_PEDSIT + " Pedido Protheus: " + TRB->C5_NUM) 
				
				RECLOCK("ZC1",.F.)
					ZC1->ZC1_PEDIDO := TRB->C5_NUM 
					ZC1->ZC1_STATUS := "4"
				ZC1->(MSUNLOCK())  
			      
			    TRB->(DBCLOSEAREA("TRB"))
				Return          
					
			EndIf
		Else
			MsgInfo("Pedido de Venda Site j� esta no Protheus: " + ZC1->ZC1_PEDIDO)
			
			RECLOCK("ZC1",.F.)
				ZC1->ZC1_STATUS := "4"
			ZC1->(MSUNLOCK())  
		
			Return
		EndIf	
	Else
		
		MsgAlert("Cliente n�o vinculado ao pedido de venda site, execute primeiro a integra��o cliente x pedido site!") 
		Return
	
	Endif
		
		//+---------------------------------------------------------------------+
		//| Cria as Formas de Pagamento + Bandeira de Pagamento                 |
		//+---------------------------------------------------------------------+	 
		
		If ZC1->ZC1_FORMAS == "1"
			_cFP := "C" + ZC1->ZC1_BANDCS
		ElseIf ZC1->ZC1_FORMAS == "2" 		      
			_cFP := "DB"
		ElseIf ZC1->ZC1_FORMAS == "3" 		      
			_cFP := "BO"
		EndIf		
		
		//+---------------------------------------------------------------------+
		//| Busca Cliente                                                       |
		//+---------------------------------------------------------------------+
		
		dbselectarea("SA1")
		dbsetorder(3)
		
		_cCPFCGC := IIF(ZC1->ZC1_TIPOSI = "2", ZC1->ZC1_CGCS,SUBSTR(ZC1->ZC1_CGCS,4,11))

		If ! SA1->(DBSEEK(xFilial("SA1") + _cCPFCGC ))
			MsgAlert("Cliente n�o localizado!")
			Return
		Endif         
		
		dbselectarea("SC5")
		dbsetorder(1)

		//+---------------------------------------------------------------------+
		//| Busta detalhes do Pedido                                            |
		//+---------------------------------------------------------------------+	 		
		                               
		cQuery := " SELECT * FROM "+RETSQLNAME("ZC2")+" ZC2 "
		cQuery += " JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.D_E_L_E_T_ != '*' AND SB1.B1_COD = ZC2.ZC2_CODTSI "
		cQuery += " WHERE ZC2.D_E_L_E_T_ != '*' AND ZC2.ZC2_PEDSIT = '"+ZC1->ZC1_PEDSIT+"' "
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TC2",.F.,.T.)
		
		If EMPTY(TC2->ZC2_PEDSIT)
			MsgAlert("Pedido de venda com problema, n�o encontrado detalhe do pedido: " + ZC1->ZC1_PEDSIT) 
			RECLOCK("ZC1",.F.)
				ZC1->ZC1_STATUS := "2"
			ZC1->(MSUNLOCK())
			TZ2->(DBCLOSEAREA("TC2"))  
			Return                     
		Else
		
			Do While TC2->(!EOF())
			    
				If ! TC2->B1_TIPO $ "LI|LC|LD|CD|RE" 
				
					MsgAlert("Produto " + TC2->B1_COD + " Decri��o : " + TC2->B1_DESC + " N�o Pertecem a Livros!")
					RECLOCK("ZC1",.F.)
						ZC1->ZC1_STATUS := "2"
					ZC1->(MSUNLOCK())
					TZ2->(DBCLOSEAREA("TC2"))
															
					Return		
				Else
					_nSomaI += (TC2->ZC2_PRECOS * TC2->ZC2_QTDESI)
					_nQtdeI += TC2->ZC2_QTDESI

				EndIf	
				
			TC2->(DBSKIP())
			Enddo
			
		EndIf

		//+---------------------------------------------------------------------+
		//| Buscando data do ultimo lote                                        |
		//+---------------------------------------------------------------------+	 		
		
		cQuery := " SELECT  MAX(Z6_DATA) AS Z6_DATA FROM "+RETSQLNAME("SZ6")+" SZ6 WHERE D_E_L_E_T_ != '*'  AND Z6_LOTEFAT = '001' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRD",.F.,.T.)
		
		TCSETFIELD("TRD","Z6_DATA","D",08,0)                                               
		
		dDataLote := TRD->Z6_DATA 
		
		TRD->(DBCLOSEAREA("TRD"))
		
		//+---------------------------------------------------------------------+
		//| Verifica se j� Existe Pedido de Venda                               |
		//+---------------------------------------------------------------------+	 		
		
		Begin Transaction		                                                
							
		If ! SC5->(DBSEEK(xFilial("SC5") + cNumPed )) 
				
				RECLOCK("SC5",.T.)
					SC5->C5_FILIAL	:= xFilial("SC5")
					SC5->C5_NUM		:= UPPER(cNumPed)
					SC5->C5_TIPO	:= "N"
					SC5->C5_DIVVEN	:= "MERC"
					SC5->C5_CODPROM	:= "N"
					SC5->C5_IDENTIF	:= "."
					SC5->C5_CLIENTE	:= SA1->A1_COD
					SC5->C5_LOJACLI	:= SA1->A1_LOJA
					SC5->C5_LOJAENT := SA1->A1_LOJA
					SC5->C5_TIPOCLI	:= "F"
					SC5->C5_CONDPAG	:= cPagto
					SC5->C5_LOTEFAT	:= "001"
					SC5->C5_DATA	:= dDataLote
					SC5->C5_EMISSAO	:= ddatabase
					SC5->C5_VEND1	:= "000101"
					SC5->C5_VLRPED	:= ZC1->ZC1_VALORS - ZC1->ZC1_VALFRE 
					SC5->C5_VEND4	:= c2Comis
					SC5->C5_DTCALC	:= ddatabase
					SC5->C5_AVESP	:= "N"
					SC5->C5_TPTRANS	:= "99" 
					SC5->C5_DESPREM	:= ZC1->ZC1_VALFRE
					SC5->C5_MENNOTA	:= ZC1->ZC1_TFS   
					SC5->C5_NUMEXT	:= ZC1->ZC1_PEDSIT
					SC5->C5_TXMOEDA	:= 1
					SC5->C5_TPCARGA	:= "2" 
					SC5->C5_CLIENT	:= SA1->A1_COD
					SC5->C5_GERAWMS	:= "1"
					SC5->C5_SOLOPC	:= "1"
					SC5->C5_TRANSP	:= "000010"
					SC5->C5_MOEDA	:= 1
					//SC5->C5_VOLUME1	:= //Len(aItens1)
					SC5->C5_TIPLIB	:= "1"
					SC5->C5_TPFRETE	:= "F"    
					SC5->C5_ESPECI1	:= "CAIXA"
					SC5->C5_USUARIO	:= ALLTRIM(cUserName)
					
					//+---------------------------------------------------------------------+
					//| Gera as Inform�a�es de Pagamento                                    |
					//+---------------------------------------------------------------------+	 
					
					SC5->C5_DTCALC	:= ddatabase 
					SC5->C5_TIPOOP	:= U_PEDSITPG()�
				   

					If ZC1->ZC1_ZPARS = 0   	                                 
						SC5->C5_PARC1	:= ZC1->ZC1_VALORS / 1
						SC5->C5_DATA1	:= ddatabase
					EndIf

					If ZC1->ZC1_ZPARS >= 1   	                                 
						SC5->C5_PARC1	:= ZC1->ZC1_VALORS / ZC1->ZC1_ZPARS
						SC5->C5_DATA1	:= ddatabase
					EndIf
					
					If ZC1->ZC1_ZPARS >= 2
						SC5->C5_PARC2	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS 
						SC5->C5_DATA2	:= ddatabase	+ nDias                  
					EndIf
					
					If ZC1->ZC1_ZPARS >= 3
						SC5->C5_PARC3	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS 
						SC5->C5_DATA3	:= ddatabase	+ (nDias * 3)                  
					EndIf               
					
					If ZC1->ZC1_ZPARS >= 4
						SC5->C5_PARC4	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS 
						SC5->C5_DATA4	:= ddatabase + (nDias * 4)                  
					EndIf               

					If ZC1->ZC1_ZPARS >= 5
						SC5->C5_PARC5	:= ZC1->ZC1_VALORS / ZC1->ZC1_ZPARS 
						SC5->C5_DATA5	:= ddatabase + (nDias * 5)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 6
						SC5->C5_PARC6	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA6	:= ddatabase + (nDias * 6)                  
					EndIf
					
					If ZC1->ZC1_ZPARS >= 7
						SC5->C5_PARC7	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA7	:= ddatabase + (nDias * 7)                  
					EndIf


					If ZC1->ZC1_ZPARS >= 8
						SC5->C5_PARC8	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA8	:= ddatabase + (nDias * 8)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 9
						SC5->C5_PARC9	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA9	:= ddatabase + (nDias * 9)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 10
						SC5->C5_PARC10	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA10	:= ddatabase + (nDias * 10)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 11
						SC5->C5_PARC11	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA11	:= ddatabase + (nDias * 11)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 12
						SC5->C5_PARC12	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA12	:= ddatabase + (nDias * 12)                  
					EndIf

					If ZC1->ZC1_ZPARS >= 13
						SC5->C5_PARC13	:= ZC1->ZC1_VALORS  / ZC1->ZC1_ZPARS
						SC5->C5_DATA13	:= ddatabase + (nDias * 13)                  
					EndIf

							
				SC5->(MSUNLOCK())
            
			//+---------------------------------------------------------------------+
			//| Leitura do Array com produtos vindos do TXTs                        |
			//+---------------------------------------------------------------------+
			
			///For n := 1 To len(aItens1)
			TC2->(DBGOTOP())
			Do While TC2->(!EOF())
			
				SB1->(DBSELECTAREA("SB1"))
				SB1->(DBSETORDER(1))
				
				If SB1->(DBSEEK(xFilial("SB1") + TC2->ZC2_CODTSI ))
				
					SF4->(DBSELECTAREA("SF4"))
					SF4->(DBSETORDER(1))
					
					If SF4->(DBSEEK(xFilial("SF4") + SB1->B1_TS ))
					 
						If (_nSomaI + ZC1->ZC1_VALFRE) == ZC1->ZC1_VALORS 
							_nTotalD := 0
						Else 
							_nTotalD := (_nSomaI - (ZC1->ZC1_VALORS - ZC1->ZC1_VALFRE)) / _nQtdeI
						EndIf
												
						RECLOCK("SC6",.T.)
							SC6->C6_FILIAL	:= xFilial("SC6")
						 	SC6->C6_ITEM    := STRZERO(nItem,2)
						    SC6->C6_PRODUTO	:= SB1->B1_COD
							SC6->C6_LOCAL   := SB1->B1_LOCPAD 
							SC6->C6_DESCRI	:= SB1->B1_DESC
							SC6->C6_TES		:= SB1->B1_TS            
							SC6->C6_CF      := IIF(ZC1->ZC1_ESTSIT != "SP", "6" + SUBSTR(SF4->F4_CF,2,4), SF4->F4_CF)
							SC6->C6_QTDVEN	:= TC2->ZC2_QTDESI
							SC6->C6_PRCVEN	:= TC2->ZC2_PRECOS - (_nTotalD * TC2->ZC2_QTDESI) 
							SC6->C6_PRUNIT	:= TC2->ZC2_PRECOS - (_nTotalD * TC2->ZC2_QTDESI) 
							SC6->C6_VALOR	:= TC2->ZC2_PRECOS * TC2->ZC2_QTDESI - (_nTotalD * TC2->ZC2_QTDESI)
							SC6->C6_DATA	:= dDataLote
							SC6->C6_CLI		:= SA1->A1_COD
							SC6->C6_LOJA	:= SA1->A1_LOJA
							SC6->C6_NUM		:= UPPER(cNumPed)
							SC6->C6_TPOP	:= "F"
							SC6->C6_TIPOREV := "0"
							SC6->C6_EDINIC  := 9999
							SC6->C6_EDFIN   := 9999
							SC6->C6_EDVENC  := 9999
							SC6->C6_EDSUSP  := 9999
							SC6->C6_REGCOT  := '99'+space(13)
							SC6->C6_TPPROG  := 'N'
							SC6->C6_SITUAC  := 'AA'                                                        
					        SC6->C6_CLASFIS := CodSitTri() //SUBSTR(SF4->F4_SITTRIB,2,2)
					        SC6->C6_COMIS1 	:= (TC2->ZC2_PRECOS * 1 ) / 100   
					        SC6->C6_RATEIO	:= "2"
					        SC6->C6_EDSUSP	:= 0
					        SC6->C6_TPPORTE	:= "0"
					        SC6->C6_SUGENTR	:= ddatabase
					        SC6->C6_COMIS4	:= 2
					        SC6->C6_UM		:= SB1->B1_UM
					        SC6->C6_LOTEFAT	:= "001"
					        SC6->C6_COMIS5	:= 1
					        SC6->C6_VALDESC	:= _nTotalD * TC2->ZC2_QTDESI
					        
					        _nDescP := ROUND( ((_nTotalD * TC2->ZC2_QTDESI / TC2->ZC2_PRECOS ) * 100),2)
					        If _nDescP > 99.99
					        	SC6->C6_DESCONT	:= 99.99
					        Else
					        	SC6->C6_DESCONT	:= _nDescP
					        EndIf
					        
						SC6->(MSUNLOCK())
					
					Else
					   
						//+---------------------------------------------------------------------+
						//| Caso o produto n�o tenha TES ou n�o est� valida na SF4              |
						//+---------------------------------------------------------------------+
			
						Alert("Verifique a TES do Produto: " + SB1->B1_COD)
						
						Return    
					
					EndIf    
				
				Else

					//+---------------------------------------------------------------------+
					//| Caso o produto n�o esteja Cadastrado                                |
					//+---------------------------------------------------------------------+

					Alert("Produto n�o cadastrado Pedido Site: " + ALLTRIM(ZC1->ZC1_PEDSIT) + " " + ALLTRIM(TC2->ZC2_CODTSI) + " " + " Descri��o " + " " + ALLTRIM(TC2->ZC2_DESCS) )
					
					Return
							
				EndIf
			
			nItem++
				
			TC2->(dbskip())
			Enddo

		Else
		
			//+---------------------------------------------------------------------+
			//| Se houver o pedido retorna o numero preenchendo a variavel          |
			//+---------------------------------------------------------------------+
	
			MsgAlert("Numera��o do pedido de venda com erro: " + UPPER(cNumPed))
		 	Return
		EndIf


		//+---------------------------------------------------------------------+
		//| Pedido de Venda Protheus Cadastrado Com Sucesso!          |
		//+---------------------------------------------------------------------+
		
		ConfirmSX8()		 
		End Transaction		
		MsgInfo("Pedido de Venda Protheus Cadastrado Com Sucesso:  " + ZC1->ZC1_PEDSIT + " Pedido Protheus: " + UPPER(cNumPed)) 
		
		RECLOCK("ZC1",.F.)
			ZC1->ZC1_PEDIDO := UPPER(cNumPed)
			ZC1->ZC1_STATUS := "4"
		ZC1->(MSUNLOCK())  
		                            
		TC2->(DBCLOSEAREA("TC2"))
				
Return()   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PEDSITTEL()

Static oDlg
Static oGet1
Static oGet2
Static oGet3
Static oGet4
Static oGet5
Static oGet6
Static oGroup1
Static oSay1
Static oSay2
Static oSay3
Static oSay4
Static oSay5
Static oSay6
Static oSay7
Static oSay8  

Private _cCodigo 	:= ALLTRIM(ZC1->ZC1_CLIEPR)
Private _cNome		:= ALLTRIM(ZC1->ZC1_NOMES)
Private _cEnd		:= ALLTRIM(ZC1->ZC1_ENDSIT) + " " + ALLTRIM(ZC1->ZC1_NUMSIT)
Private	_cBairro	:= ALLTRIM(ZC1->ZC1_BAIRSI)
Private _cMunip		:= ALLTRIM(ZC1->ZC1_CIDSIT)
Private _cEstado	:= ALLTRIM(ZC1->ZC1_ESTSIT)
Private _cCep		:= ZC1->ZC1_CEP
Private _cComplem	:= ALLTRIM(ZC1->ZC1_COMSIT)  
Private _cCodMun	
Private lResp := .F. 

cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE D_E_L_E_T_ != '*' AND CC2_EST = '"+_cEstado+"' AND (TRANSLATE((UPPER(CC2_MUN)),'��������������������������','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%"+_cMunip+"%' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRB",.F.,.T.) 

If ! EMPTY(TRB->CC2_CODMUN)
	_cCodMun	:= TRB->CC2_CODMUN  
Else
	_cCodMun 	:= SPACE(6)
EndIf

TRB->(DBCLOSEAREA("TRB"))


If ! SZ0->(DBSEEK(xFilial("SZ0") + ZC1->ZC1_CEP ))  
	MsgAlert("CEP do Cliente " +  SUBSTR(ZC1->ZC1_CEP,1,5) + "-" + SUBSTR(ZC1->ZC1_CEP,6,3)  + " n�o localizado na tabela dos correios, deseja continuar?")
EndIf		

	DEFINE MSDIALOG oDlg TITLE "Endere�o Cliente/Entrega" FROM 000, 000  TO 245, 600 COLORS 0, 16777215 PIXEL
	
    @ 003, 002 GROUP oGroup1 TO 120, 300 PROMPT OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 013, 007 SAY oSay7 PROMPT "C�digo" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 115 SAY oSay8 PROMPT "Nome" 			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 030, 007 SAY oSay1 PROMPT "Rua/Av"	 	SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 007 SAY oSay2 PROMPT "Bairro" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 008 SAY oSay3 PROMPT "CEP" 			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 073, 007 SAY oSay4 PROMPT "Municipio" 	SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 073, 115 SAY oSay5 PROMPT "Codigo M" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 115 SAY oSay6 PROMPT "Estado" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 088, 007 SAY oSay9 PROMPT "Comp"		 	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
	@ 012, 040 MSGET oGet1 VAR _cCodigo 	SIZE 063, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 012, 140 MSGET oGet1 VAR _cNome 		SIZE 149, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
    @ 028, 040 MSGET oGet1 VAR _cEnd 		SIZE 249, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 043, 040 MSGET oGet2 VAR _cBairro 	SIZE 137, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 057, 040 MSGET oGet3 VAR _cCep 		SIZE 069, 010 OF oDlg  PICTURE "@R 99999-999" COLORS 0, 16777215 PIXEL
    @ 057, 140 MSGET oGet4 VAR _cEstado 	SIZE 035, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 072, 040 MSGET oGet5 VAR _cMunip 		SIZE 069, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 072, 140 MSGET oGet6 VAR _cCodMun		SIZE 035, 010 OF oDlg VALID (IIF(EMPTY(_cCodMun),.F.,.T.)) COLORS 0, 16777215 F3 "CCSZC1" PIXEL
    @ 088, 040 MSGET oGet7 VAR _cComplem 	SIZE 249, 010 OF oDlg COLORS 0, 16777215 PIXEL   
    
    @ 104, 252 BUTTON oButton1 PROMPT "&Confirmar" ACTION (oDlg:End(), lResp := .T.) SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED
                                   
If lResp
	If EMPTY(ZC1->ZC1_CLIEPR)
		Processa( {|lEnd| U_CADCLIS1(_cEnd,_cBairro,_cCep,_cEstado,_cMunip,_cCodMun,_cComplem)}, "Aguarde...","Gravando dados Cliente...", .T. ) 
	EndIf
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PEDSITALT()

Static oDlg
Static oGet1
Static oGet2
Static oGet3
Static oGet4
Static oGet5
Static oGet6
Static oGroup1
Static oSay1
Static oSay2
Static oSay3
Static oSay4
Static oSay5
Static oSay6
Static oSay7
Static oSay8  

Private _cCodigo 	:= ALLTRIM(ZC1->ZC1_CLIEPR)
Private _cNome		:= ALLTRIM(ZC1->ZC1_NOMES)
Private _cEnd		:= ALLTRIM(ZC1->ZC1_ENDSIT) + " " + ALLTRIM(ZC1->ZC1_NUMSIT)
Private	_cBairro	:= ALLTRIM(ZC1->ZC1_BAIRSI)
Private _cMunip		:= ALLTRIM(ZC1->ZC1_CIDSIT)
Private _cEstado	:= ALLTRIM(ZC1->ZC1_ESTSIT)
Private _cCep		:= ZC1->ZC1_CEP
Private _cComplem	:= ALLTRIM(ZC1->ZC1_COMSIT)  
Private _cCodMun	
Private lResp := .F.   

cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE D_E_L_E_T_ != '*' AND CC2_EST = '"+_cEstado+"' AND (TRANSLATE((UPPER(CC2_MUN)),'��������������������������','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%"+_cMunip+"%'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRB",.F.,.T.) 

If ! EMPTY(TRB->CC2_CODMUN)
	_cCodMun	:= TRB->CC2_CODMUN
Else
	_cCodMun 	:= SPACE(6)
EndIf

TRB->(DBCLOSEAREA("TRB"))
                    
SA1->(DBSELECTAREA("SA1"))
SA1->(DBSETORDER(3)) 

_cCPFCGC := IIF(ZC1->ZC1_TIPOSI = "J", ZC1->ZC1_CGCS,SUBSTR(ZC1->ZC1_CGCS,4,11))

If VAL(_cCPFCGC) == 0
	Alert("Verificar CPF do Cliente " + ZC1->ZC1_PEDSIT)
	Return
EndIf

If ! SZ0->(DBSEEK(xFilial("SZ0") + ZC1->ZC1_CEP ))  
	MsgAlert("CEP do Cliente " +  SUBSTR(ZC1->ZC1_CEP,1,5) + "-" + SUBSTR(ZC1->ZC1_CEP,6,3)  + " n�o localizado na tabela dos correios, deseja continuar?")
EndIf  


If SA1->(DBSEEK(xFilial("SA1") + _cCPFCGC ))		

  DEFINE MSDIALOG oDlg TITLE "Alterar Endere�o Cliente/Entrega" FROM 000, 000  TO 470, 600 COLORS 0, 16777215 PIXEL

    @ 003, 002 GROUP oGroup1 TO 120, 300 PROMPT "ContentStuff"  OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 013, 007 SAY oSay7 PROMPT "C�digo" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 115 SAY oSay8 PROMPT "Nome" 			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 030, 007 SAY oSay1 PROMPT "Rua/Av"	 	SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 007 SAY oSay2 PROMPT "Bairro" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 008 SAY oSay3 PROMPT "CEP" 			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 073, 007 SAY oSay4 PROMPT "Municipio" 	SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 073, 115 SAY oSay5 PROMPT "Codigo M" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 115 SAY oSay6 PROMPT "Estado" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 088, 007 SAY oSay9 PROMPT "Comp"		 	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
	@ 012, 040 MSGET oGet1 VAR _cCodigo 	SIZE 063, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 012, 140 MSGET oGet1 VAR _cNome 		SIZE 149, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
    @ 028, 040 MSGET oGet1 VAR _cEnd 		SIZE 249, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 043, 040 MSGET oGet2 VAR _cBairro 	SIZE 137, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 057, 040 MSGET oGet3 VAR _cCep 		SIZE 069, 010 OF oDlg  PICTURE "@R 99999-999" COLORS 0, 16777215 PIXEL
    @ 057, 140 MSGET oGet4 VAR _cEstado 	SIZE 035, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 072, 040 MSGET oGet5 VAR _cMunip 		SIZE 069, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 072, 140 MSGET oGet6 VAR _cCodMun		SIZE 035, 010 OF oDlg VALID (IIF(EMPTY(_cCodMun),.F.,.T.)) COLORS 0, 16777215 F3 "CCSZC1" PIXEL
    @ 088, 040 MSGET oGet7 VAR _cComplem 	SIZE 249, 010 OF oDlg COLORS 0, 16777215 PIXEL   
    
    @ 121, 002 GROUP oGroup2 TO 231, 300 PROMPT "Protheus" OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 144, 008 SAY oSay10 PROMPT "Rua/Av" 		SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 160, 008 SAY oSay11 PROMPT "Bairro" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 174, 009 SAY oSay12 PROMPT "CEP" 			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 187, 008 SAY oSay13 PROMPT "Municipio" 	SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 187, 116 SAY oSay14 PROMPT "Codigo M" 	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 174, 115 SAY oSay15 PROMPT "Estado" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 201, 008 SAY oSay18 PROMPT "Comp"		 	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
   
    @ 143, 040 MSGET oGet8 VAR 	SA1->A1_END    	SIZE 249, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 157, 040 MSGET oGet9 VAR 	SA1->A1_BAIRRO 	SIZE 137, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 171, 040 MSGET oGet10 VAR SA1->A1_CEP    	SIZE 069, 010 OF oDlg PICTURE "@R 99999-999" COLORS 0, 16777215 READONLY PIXEL
    @ 171, 141 MSGET oGet11 VAR SA1->A1_EST    	SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 185, 040 MSGET oGet12 VAR SA1->A1_MUN		SIZE 069, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 185, 141 MSGET oGet13 VAR SA1->A1_COD_MUN SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 200, 040 MSGET oGet14 VAR SA1->A1_COMPL	SIZE 249, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL         
    
    @ 215, 253 BUTTON oButton2 PROMPT "&Alterar" ACTION (oDlg:End(), lResp := .T.) SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED                                   

EndIf
                                             
Return(lResp,_cEnd,_cBairro,_cCep,_cEstado,_cMunip,_cCodMun,_cComplem)             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PEDSITDBL()         

If ZC1->ZC1_STATUS != '4'      

	MsgInfo("Pedido de Venda Site Desbloqueado!")
	RECLOCK("ZC1",.F.)
		ZC1->ZC1_STATUS := "3"
	ZC1->(MSUNLOCK()) 
	
Else
	MsgAlert("Pedido de Venda Site Faturado " + ZC1->ZC1_PEDIDO)
	
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDSITEC1 � Autor � Douglas Silva      � Data �  31/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este fonte tem como objetivo importar e tratar os pedidos  ���
���          � gerados pela contentstaff                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 FATURAMENTO                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PEDSITPG()                                      

Static oDlg
Static oButton1
Static oGet1
Static oGet2
Static oGet3
Static oGet4
Static oGroup1
Static oSay1
Static oSay2
Static oSay3
Static oSay4 

Private lResp	:= .F.
Private nComboBox1 	:= ZC1->ZC1_FORMAS
Private nComboBox2	:= ZC1->ZC1_BANDCS
Private nParcelas	:= ZC1->ZC1_ZPARS
Private cTipoOP		:= SPACE(3)

  DEFINE MSDIALOG oDlg TITLE "Forma de Pagamento" FROM 000, 000  TO 200, 305 COLORS 0, 16777215 PIXEL

    @ 002, 002 GROUP oGroup1 TO 097, 152 OF oDlg COLOR 0, 16777215 PIXEL
    @ 018, 007 SAY oSay1 PROMPT "Tipo de Pagamento" SIZE 047, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 036, 007 SAY oSay2 PROMPT "Bandeira" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 007 SAY oSay3 PROMPT "Parcelas" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 070, 007 SAY oSay4 PROMPT "Tipo de Operacao" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017, 062 MSCOMBOBOX oComboBox1 VAR nComboBox1 ITEMS {"1=Cartao","2=Debito CC","3=Boleto"} SIZE 060, 010 OF oDlg COLORS 0, 16777215  PIXEL
    @ 034, 062 MSCOMBOBOX oComboBox2 VAR nComboBox2 ITEMS {"2=Visa", "3=Master", "4=Amex", "5=Dinners","9=Hiper"} SIZE 060, 010 OF oDlg COLORS 0, 16777215  PIXEL
    @ 050, 062 MSGET oGet3 VAR nParcelas SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 068, 062 MSGET oGet4 VAR cTipoOP SIZE 060, 010 OF oDlg VALID (IIF(EMPTY(cTipoOP),.F.,.T.)) COLORS 0, 16777215 F3 "SZ9"  PIXEL
    @ 083, 107 BUTTON oButton1 PROMPT "&OK" ACTION (oDlg:End()) SIZE 037, 012 OF oDlg PIXEL
    
  ACTIVATE MSDIALOG oDlg CENTERED 
  
Return(cTipoOP)