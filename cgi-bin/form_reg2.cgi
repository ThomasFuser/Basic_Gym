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
     my %errors;
     #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore
     $errors{'gg'}=$gg;
     $errors{'mese'}=$mese;
     $errors{'anno'}=$anno;
     $errors{'nome'}=$nome;
     $errors{'cognome'}=$cognome;
     $errors{'CF'}=$CF;
     $errors{'professione'}=$professione;
     $errors{'genere'}=$genere;


      #******************** INIZIO CONTROLLI NOME E COGNOME ******************
      $tipoerrore=undef;
      if(length($nome)==0){
        $tipoerrore="Errore: nome è un campo obbligatorio";
        $error=1;
      }
      $errors{'errNome'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($cognome)==0){
        $tipoerrore="Errore: cognome è un campo obbligatorio";
        $error=1;
      }
      $errors{'errCognome'}=$tipoerrore;
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
      $errors{"errDataNascita"}=$tipoerrore;
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
      $errors{'errCF'}=$tipoerrore;
      #*********************************fine controlli CODICE FISCALE ***********************************

if($error ne  0){
        util::html_util::start_html("Registrazione");
         util::base_util::showSchedaDue(%errors);
        util::html_util::end_html();
        
      }
      else{

        # salvataggio parametri utente
 
          my $file = "../data/registrazione.xml";
          my $parser = XML::LibXML->new();
          my $doc = $parser->parse_file($file);
          my $padre= $doc->findnodes("//registrazione")->get_node(1);
          my $nome_node= $doc->findnodes("//registrazione/nome")->get_node(1);
          my $cognome_node= $doc->findnodes("//registrazione/cognome")->get_node(1);
          my $datanascita_node= $doc->findnodes("//registrazione/datanascita")->get_node(1);
          my $CF_node= $doc->findnodes("//registrazione/cf")->get_node(1);
          my $genere_node= $doc->findnodes("//registrazione/genere")->get_node(1);
          my $professione_node= $doc->findnodes("//registrazione/professione")->get_node(1);

          my $nuovoNOME="<nome>$nome</nome>";
          my $nuovoCOGNOME="<cognome>$cognome</cognome>";
          my $nuovoGENERE="<genere>$genere</genere>";
          my $nuovoDATANASCITA="<datanascita>$datanascita</datanascita>";
          my $nuovoCF="<cf>$CF</cf>";
          my $nuovoPROFESSIONE="<professione>$professione</professione>";



          util::db_util::modifica($padre, $nome_node, $nuovoNOME, $parser);
          util::db_util::modifica($padre, $cognome_node, $nuovoCOGNOME, $parser);
          util::db_util::modifica($padre, $genere_node, $nuovoGENERE, $parser);
          util::db_util::modifica($padre, $datanascita_node, $nuovoDATANASCITA, $parser);
          util::db_util::modifica($padre, $CF_node, $nuovoCF, $parser);
          util::db_util::modifica($padre, $professione_node, $nuovoPROFESSIONE, $parser);

        #salvataggio delle modifiche
           open(OUT,">$file") or die;
           print OUT $doc->toString;
            close(OUT);


      # Stampa form successivo

      util::html_util::start_html("Registrazione");
      # stampa form  REGISTRAZIONE: CONTATTI
      util::base_util::showSchedaTre();
      util::html_util::end_html();
}


