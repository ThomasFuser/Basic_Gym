#!/usr/bin/perl
# use module

use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session  qw();
use strict;
use util::html_util;
use util::html_content;
use util::base_util;
use XML::LibXML;


my $q = new CGI;


# recupero dei dati inseriti dall'utente
my $email=$q->param('email');
my $password=$q->param('password');
my $datanascita= $q->param('datanascita');
my @datanascita_array=split  "-", $datanascita;
my $gg=$datanascita_array[0];
my $mese=$datanascita_array[1];
my $anno=$datanascita_array[2];
my $nome=$q->param("nome");
my $cognome=$q->param("cognome");
my $CF=$q->param("CF");
my $professione=$q->param("professione");
my $genere=$q->param("genere");




   my $tipoerrore=undef;
     my $error=0;
     my %datiForm;
     #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore
     $datiForm{'email'}=$email;
     $datiForm{'password'}=$password;
     $datiForm{'datanascita'}=$datanascita;
     $datiForm{'nome'}=$nome;
     $datiForm{'cognome'}=$cognome;
     $datiForm{'CF'}=$CF;
     $datiForm{'professione'}=$professione;
     $datiForm{'genere'}=$genere;


      #******************** INIZIO CONTROLLI NOME E COGNOME ******************
      $tipoerrore=undef;
      if(length($nome)==0){
        $tipoerrore="Errore: nome è un campo obbligatorio";
        $error=1;
      }
      $datiForm{'errNome'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($cognome)==0){
        $tipoerrore="Errore: cognome è un campo obbligatorio";
        $error=1;
      }
      $datiForm{'errCognome'}=$tipoerrore;
      #******************** fine CONTROLLI NOME E COGNOME ******************
      #############################INIZIO CONTROLLI DATA DI NASCITA#########################################
      my $sec,my $min ,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst; 
      ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
      $tipoerrore=undef;

      if (length($gg)==0 || length($mese)==0 || length($anno)==0){
        $tipoerrore="Errore: data non completa";
        $error=1;
      }elsif (!($gg=~/^[0-9]*$/)){
        $tipoerrore="Errore: giorno contiene caratteri non validi";
        $error=1;
      }elsif (!($mese=~/^[0-9]*$/)){
        $tipoerrore="Errore: mese contiene caratteri non validi";
        $error=1;
      }elsif (!($anno=~/^[0-9]*$/)){
        $tipoerrore="Errore: anno contiene caratteri non validi";
        $error=1;
      }elsif ($gg >31){
        $tipoerrore="Errore: giorno non valido";
        $error=1;
      }elsif ($mese >12){
        $tipoerrore="Errore: mese non valido";
        $error=1;
      }elsif ($anno >($year+1900-6)||$anno<($year+1900-120)){
        $tipoerrore="Errore: anno non valido";
        $error=1;
      }elsif ($gg>30 and ($mese==11 || $mese==4 || $mese==6 || $mese==9)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif (($gg>28 and $gg==2 and ($anno%4)!=0)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif ($gg>29 and $mese==2 and ($anno%4)==0){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }
      $datiForm{"errDataNascita"}=$tipoerrore;
      ######################################## FINE CONTROLLI DATA  DI NASCITA #########################################
    #****************************inizio controlli CODICE FISCALE***************************
    $tipoerrore=undef;
      if(length($q->param('CF'))==0){
        $tipoerrore="Errore: Codice Fiscale è un campo obbligatorio";
        $error=1;
     }#elsif(!($q->param('CF')=~/^[A-Za-z]{6}[0-9]{2}[A-Za-z][0-9]{2}[A-Za-z][0-9]{3}[A-Za-z]$/)){   #commento per prova (da togliere)
      # $tipoerrore="Errore: inserire un codice fiscale valido";
      #  $error=1;}
      elsif (length($q->param('CF'))<16 || length($q->param('CF'))>16){
        $tipoerrore="Errore: inserire un codice fiscale con 16 cifre";
        $error=1;
      }
      $datiForm{'errCF'}=$tipoerrore;
      #*********************************fine controlli CODICE FISCALE ***********************************
  #********************CONTROLLI SU INSERIMENTO CODICE-SCRIPT NOCIVI************
  foreach my $text (values %datiForm)
  {
    my $sostMinore="&lt;";
      my $sostMaggiore="&gt;";
      $text=~ s/</$sostMinore/g | s/>/$sostMaggiore/g;
  }
       #******************FINE CONTROLLI SU INSERIMENTO CODICE-SCRIPT NOCIVI************

if($error ne  0){
        util::html_util::start_html("Registrazione", "Registrazione");
         print"<p> $gg  $mese  $anno </p>";
         util::base_util::showSchedaDue(%datiForm);
        util::html_util::end_html();
        
      }
      else{

      # Stampa form successivo

      util::html_util::start_html("Registrazione", "Registrazione");
      # stampa form  REGISTRAZIONE: CONTATTI  

      util::base_util::showSchedaTre(%datiForm);
      util::html_util::end_html();
}