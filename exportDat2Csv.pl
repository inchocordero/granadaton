#!/usr/bin/perl

#       CopyRight 2014 Óscar Zafra (oskyar@gmail.com)
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

use Switch;
use Getopt::Long;
use Pod::Usage;
my @entrada;
my $inicio;
my $longitud;
my $valor;

my %args = ();
GetOptions(
           'man|help'=>\$help,
          ) or die pod2usage(1);
pod2usage(-verbose=>2,output=>\*STDERR,1) if $help;
#pod2usage(-verbose=>2, exitstatus=>0, output=>\*STDERR) unless args{dat};


if(scalar(@ARGV) >0){
    while ($ARGV[0] =~ /(\d*\.[dD][aA][tT]$)/){
        push @entrada, shift @ARGV;
    }
    if(scalar(@ARGV) == 3){
        $inicio = $ARGV[0];
        $longitud = $ARGV[1];
        $valor = $ARGV[2];
    }else{
        if(scalar(@ARGV)!=0){
            print "ERROR: no ha introducido los parámetros correctos, exportDat2Csv.pl -h para mas informacion\n";
            exit(0);
        }
    }
    if(scalar(@entrada) == 0){
        print "Error: No ha introducido ningún argumento de tipo archivo.dat, exportDat2Csv.pl -h para mas informacion\n";
        exit(0);
    }
}else{
    print "\n$0\nExtrae solo las líneas que casan con los parámetros pasados como argumentos y lo pasa a CSV, exportDat2Csv.pl -h para mas informacion\n";
    print "FORMATO: " . $0 . " Archivo_entrada <Posicion_Inicial Desplazamiento Valor>\n\n";
    exit(0);
}


