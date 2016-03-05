#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp::Tiny qw(read_file);
use Archive::Zip;
use v5.14;

my $candidatura_re = qr/(\d{2})(\d{4})(\d{6})(\d{2})(\D{50})(\D{150})(\d{6})(\d{6})(\d{6})/;
my $resultados_re = qr/(\d{2})(\d{4})(\d{2})(\d{1})(\d{2})(\d{2})(\d{1})(\d{6})(\d{8})(\d{5})/;
my $file_name = shift || "07199906_MUNI.zip";
my ($tipo,$year,$mes) = ($file_name =~ /(\d{2})(\d{4})(\d{2})/);
my $year_2_cifras = $year % 100;
			 

my $zip_file = Archive::Zip->new( $file_name );

my @members = $zip_file->members();

#Extrae códigos
my $codigos = $zip_file->contents("03$tipo$year_2_cifras$mes.DAT");
my @candidaturas = split(/\n/,$codigos);
my %siglas;
my %codigos;
for my $c (@candidaturas) {
  my ($tipo,$year,$mes,$codigo,$siglas,$denominacion,@codigos) = ($c =~ /$candidatura_re/);
  $siglas =~ s/\s+$//;
  $denominacion =~ s/\s+$//;
  $siglas{$siglas}=$denominacion;
  for my $cod (qw( PRO AUT NAC ) ) {
    $codigos{$cod}{ shift @codigos } = $siglas;
  }
}

#Extrae resultados
my $resultados = $zip_file->contents("08$tipo$year_2_cifras$mes.DAT");
my @votos = split(/\n/,$resultados);
my %votos;
for my $c (@votos) {
  my ($tipo,$year,$mes,$vuelta,$aut,$prov,$distrito,$codigo,$votos,$candidatos) = ($c =~ /$resultados_re/);
  my $este_codigo = $codigos{'NAC'}{$codigo}?$codigos{'NAC'}{$codigo}:($codigos{'AUT'}{$codigo}?$codigos{'AUT'}{$codigo}:$codigos{'PROV'}{$codigo});
  $votos{$este_codigo}=$votos+0;
}

say "Partido,Votos";
for my $p ( sort {$votos{$a} <=> $votos{$b} } keys %votos ) {
  say "$p, $votos{$p}";
}



