#INCLUDE "protheus.ch"                                                                              
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"  
#INCLUDE "AP5MAIL.ch"   

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

User Function PEDSITEC1()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro 	:= "Controle de Pedido de Vendas ContentStaff" 
Private aCores		:= {}

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar"				,"AxPesqui"			,0,1} ,;
		             {"Visualizar"				,"AxVisual"			,0,2} ,;
		             {"Importar Arquivo"		,"U_fImporta()"		,0,3} ,;
		             {"Alterar"					,"AxAltera"			,0,4} ,;
		             {"Excluir"					,"AxDeleta"			,0,5} ,;
		             {"Legenda" 				,"U_PEDSITECL()"	,0,7}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC1"

dbSelectArea("ZC1")
dbSetOrder(1)
                      
////////////////////////////////////////////////////////////////////////////////////////////////////
// Cria��o das cores para controle                                                                //
// BR_AMARELOBR_AZULBR_BRANCOBR_CINZZBR_LARANJABR_MARRONBR_VERDEBR_VERMELHOBR_PINKBR_PRETO		  //
////////////////////////////////////////////////////////////////////////////////////////////////////                                        

AADD(aCores,{"ZC1_STATUS == '2'" ,"BR_VERDE" 	}) //Pedido de Venda Importado para SC5 e SC6
AADD(aCores,{"ZC1_STATUS == '1'" ,"BR_AMARELO" 	}) //Pedido de Venda n�o processado
AADD(aCores,{"ZC1_STATUS == '3'" ,"BR_AZUL" 	}) //Pedido de Venda Bloqueado
AADD(aCores,{"ZC1_STATUS == '4'" ,"BR_LARANJA" 	}) //Pedido de Venda com problema
AADD(aCores,{"ZC1_STATUS == '5'" ,"BR_VERMELHO"	}) //Pedido de Venda com ERRO


dbSelectArea(cString)
mBrowse( 6,1,22,75,"ZC1",,,,,6,aCores,,,,,,,,)

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
   

User Function PEDSITECL()

Local aLegenda := {}

//Montagem da legenda das ocorr�ncias da importa��o
AADD(aLegenda,{"BR_VERDE" 	,"Pedido de Venda Importado" 		})
AADD(aLegenda,{"BR_AMARELO"	,"Pedido de Venda n�o processado"	}) 
AADD(aLegenda,{"BR_AZUL"	,"Pedido de Venda Bloqueado"		})
AADD(aLegenda,{"BR_LARANJA"	,"Pedido de Venda com problema"		}) 
AADD(aLegenda,{"BR_VERMELHO","Pedido de Venda com ERRO"			})

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
Private _cCodCli := "" 

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
		
			If Substr(cLinha,1,1 )=="1"
				
				aadd(aCabec1, {Substr(cLinha,2,10 )})	
			
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
						            Substr(cLinha,44,4  ),;     //6Parcelas                 
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

						Reclock(("ZC1"),.T.)
						
							ZC1->ZC1_FILIAL		:= xFilial("ZC1")
							ZC1->ZC1_STATUS 		:= "1"	
							ZC1->ZC1_DATA			:= STOD(aCabec1[1][1])
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
							ZC1->ZC1_ZPARS		:= VAL(aCabec[1][21])/100
							ZC1->ZC1_DATAPS     	:= STOD(aCabec[1][22])
							ZC1->ZC1_VALORS     	:= VAL(aCabec[1][23])/100
							ZC1->ZC1_TFS       	:= aCabec[1][24]
							ZC1->ZC1_BANDCS		:= aCabec[1][25]
							ZC1->ZC1_DTPGTS		:= STOD(aCabec[1][26])
							ZC1->ZC1_VALPGS		:= VAL(aCabec[1][27])/100
							ZC1->ZC1_VALBS 		:= VAL(aCabec[1][28])/100
							ZC1->ZC1_IERGS		:= aCabec[1][29]
							ZC1->ZC1_TOPS  		:= VAL(aTrailer[1][2])/100
							ZC1->ZC1_DTVESI		:= STOD(aTrailer[1][3])
							ZC1->ZC1_SPS 			:= aTrailer[1][5]  
							ZC1->ZC1_PARCSI		:= VAL(aTrailer[1][6])/100
							ZC1->ZC1_VALPSI     	:= VAL(aTrailer[1][8])/100

						 	//+---------------------------------------------------------------------+
							//| Entra na Rotina para Cadastrar Clientes                             |
							//+---------------------------------------------------------------------+
							
							_cCodCli := U_CADCLIS1(aCabec)
							
							ZC1->ZC1_CLIEPR := _cCodCli		 
							
						 	//+---------------------------------------------------------------------+
							//| Entra na Rotina para Gerar Pedido de Venda                          |
							//+---------------------------------------------------------------------+
							
							If ! EMPTY( (cNumPed 	:= U_CADPEDS1(aCabec,aItens,ZC1->ZC1_CLIEPR)) )			
								ZC1->ZC1_PEDIDO 	:= cNumPed
								ZC1->ZC1_STATUS 	:= IIF(EMPTY(ZC1->ZC1_PEDIDO),"1","2")
							Else
							  	Return
							Endif
						
						MSUnLock()
                    
					Endif
                   
						 For n := 1 To Len(aItens)
		    				If ! ZC2->(DBSEEK(xfilial("ZC2") + aItens[N][2] + STRZERO(aItens[N][8],4)))  	
			                
						   		Reclock(("ZC2"),.T.)
								
									ZC2->ZC2_FILIAL 	:= xFilial("ZC2")
									ZC2->ZC2_ITEM       := STRZERO(aItens[N][8],4)
									ZC2->ZC2_PEDSIT     := aItens[N][1]
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

