#!/usr/bin/perl


$entrada= $ARGV[0];
$salida= $ARGV[1];

$municipios= "municipios.csv";

open(MUNICIPIOS, "<$municipios") or die('NO puedo abrir archivo de entrada: ' . $municipios);
 
    foreach $linea (<MUNICIPIOS>)  {

    chomp $linea;
    @campo= split(/,/, $linea);

    $Municipio{$campo[2]}= $campo[0];
    }

close(MUNICIPIOS);

open(ENTRADA, "<$entrada") or die('NO puedo abrir archivo de entrada: ' . $entrada);
 
open(SALIDA, ">$salida") or die('NO puedo abrir archivo de entrada: ' . $salida);

print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1) o Número de pregunta en Referéndum.","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Municipio","Código de la sección (tres dígitos seguidos de un espacio, letra mayúscula u otro dígito).","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Censo del I.N.E.","Censo de escrutinio o censo C.E.R.A.","Censo C.E.R.E. en escrutinio (Residentes Extranjeros).","Total votantes C.E.R.E. (Residentes Extranjeros).","Votantes del primer avance de participación.","Votantes del segundo avance de participación.","Votos en blanco.","Votos nulos.","Votos a candidaturas.","Votos afirmativos en Referéndum o ceros en otros procesos electorales.","Votos negativos en Referéndum o ceros en otros procesos electorales.","Datos oficiales (Si/No)."'."\n";

    foreach $linea (<ENTRADA>)  {

        chomp $linea;
        @campo= split(/,/, $linea);
        if ($campo[5] eq "18"){
            print SALIDA $campo[0] . ',' . $campo[1] . ',' . $campo[2] . ',' . $campo[3] . ',' . $campo[4] . ',' . $campo[5] . ',' .  $Municipio{$campo[6]} . ',' . $campo[7] . ',' . $campo[8] . ',' . $campo[9] . ',' . $campo[10] . ',' . $campo[11] . ',' . $campo[12] . ',' . $campo[13] . ',' . $campo[14] . ',' . $campo[15] . ',' . $campo[16] . ',' . $campo[17] . ',' . $campo[18] . ',' . $campo[19] . ',' . $campo[20] . ',' . $campo[21] . "\n";
        }
    }
close(SALIDA);
close(ENTRADA);