while(my $nombre_fichero = shift @entrada){
    my $fichero_salida; 
    open(ENTRADA, "<$nombre_fichero") or die('NO puedo abrir archivo de entrada: ' . $nombre_fichero);
    #$nombre_fichero =~ /(\d+\.[dD][aA][tT])/;
    #$nombre_fichero = $1;
    $fichero_salida = substr($nombre_fichero,0,-4);

    if(scalar(@ARGV)==3){
        open(SALIDA, ">$fichero_salida"."_$inicio"."a".($inicio+$longitud-1)."=$valor.csv") or die('NO puedo abrir archivo de salida: ' . $fichero_salida."csv");
    }else{
        open(SALIDA, ">$fichero_salida.csv") or die('NO puedo abrir archivo de salida: ' . $fichero_salida."csv");
    }
    #Se quita el path para que solo quede el nombre del fichero
    $nombre_fichero =~ /(\d+\.[dD][aA][tT])/;
    #Se cogen las dos primeras cifras que es el identificador
    switch(substr($1,0,2)){
        case "03"{
            print SALIDA '"Tipo de elección.","Año del proceso electoral.", "Mes del proceso electoral.","Código de la candidatura.", "Siglas de la candidatura.", "Denominación de la candidatura.", "Código de la candidatura cabecera de acumulación a nivel provincial.", "Código de la candidatura cabecera de acumulación a nivel autonómico.", "Código de la candidatura cabecera de acumulación a nivel nacional."'."\n";
            foreach my $linea (<ENTRADA>)  {
                if((substr($linea, $inicio-1,$longitud) == $valor) && scalar(@ARGV) == 3){
                    print SALIDA substr($linea, 0,2) . "," . substr($linea, 2,4) . "," . substr($linea, 6,2) . "," . substr($linea, 8,6) . "," . substr($linea, 14,50) . "," . substr($linea, 64,150) . "," . substr($linea, 214,6) . "," . substr($linea, 220,6) . "," . substr($linea, 226,6) . "\n";
                }else{
                    if(scalar(@ARGV) == 0){
                        print SALIDA substr($linea, 0,2) . "," . substr($linea, 2,4) . "," . substr($linea, 6,2) . "," . substr($linea, 8,6) . "," . substr($linea, 14,50) . "," . substr($linea, 64,150) . "," . substr($linea, 214,6) . "," . substr($linea, 220,6) . "," . substr($linea, 226,6) . "\n";
                    }
                }
            }
        }
        case "09" {
            print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1) o Número de pregunta en Referéndum.","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Código I.N.E. del municipio (999 = C.E.R.A.).","Número de distrito municipal en su caso o 01 si el municipio no tiene distritos (distrito único). En el caso de datos procedentes del C.E.R.A., llevará el número del ‘Distrito Electoral’ a que correspondan o 09 si el ámbito de dicho distrito coincide con el de la provincia.","Código de la sección (tres dígitos seguidos de un espacio, letra mayúscula u otro dígito).","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Censo del I.N.E.","Censo de escrutinio o censo C.E.R.A.","Censo C.E.R.E. en escrutinio (Residentes Extranjeros).","Total votantes C.E.R.E. (Residentes Extranjeros).","Votantes del primer avance de participación.","Votantes del segundo avance de participación.","Votos en blanco.","Votos nulos.","Votos a candidaturas.","Votos afirmativos en Referéndum o ceros en otros procesos electorales.","Votos negativos en Referéndum o ceros en otros procesos electorales.","Datos oficiales (Si/No)."'."\n";
            foreach my $linea (<ENTRADA>)  {
                if((substr($linea, $inicio-1,$longitud) == $valor) && scalar(@ARGV) == 3){
                    print SALIDA substr($linea, 0, 2). "," . substr($linea, 2, 4). "," . substr($linea, 6, 2). "," . substr($linea, 8, 1). "," . substr($linea, 9, 2). "," . substr($linea, 11, 2). "," . substr($linea, 13, 3). "," . substr($linea, 16, 2). "," . substr($linea, 18, 4). "," . substr($linea, 22, 1). "," . substr($linea, 23, 7). "," . substr($linea, 30, 7). "," . substr($linea, 37, 7). "," . substr($linea, 44, 7). "," . substr($linea, 51, 7). "," . substr($linea, 58, 7). "," . substr($linea, 65, 7). "," . substr($linea, 72, 7). "," . substr($linea, 79, 7). "," . substr($linea, 86, 7). "," . substr($linea, 93, 7). "," . substr($linea, 100, 1) . "\n";
                }else{
                    if(scalar(@ARGV) == 0){
                        print SALIDA substr($linea, 0, 2). "," . substr($linea, 2, 4). "," . substr($linea, 6, 2). "," . substr($linea, 8, 1). "," . substr($linea, 9, 2). "," . substr($linea, 11, 2). "," . substr($linea, 13, 3). "," . substr($linea, 16, 2). "," . substr($linea, 18, 4). "," . substr($linea, 22, 1). "," . substr($linea, 23, 7). "," . substr($linea, 30, 7). "," . substr($linea, 37, 7). "," . substr($linea, 44, 7). "," . substr($linea, 51, 7). "," . substr($linea, 58, 7). "," . substr($linea, 65, 7). "," . substr($linea, 72, 7). "," . substr($linea, 79, 7). "," . substr($linea, 86, 7). "," . substr($linea, 93, 7). "," . substr($linea, 100, 1) . "\n";
                    }
                }
            }
        }
        case "10"{
            print SALIDA '"Tipo de elección.","Año del proceso electoral.","Mes del proceso electoral.","Número de vuelta (en procesos a una sola vuelta = 1)","Código de la Comunidad Autónoma o 99 si se trata del Total Nacional del C.E.R.A.","Código I.N.E. de la provincia o 99 si se trata del Total Nacional o Autonómico del C.E.R.A.","Código I.N.E. del municipio (999 = C.E.R.A.).","Número de distrito municipal en su caso o 01 si el municipio no tiene distritos (distrito único). En el caso de datos procedentes del C.E.R.A., llevará el número del ‘Distrito Electoral’ a que correspondan o 09 si el ámbito de dicho distrito coincide con el de la provincia.","Código de la sección (tres dígitos seguidos de un espacio, letra mayúscula u otro dígito).","Código de la mesa (una letra mayúscula identificando la mesa o una ‘U’ en caso de mesa única).","Código de la candidatura o del Senador en elecciones al Senado.","Votos obtenidos por la candidatura o el Senador."'."\n";
             foreach my $linea (<ENTRADA>)  {
                if((substr($linea, $inicio-1,$longitud) == $valor) && scalar(@ARGV) == 3){
                    print SALIDA substr($linea, 0, 2). "," . substr($linea, 2, 4). "," . substr($linea, 6, 2). "," . substr($linea, 8, 1). "," . substr($linea, 9, 2). "," . substr($linea, 11, 2). "," . substr($linea, 13, 3). "," . substr($linea, 16, 2). "," . substr($linea, 18, 4). "," . substr($linea, 22, 1). "," . substr($linea, 23, 6). "," . substr($linea, 29, 7). "\n";
                }else{
                    if(scalar(@ARGV) == 0){
                        print SALIDA substr($linea, 0, 2). "," . substr($linea, 2, 4). "," . substr($linea, 6, 2). "," . substr($linea, 8, 1). "," . substr($linea, 9, 2). "," . substr($linea, 11, 2). "," . substr($linea, 13, 3). "," . substr($linea, 16, 2). "," . substr($linea, 18, 4). "," . substr($linea, 22, 1). "," . substr($linea, 23, 6). "," . substr($linea, 29, 7). "\n";
                    }
                }  
            }
        }
    }
    close(ENTRADA);
    close(SALIDA);
}

__END__
 
=head1 NAME
 
exportDat2Csv
 
=head1 SYNOPSIS
 
perl exportDat2Csv.pl nombre_fichero.DAT <posicion_inicio desplazamiento valor>

perl exportDat2Csv.pl *.DAT <posicion_inicio desplazamiento valor>

 
=head1 OPTIONS
 
-Archivo.dat o array de archivos.dat - Se pueden meter todos los que se quieran, siempre y cuando vayan seguidos [Requerido]

-Posicion_inicio, desplazamiento y valor son opcionales, pero si se usan, se tienen que dar los tres valores.

-h,  --help      
 
=head1 DESCRIPTION
 
Este programa convierte los archivos 03xxxxxx.DAT o 09xxxxxx.DAT o 10xxxxxx.DAT de las elecciones de http://www.infoelectoral.mir.es/ a CSV.

Tambien puedes filtrar la salida con los argumentos <posicion_inicio desplazamiento valor>, quiere decir que, dentro convertira y exportara a .CSV todas las lineas.

Por ejemplo, (caracter a caracter en una linea) en la posicion_inicial=10,
con un desplazamiento de 2 tengan el valor 18.

Creado por: Óscar Zafra.
Github: oskyar
E-mail: oskyar@gmail.com

=cut
