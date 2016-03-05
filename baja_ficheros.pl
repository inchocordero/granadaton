#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp::Tiny qw(read_file);
use LWP::Simple qw(getstore);
use v5.14;

my @codigos= ( Congreso => "02",
	       Senado => "03",
	       Municipales => "04",
	       Cabildos => "06",
	       "Parlamento Europeo" => "07",
	       "Referéndum" => "01" );

my $file_name = shift || "areaDescarga.html\?method=inicio";

my $file_content = read_file($file_name);

$file_content || die "No puedo cargar fichero $!";

my @files = ($file_content =~ m{(/docxl/\S+.zip)}g);

my %cod_elecciones;
for my  $f ( @files ) {
  my ($tipo_eleccion,$cod_fecha) = ($f =~ /(0\d)_(\d{6})_\d\./);
  say "Tipo $tipo_eleccion, Fecha $cod_fecha";
  $cod_elecciones{$tipo_eleccion.$cod_fecha}=1;
}

my $url = "http://www.infoelectoral.interior.es/docxl/apliext/";
for my $u ( keys %cod_elecciones ) {
  my $file= $u."_";
  for my $ext ( qw(MUNI TOTA) ) {
    my $this_thing = $file.$ext.".zip"; 
    getstore($url.$this_thing, $this_thing);
  }
}
