#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

User Function Etmka02()        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CGET21,_CGET22,_CGET23,_CGET24,_CGET25,_CGET26")
SetPrvt("_CGET11,_CGET12,_CGET13,_CGET14,_CGET15,_CGET16")

 /*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿐TMKA02   � Autor � Fabio William         � Data � 11.05.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿌tualiza os Campos de Parcela                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          쿏isparado pelo campo cGet4 do programa TMKVPED              낢�
굇�          �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

// nLiquido Valor Liquido que esta no Telemarketing
//

// _cGet4  == Tipo de Operacao
// _cGet5  == Data do Calculo
// _cGet11 == Data Parcela1
// _cGet12 == Data Parcela2
// _cGet13 == Data Parcela3
// _cGet14 == Data Parcela4
// _cGet15 == Data Parcela5
// _cGet16 == Data Parcela6

//  _cGet21 == Valor da Parcela 1
//  _cGet22 == Valor da Parcela 2
//  _cGet23 == Valor da Parcela 3
//  _cGet24 == Valor da Parcela 4
//  _cGet25 == Valor da Parcela 5
//  _cGet26 == Valor da Parcela 6

_cGet21 := 0.00
_cGet22 := 0.00
_cGet23 := 0.00
_cGet24 := 0.00
_cGet25 := 0.00
_cGet26 := 0.00


_cGet11 := stod("")
_cGet12 := stod("")
_cGet13 := stod("")
_cGet14 := stod("")
_cGet15 := stod("")
_cGet16 := stod("")

// Substituido pelo assistente de conversao do AP5 IDE em 16/03/02 ==> __return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