User Function CADCLIS1(aCabec)

Local aVetor := {}
                               
Private _cMail := "sandra@pini.com.br;priscilarodrigues@pini.com.br;douglas@rvacari.com.br"
Private cNumCod := GETSX8NUM("SA1","A1_COD")
Private _cCPFCGC
Private lMsErroAuto := .F.  
Private _cFP	:= ""
Private _cBloq	:= "1"

//��������������������������������������������������������������Ŀ
//| Abertura do ambiente                                         |
//����������������������������������������������������������������

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SA1"
                                                                           
SA1->(DBSELECTAREA("SA1"))
SA1->(DBSETORDER(3)) 

_cCPFCGC := IIF(aCabec[1][11] = "J", aCabec[1][5],SUBSTR(aCabec[1][5],4,11))

	If ! SA1->(DBSEEK(xFilial("SA1") + _cCPFCGC ))
	
		SZ0->(DBSELECTAREA("SZ0"))
		SZ0->(DBSETORDER(1))
             
	 	//+---------------------------------------------------------------------+
		//| Verifica se CEP existe na base dos Correios (SZ0)                   |
		//+---------------------------------------------------------------------+

		If ! SZ0->(DBSEEK(xFilial("SZ0") + cValToChar(aCabec[1][13]) ))  
			U_MailNotify(_cMail,,"IMPORTA��O PEDIDO DE VENDA EDITORA PINI ERRO CEP ",{"CEP N�O CADASTRADO NA BASE DE PARA CORREIOS " + Time() + " --- " + Memoread( "Cliente: " + cNumCod + " CEP " + SUBSTR(aCabec[1][13],1,5) + "-" + SUBSTR(aCabec[1][13],6,3)) },,.F.)	
			_cBloq := "2"
		EndIf		

		 	//+---------------------------------------------------------------------+
			//| Preenche vetor com dados do Cliente                                 |
			//+---------------------------------------------------------------------+

			aVetor:={	{"A1_COD"       	,cNumCod		       	,Nil},; // Codigo				 
						{"A1_LOJA"      	,"01"               	,Nil},; // Loja				 
						{"A1_NOME"      	,aCabec[1][3]		  	,Nil},; // Nome				 
						{"A1_NREDUZ"    	,ALLTRIM(aCabec[1][3])	,Nil},; // Nome reduz.				 
						{"A1_TIPO"      	,"F"					,Nil},; // Tipo				 
						{"A1_END"       	,aCabec[1][14]+aCabec[1][14],Nil},; // Endereco				 
 						{"A1_MUN"       	,aCabec[1][18]			,Nil},; // Munincipio					 
						{"A1_PESSOA"    	,aCabec[1][11]			,Nil},; // Tipo do Cliente
						{"A1_CGC"    		,IIF(aCabec[1][11] = "J", aCabec[1][5],SUBSTR(aCabec[1][5],4,11)) 		,Nil},; // CGC
						{"A1_BAIRRO"   	,aCabec[1][17]			,Nil},; // Bairro
						{"A1_CEP"   		,aCabec[1][13]			,Nil},; // Cep
						{"A1_DDD"   		,aCabec[1][16]			,Nil},; // DDD								
						{"A1_TEL"   		,aCabec[1][7]			,Nil},; // Telefone
						{"A1_PAIS"   		,"1058"					,Nil},; // Pais
						{"A1_INSCR"   		,aCabec[1][29]			,Nil},; // Incri��o Estadual
						{"A1_EMAIL"   		,aCabec[1][4]			,Nil},; // Email
						{"A1_COMPLEM"   	,aCabec[1][16]			,Nil},; // Complemento
						{"A1_EST"       	,aCabec[1][19]			,Nil},; // Estado
  						{"A1_COND"      	,"201"					,Nil},; // Codi��o de Pagamento
						{"A1_NATUREZ"   	,"0108      "			,Nil},; // Estado
						{"A1_FLAGGID"   	,"2"					,Nil},; // Estado
						{"A1_ATIVIDA"  	,"9999004"				,Nil},; // Estado
						{"A1_TPCLI"   		,"F"					,Nil},; // Estado						
						{"A1_CLASSE"   	,"A"					,Nil},; // Estado												
						{"A1_RISCO"   		,"A"					,Nil},; // Estado						
						{"A1_TPCLI"   		,"F"					,Nil},; // Estado						
						{"A1_SATIV1"   	,"1"					,Nil},; // Estado						
  						{"A1_SATIV2"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV3"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV4"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV5"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV6"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV7"   	,"1"					,Nil},; // Estado						
						{"A1_SATIV8"   	,"1"					,Nil},; // Estado						
						{"A1_CODMUN"   	,SZ0->Z0_COD_MUN		,Nil},; // Estado						
						{"A1_RECISS"   	,"2"					,Nil},; // Estado						
						{"A1_TPLOG"   		,"R"					,Nil},; // Estado						
						{"A1_LOGR"   		,SZ0->Z0_END			,Nil},; // Estado						
						{"A1_NLOGR"   		,cValToChar(VAL(aCabec[1][14]+aCabec[1][14])),Nil},; // Estado						
						{"A1_COMPL"   		,aCabec[1][16]			,Nil},; // Estado						
						{"A1_TPASS"   		,"1"					,Nil},; // Estado
						{"A1_TPUTI"   		,"6"					,Nil},; // Estado
						{"A1_GRPTEN"   	,"00"					,Nil},; // Estado  
						{"A1_FLAGID"   	,"2"					,Nil},; // Estado  A1_FLAGID 
						{"A1_COD_MUN"   	,SZ0->Z0_COD_MUN		,Nil},; // Codigo do Munincipio
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
	
		If ! SA1->A1_CEP != aCabec[1][13]
			U_MailNotify(_cMail,,"IMPORTA��O PEDIDO DE VENDA EDITORA PINI CEP ",{"CEP DIFERENTE DA BASE PROTHEUS X PEDIDO TXT " + Time() + " --- " + Memoread( "Cliente: " + SA1->A1_COD + " CEP TXT " + SUBSTR(aCabec[1][13],1,5) + "-" + SUBSTR(aCabec[1][13],6,3) + " CEP PROTHEUS " + SUBSTR(SA1->A1_CEP,1,5) + "-" + SUBSTR(SA1->A1_CEP,6,3)  ) },,.F.)	
			_cBloq := "2"
		EndIf

		cNumCod := SA1->A1_COD + SA1->A1_LOJA
		
	EndIf
	
Return( IIF(EMPTY(cNumCod),cNumCod,(IIF(LEN(cNumCod) = 6, cNumCod + "01", cNumCod)) ))

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

User Function CADPEDS1(aCabec,aItens1,cNumCod)

Local cNumPed 
Local aItens2 := {}  

Private cObs      := space(40)
Private cPagto    := "201"
Private c1Comis   := space(06)
Private c2Comis   := space(06)
Private cTipoOper := space(03)
Private nDias := 30

	//+---------------------------------------------------------------------+
	//| Query para verificar se j� existe o pedido nas tabelas SC5 OU SC6   |
	//+---------------------------------------------------------------------+	 
     	
 	cQuery := "SELECT SC5.C5_NUM "
	cQuery += "FROM "+RETSQLNAME("SC5")+" SC5 "
	cQuery += "WHERE SC5.D_E_L_E_T_ != '*' "
	cQuery += "AND SC5.C5_FILIAL = '01' "
	cQuery += "AND SC5.C5_NUMEXT = '"+ALLTRIM(aCabec[1][1])+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRB",.F.,.T.)    
	
	If ! EMPTY(TRB->C5_NUM)
		cNumPed := SC5->C5_NUM
		TRB->(DBCLOSEAREA("TRB"))
		Return(cNumPed)          
	Else
		TRB->(DBCLOSEAREA("TRB"))
		cNumPed := GETSXENUM("SC5","C5_NUM")
	EndIf

		//+---------------------------------------------------------------------+
		//| Cria as Formas de Pagamento + Bandeira de Pagamento                 |
		//+---------------------------------------------------------------------+	 
		
		If aCabec[1][20] == "1"
			_cFP := "C" + aCabec[1][25]
		ElseIf aCabec[1][20] == "2" 		      
			_cFP := "DB"
		ElseIf aCabec[1][20] == "3" 		      
			_cFP := "BO"
		EndIf		
		
		//+---------------------------------------------------------------------+
		//| Busca Cliente                                                       |
		//+---------------------------------------------------------------------+
		
		dbselectarea("SA1")
		dbsetorder(3)
		
		If !dbseek(xFilial("SA1")+IIF(aCabec[1][11] = "J", aCabec[1][5],SUBSTR(aCabec[1][5],4,11)))
			MsgAlert("Cliente n�o localizado!")
		Endif         
		
		dbselectarea("SC5")
		dbsetorder(1)
		
		//+---------------------------------------------------------------------+
		//| Verifica se j� Existe Pedido de Venda                               |
		//+---------------------------------------------------------------------+	 		
					
		If ! SC5->(DBSEEK(xFilial("SC5")+ cNumPed )) 
		
				RECLOCK("SC5",.T.)
					SC5->C5_FILIAL	:= xFilial("SC5")
					SC5->C5_NUM		:= cNumPed
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
					SC5->C5_DATA	:= ddatabase
					SC5->C5_EMISSAO	:= ddatabase 
					SC5->C5_VEND1	:= "000101"
					SC5->C5_VLRPED	:= VAL(aCabec[1][23])/100
					SC5->C5_VEND4	:= c2Comis
					SC5->C5_DTCALC	:= ddatabase
					SC5->C5_AVESP	:= "N"
					SC5->C5_TPTRANS	:= "99" 
					SC5->C5_DESPREM	:= VAL(aCabec[1][30]) / 100 
					SC5->C5_MENNOTA	:= ALLTRIM(aCabec[1][24]) 
					SC5->C5_NUMEXT	:= ALLTRIM(aCabec[1][1])
					SC5->C5_TXMOEDA	:= 1
					SC5->C5_TPCARGA	:= "2" 
					SC5->C5_CLIENT	:= SA1->A1_COD
					SC5->C5_GERAWMS	:= "1"
					SC5->C5_SOLOPC	:= "1"
					SC5->C5_TRANSP	:= "00010"
					SC5->C5_MOEDA	:= 1
					SC5->C5_VOLUME1	:= Len(aItens1)
					SC5->C5_TIPLIB	:= "1"
					SC5->C5_TPFRETE	:= "F"
					
					//+---------------------------------------------------------------------+
					//| Gera as Inform�a�es de Pagamento                                    |
					//+---------------------------------------------------------------------+	 
					
					SC5->C5_DTCALC	:= ddatabase //STOD(aCabec[1][26])
					SC5->C5_TIPOOP	:= _cFP
				   
					If Val(aCabec[1][21]) >= 1   	                                 
						SC5->C5_PARC1	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA1	:= ddatabase
					EndIf
					
					If Val(aCabec[1][21]) >= 2
						SC5->C5_PARC2	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA2	:= ddatabase	+ nDias                  
					EndIf
					
					If Val(aCabec[1][21]) >= 3
						SC5->C5_PARC3	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA3	:= ddatabase	+ (nDias * 3)                  
					EndIf               
					
					If Val(aCabec[1][21]) >= 4
						SC5->C5_PARC4	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA4	:= ddatabase + (nDias * 4)                  
					EndIf               

					If Val(aCabec[1][21]) >= 5
						SC5->C5_PARC5	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA5	:= ddatabase + (nDias * 5)                  
					EndIf

					If Val(aCabec[1][21]) >= 6
						SC5->C5_PARC6	:= VAL(aCabec[1][23])/100 / Val(aCabec[1][21]) 
						SC5->C5_DATA6	:= ddatabase + (nDias * 6)                  
					EndIf
							
				SC5->(MSUNLOCK())
            
			//+---------------------------------------------------------------------+
			//| Leitura do Array com produtos vindos do TXTs                        |
			//+---------------------------------------------------------------------+
			
			For n := 1 To len(aItens1)
			
				SB1->(DBSELECTAREA("SB1"))
				SB1->(DBSETORDER(1))
				
				If SB1->(DBSEEK(xFilial("SB1") + aItens1[N][3] ))
				
					SF4->(DBSELECTAREA("SF4"))
					SF4->(DBSETORDER(1))
					
					If SF4->(DBSEEK(xFilial("SF4") + SB1->B1_TS ))
													
						RECLOCK("SC6",.T.)
							SC6->C6_FILIAL	:= xFilial("SC6")
						 	SC6->C6_ITEM    := STRZERO(N,2)
						    SC6->C6_PRODUTO	:= SB1->B1_COD
							SC6->C6_LOCAL   := SB1->B1_LOCPAD 
							SC6->C6_DESCRI	:= SB1->B1_DESC
							SC6->C6_TES		:= SB1->B1_TS            
							SC6->C6_CF      := SF4->F4_CF 
							SC6->C6_QTDVEN	:= VAL(aItens1[N][5])
							SC6->C6_PRCVEN	:= VAL(aItens1[N][6])/100 / VAL(aItens1[N][5]) 
							//SC5->C6_PRUNIT	:= VAL(aItens1[N][6])/100 / VAL(aItens1[N][5]) 
							SC6->C6_VALOR	:= VAL(aItens1[N][6])/100
							SC6->C6_DATA	:= ddatabase
							SC6->C6_CLI		:= SA1->A1_COD
							SC6->C6_LOJA	:= SA1->A1_LOJA
							SC6->C6_NUM		:= cNumPed
							SC6->C6_TPOP	:= "F"
							SC6->C6_TIPOREV := "0"
							SC6->C6_EDINIC  := 9999
							SC6->C6_EDFIN   := 9999
							SC6->C6_EDVENC  := 9999
							SC6->C6_EDSUSP  := 9999
							SC6->C6_REGCOT  := '99'+space(13)
							SC6->C6_TPPROG  := 'N'
							SC6->C6_SITUAC  := 'AA'                                                        
					        SC6->C6_CLASFIS := SUBSTR(SF4->F4_SITTRIB,2,2)
					        SC6->C6_COMIS1 	:= ((VAL(aItens1[N][6])/100) * 1 ) / 100   
					        SC6->C6_RATEIO	:= "2"
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

					Alert("Produto n�o cadastrado Pedido Site: " + ALLTRIM(aCabec[1][1]) + " " + ALLTRIM(aItens1[N][3]) + " " + " Descri��o " + " " + ALLTRIM(aItens1[N][4]) )
					
					Return
							
				EndIf
				
			Next n

		Else
		
			//+---------------------------------------------------------------------+
			//| Se houver o pedido retorna o numero preenchendo a variavel          |
			//+---------------------------------------------------------------------+
	
		 	cNumPed := SC5->C5_NUM
		 	Return	
		EndIf
			
//End Transaction
		
Return(cNumPed)                                                                                     