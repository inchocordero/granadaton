#!/usr/bin/perl


$entrada= $ARGV[0];
$salida= $ARGV[1];

$colegios= "ColegiosGranadaGeoloc.csv";

open(COLEGIOS, "<$colegios") or die('NO puedo abrir archivo de entrada: ' . $colegios);
 
    foreach $linea (<COLEGIOS>)  {

    chomp $linea;
    @campo= split(/,/, $linea);

    $Colegio{$campo[0]}= $campo[1];
    }

close(COLEGIOS);

open(ENTRADA, "<$entrada") or die('NO puedo abrir archivo de entrada: ' . $entrada);
 
open(SALIDA, ">$salida") or die('NO puedo abrir archivo de entrada: ' . $salida);

print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1)","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Municipio","Número de distrito municipal en su caso o 01 si el municipio no tiene distritos (distrito único). En el caso de datos procedentes del C.E.R.A., llevará el número del ‘Distrito Electoral’ a que correspondan o 09 si el ámbito de dicho distrito coincide con el de la provincia.","Colegio","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Siglas.","Votos obtenidos por la candidatura o el Senador."'."\n";

    foreach $linea (<ENTRADA>)  {

        chomp $linea;
        @campo= split(/,/, $linea);
        if ($campo[6] eq "GRANADA"){
            $cod= "18087" . $campo[8];
            print SALIDA $campo[0] . ',' . $campo[1] . ',' . $campo[2] . ',' . $campo[3] . ',' . $campo[4] . ',' . $campo[5] . ',' .  $campo[6] . ',' . $campo[7] . ',' . $Colegio{$cod} . ',' . $campo[9] . ',' . $campo[10] . ',' . $campo[11] . "\n";
        }
    }
close(SALIDA);
close(ENTRADA);
