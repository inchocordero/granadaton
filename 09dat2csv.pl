#!/usr/bin/perl

#       CopyRight 2014 Allan Psicobyte (psicobyte@gmail.com)
#
#       This program is free software: you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation, either version 3 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program.  If not, see <http://www.gnu.org/licenses/>.

$entrada= $ARGV[0];
$salida= $ARGV[1];

if ($salida eq "" || $entrada eq ""){

    print "\n$0\nConvierte 09xxxxxx.DAT de las elecciones de http://www.infoelectoral.mir.es/ a CSV\n";
    print "FORMATO: " . $0 . " ARCHIVO_ENTRADA ARCHIVO_SALIDA\n\n"; 
}
else {
    open(SALIDA, ">$salida") or die('NO puedo abrir archivo de salida: ' . $salida);
    open(ENTRADA, "<$entrada") or die('NO puedo abrir archivo de entrada: ' . $entrada);
    print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1) o Número de pregunta en Referéndum.","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Código I.N.E. del municipio (999 = C.E.R.A.).","Número de distrito municipal en su caso o 01 si el municipio no tiene distritos (distrito único). En el caso de datos procedentes del C.E.R.A., llevará el número del ‘Distrito Electoral’ a que correspondan o 09 si el ámbito de dicho distrito coincide con el de la provincia.","Código de la sección (tres dígitos seguidos de un espacio, letra mayúscula u otro dígito).","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Censo del I.N.E.","Censo de escrutinio o censo C.E.R.A.","Censo C.E.R.E. en escrutinio (Residentes Extranjeros).","Total votantes C.E.R.E. (Residentes Extranjeros).","Votantes del primer avance de participación.","Votantes del segundo avance de participación.","Votos en blanco.","Votos nulos.","Votos a candidaturas.","Votos afirmativos en Referéndum o ceros en otros procesos electorales.","Votos negativos en Referéndum o ceros en otros procesos electorales.","Datos oficiales (Si/No)."'."\n";

    foreach $linea (<ENTRADA>)  {   
        print SALIDA substr($linea, 0, 2). "," . substr($linea, 2, 4). "," . substr($linea, 6, 2). "," . substr($linea, 8, 1). "," . substr($linea, 9, 2). "," . substr($linea, 11, 2). "," . substr($linea, 13, 3). "," . substr($linea, 16, 2). "," . substr($linea, 18, 4). "," . substr($linea, 22, 1). "," . substr($linea, 23, 7). "," . substr($linea, 30, 7). "," . substr($linea, 37, 7). "," . substr($linea, 44, 7). "," . substr($linea, 51, 7). "," . substr($linea, 58, 7). "," . substr($linea, 65, 7). "," . substr($linea, 72, 7). "," . substr($linea, 79, 7). "," . substr($linea, 86, 7). "," . substr($linea, 93, 7). "," . substr($linea, 100, 1) . "\n";
    }

    close(ENTRADA);
    close(SALIDA);
}
