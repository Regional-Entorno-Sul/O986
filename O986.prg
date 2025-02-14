Function main()
cls

set century on
set date to british
set color to w+/r+

? "---------------------------------------------------------------------"
? "O986.exe versao beta teste - 14/02/2025                              "
? "https://github.com/Regional-Entorno-Sul/O986                         "
? "Identifica casos de toxoplasmose (CID B58) em pacientes gestantes.   "
? "Diretoria Macrorregional Nordeste - Regional Entorno Sul             "
? "---------------------------------------------------------------------"

set color to g+/
? "Testando arquivo modelo..."
use "c:\O986\model.dbf"
nRecs := reccount()
if nRecs >= 1
zap
pack
endif
close

? "Duplicando arquivo modelo..."
copy file "c:\O986\model.dbf" to "c:\O986\model_use.dbf"

? "Excluindo registros que nao sao toxoplasmose CID B58..."
use "c:\O986\nindinet.dbf"
delete for id_agravo <> "B58"
pack
close

? "Marcando os casos de pacientes gestantes..."
use "c:\O986\nindinet.dbf"
do while .not. eof()
replace tp_not with "X" for cs_gestant = "1" .or. cs_gestant = "2" .or. cs_gestant = "3" .or. cs_gestant = "4"
skip
enddo
close

? "Excluindo os registros que nao sao de interesse..."
use "c:\O986\nindinet.dbf"
delete for tp_not <> "X"
pack
close

? "Exportando os casos para arquivo modelo..."
use "c:\O986\model_use.dbf"
append from "c:\O986\nindinet.dbf" fields nu_notific, dt_notific, id_municip, nm_pacient, dt_nasc, cs_gestant, nm_mae_pac, id_mn_resi
close

cOld := "c:\O986\model_use.dbf"
cNew := "c:\O986\toxo_B58.dbf"
rename ( cOld ) to ( cNew )

return nil