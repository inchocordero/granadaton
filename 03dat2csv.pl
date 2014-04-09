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

    print "\n$0\nConvierte 03xxxxxx.DAT de las elecciones de http://www.infoelectoral.mir.es/ a CSV\n";
    print "FORMATO: " . $0 . " ARCHIVO_ENTRADA ARCHIVO_SALIDA\n\n"; 
}
else {
    open(SALIDA, ">$salida") or die('NO puedo abrir archivo de salida: ' . $salida);
    open(ENTRADA, "<$entrada") or die('NO puedo abrir archivo de entrada: ' . $entrada);
    print SALIDA '"Tipo de elección.","Año del proceso electoral.", "Mes del proceso electoral.","Código de la candidatura.", "Siglas de la candidatura.", "Denominación de la candidatura.", "Código de la candidatura cabecera de acumulación a nivel provincial.", "Código de la candidatura cabecera de acumulación a nivel autonómico.", "Código de la candidatura cabecera de acumulación a nivel nacional."'."\n";

    foreach $linea (<ENTRADA>)  {   
        print SALIDA substr($linea, 0,2) . "," . substr($linea, 2,4) . "," . substr($linea, 6,2) . "," . substr($linea, 8,6) . "," . substr($linea, 14,50) . "," . substr($linea, 64,150) . "," . substr($linea, 214,6) . "," . substr($linea, 220,6) . "," . substr($linea, 226,6) . "\n";
    }

    close(ENTRADA);
    close(SALIDA);
}
