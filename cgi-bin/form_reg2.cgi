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
my $gg=$q->param('gg');
my $mese=$q->param('mese');
my $anno=$q->param('anno');
my $datanascita=$anno.'-'.$mese.'-'.$gg;
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
     $datiForm{'gg'}=$gg;
     $datiForm{'mese'}=$mese;
     $datiForm{'anno'}=$anno;
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
      if (length($q->param('gg'))==0 || length($q->param('mese'))==0 || length($q->param('anno'))==0){
        $tipoerrore="Errore: data non completa";
        $error=1;
      }elsif (!($q->param('gg')=~/^[0-9]*$/)){
        $tipoerrore="Errore: giorno contiene caratteri non validi";
        $error=1;
      }elsif (!($q->param('mese')=~/^[0-9]*$/)){
        $tipoerrore="Errore: mese contiene caratteri non validi";
        $error=1;
      }elsif (!($q->param('anno')=~/^[0-9]*$/)){
        $tipoerrore="Errore: anno contiene caratteri non validi";
        $error=1;
      }elsif ($q->param('gg')>31){
        $tipoerrore="Errore: giorno non valido";
        $error=1;
      }elsif ($q->param('mese')>12){
        $tipoerrore="Errore: mese non valido";
        $error=1;
      }elsif ($q->param('anno')>($year+1900-6)||$q->param('anno')<($year+1900-120)){
        $tipoerrore="Errore: anno non valido";
        $error=1;
      }elsif ($q->param('giorno')>30 and ($q->param('mese')==11 || $q->param('mese')==4 || $q->param('mese')==6 || $q->param('mese')==9)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif (($q->param('giorno')>28 and $q->param('mese')==2 and $q->param('anno')%4!=0)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif ($q->param('giorno')>29 and $q->param('mese')==2 and $q->param('anno')%4==0){
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
     # }elsif(!($q->param('CF')=~/^[a-z]{6}[0-9]{2}[a-z][0-9]{2}[a-z][0-9]{3}[a-z]$/)){
       #$tipoerrore="Errore: inserire un codice fiscale valido";
        #$error=1;
      }elsif (length($q->param('CF'))<16 || length($q->param('CF'))>16){
        $tipoerrore="Errore: inserire un codice fiscale con 16 cifre";
        $error=1;
      }
      $datiForm{'errCF'}=$tipoerrore;
      #*********************************fine controlli CODICE FISCALE ***********************************

if($error ne  0){
        util::html_util::start_html("Registrazione");
         util::base_util::showSchedaDue(%datiForm);
        util::html_util::end_html();
        
      }
      else{

      # Stampa form successivo

      util::html_util::start_html("Registrazione");
      # stampa form  REGISTRAZIONE: CONTATTI
      util::base_util::showSchedaTre(%datiForm);
      util::html_util::end_html();
}


