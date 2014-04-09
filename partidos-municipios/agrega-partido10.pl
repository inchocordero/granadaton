#!/usr/bin/perl


$partidos= $ARGV[0];
$entrada= $ARGV[1];
$salida= $ARGV[2];

$municipios= "municipios.csv";

open(MUNICIPIOS, "<$municipios") or die('NO puedo abrir archivo de entrada: ' . $municipios);
 
    foreach $linea (<MUNICIPIOS>)  {

    chomp $linea;
    @campo= split(/,/, $linea);

    $Municipio{$campo[2]}= $campo[0];
    }

close(MUNICIPIOS);

open(PARTIDOS, "<$partidos") or die('NO puedo abrir archivo de partidos: ' . $partidos);
    foreach $linea (<PARTIDOS>)  {
    $Partido{substr($linea, 8,6)}= substr($linea, 14,50);
}
close(PARTIDOS);

open(ENTRADA, "<$entrada") or die('NO puedo abrir archivo de entrada: ' . $entrada);
 
open(SALIDA, ">$salida") or die('NO puedo abrir archivo de entrada: ' . $salida);

print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1)","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Municipio","Número de distrito municipal en su caso o 01 si el municipio no tiene distritos (distrito único). En el caso de datos procedentes del C.E.R.A., llevará el número del ‘Distrito Electoral’ a que correspondan o 09 si el ámbito de dicho distrito coincide con el de la provincia.","Código de la sección (tres dígitos seguidos de un espacio, letra mayúscula u otro dígito).","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Siglas.","Votos obtenidos por la candidatura o el Senador."'."\n";

    foreach $linea (<ENTRADA>)  {

        chomp $linea;
        @campo= split(/,/, $linea);
        if ($campo[5] eq "18"){
            print SALIDA $campo[0] . ',' . $campo[1] . ',' . $campo[2] . ',' . $campo[3] . ',' . $campo[4] . ',' . $campo[5] . ',' .  $Municipio{$campo[6]} . ',' . $campo[7] . ',' . $campo[8] . ',' . $campo[9] . ',' . $Partido{$campo[10]} . ',' . $campo[11] . "\n";
        }
    }
close(SALIDA);
close(ENTRADA);

