#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp::Tiny qw(read_file);
use Archive::Zip;
use v5.14;

my $candidatura_re = qr/(\d{2})(\d{4})(\d{6})(\d{2})(.{50})(.{150})(\d{6})(\d{6})(\d{6})/;
my $resultados_re = qr/(\d{2})(\d{4})(\d{2})(\d{1})(\d{5})(\d{6})(\d{8})(\d*)/;

my @files = glob "*_MUNI.zip";

my (%votos,%candidatos);
my %tipos;

my %codigos= ( Congreso => "02",
	       Senado => "03",
	       Municipales => "04",
	       Cabildos => "06",
	       "Parlamento Europeo" => "07",
	       "Referéndum" => "01" );

my %tipo_es;
map( $tipo_es{$codigos{$_}} = $_, keys %codigos );

for my $file_name (@files) {
  my ($no_ext,$ext) = split(/\./,$file_name);
  my ($tipo,$year,$mes) = ($file_name =~ /(\d{2})(\d{4})(\d{2})/);
  $tipos{$year}{$mes}=$tipo_es{$tipo};
#  say "$file_name Tipo $tipo_es{$tipo}";
  next if $tipo == 1; # Referéndum
  my ($year_2_cifras) = ($year =~ /(\d{2})$/);
  
  my $zip_file = Archive::Zip->new( $file_name );
  
  my @members = $zip_file->members();
  
  #Extrae códigos
  my $codigos;
  if ( $zip_file->contents("03$tipo$year_2_cifras$mes.DAT") ) {
    $codigos = $zip_file->contents("03$tipo$year_2_cifras$mes.DAT");
  } elsif ( $zip_file->contents("$no_ext/03$tipo$year_2_cifras$mes.DAT") ) {
    $codigos = $zip_file->contents("$no_ext/03$tipo$year_2_cifras$mes.DAT");
  } else {
    die "Equivocado tipo de fichero $tipo";
  }
  my @candidaturas = split(/\n/,$codigos);
  my %siglas;
  my %codigos;
  for my $c (@candidaturas) {
    my ($tipo,$year,$mes,$codigo,$siglas,$denominacion,@codigos) = ($c =~ /$candidatura_re/);
    if ( !$siglas ) {
      die "Sin siglas $c";
    }
    $siglas =~ s/\s+$//;
    $denominacion =~ s/\s+$//;
    $siglas{$siglas}=$denominacion;
    for my $cod (qw( PRO AUT NAC ) ) {
      $codigos{$cod}{ shift @codigos } = $siglas;
    }
  }
  
  #Extrae resultados
  my $resultados;
  if ( $zip_file->contents("08$tipo$year_2_cifras$mes.DAT") ) {
    $resultados = $zip_file->contents("08$tipo$year_2_cifras$mes.DAT");
  } elsif ( $zip_file->contents("$no_ext/08$tipo$year_2_cifras$mes.DAT") ) {
    $resultados = $zip_file->contents("$no_ext/08$tipo$year_2_cifras$mes.DAT");
  } else {
    die "Error en resultados con $file_name";
  }
  my @votos = split(/\n/,$resultados);
  for my $c (@votos) {
    my ($tipo,$year,$mes,$vuelta,$distrito,$codigo,$votos,$candidatos) = ($c =~ /$resultados_re/);
    if ( !$distrito ) {
      die "Sin distrito $c ";
    }
    if ( $distrito eq '99999' ) {
      my $este_codigo = $codigos{'NAC'}{$codigo}?$codigos{'NAC'}{$codigo}:($codigos{'AUT'}{$codigo}?$codigos{'AUT'}{$codigo}:$codigos{'PROV'}{$codigo});
      $votos{$year}{$mes}{$tipo}{$este_codigo}=$votos+0;
      $candidatos{$year}{$mes}{$tipo}{$este_codigo}=$candidatos+0;
#      say "{$year}{$mes}{$tipo}{$este_codigo} $votos{$year}{$mes}{$tipo}{$este_codigo}";
    }
  }
}

say "Año,Mes,Tipo,Partido,Votos,Electos";
for my $y ( sort {$a <=> $b } keys %votos ) {
  my %meses = %{$votos{$y}};
  for my $m ( sort {$a <=> $b } keys %meses ) {
    my %tipos = %{$votos{$y}{$m}};
    for my $t ( keys %tipos ) {
      my $este_tipo = $tipo_es{$t};
      my %partidos = %{$votos{$y}{$m}{$t}};

      for my $p ( sort {$votos{$y}{$m}{$t}{$a} <=> $votos{$y}{$m}{$t}{$b} } keys %partidos ) {
	say "$y, $m, $este_tipo, $p, $votos{$y}{$m}{$t}{$p},$candidatos{$y}{$m}{$t}{$p}";
      }
    }
  }
}



