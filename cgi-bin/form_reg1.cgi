#!/usr/bin/perl
# use module
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use strict;
use CGI::Session qw();
use XML::LibXML;

use util::html_util;
use util::html_content;
use util::base_util;
use util::db_util;

my $q = new CGI;


# recupero dei dati inseriti dall'utente
my $email=$q->param("email");
my $password=$q->param("password");


        my $tipoerrore=undef;
        my $error=0;
        my %errors;
        #******************** INIZIO CONTROLLI SULLA MAIL *******************
        if(length($email)==0){
          $tipoerrore="Errore: email è un campo obbligatorio";
          $error=1;
          #TODO
        }#elsif (!($q->param('mail')=~ /^([\w\-\+\.]+)@([\w\-\+\.]+)\.([\w\-\+\.]+)$/)){
         # $tipoerrore="Errore: email non valida";
         # $error=1;

       # }
    else{
          my $doc = XML::LibXML->new()->parse_file('../data/utenti.xml');
          my $confMail = $doc->findnodes("utenti/utente/dati_accesso[mail/text()]");
          if ($confMail eq $email){
            $tipoerrore="Errore: email già esistente";
            $error=1;
        }
      }
      $errors{'errEmail'}=$tipoerrore;

      #*********************** FINE CONTROLLI MAIL**************************
      #*********************** INIZIO CONTROLLI SULLA PASSWORD ***************************
      $tipoerrore=undef;
      if(length($password)==0){
        $tipoerrore="Errore: password è un campo obbligatorio";
        $error=1;
      }elsif(length($password)<8){
        $tipoerrore="Errore: la password deve contenere almeno 8 caratteri";
        $error=1;
      }
      $errors{'errPw'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($q->param('password_repeat'))==0){
        $tipoerrore="Errore: password di conferma è un campo obbligatorio";
        $error=1;
      }else{
        if($password ne $q->param('password_repeat')){
          $tipoerrore="Errore: password e password di corferma devono essere uguali";
          $error=1;
        }
      }
      $errors{'errPwRep'}=$tipoerrore;
      #******************** FINE CONTROLLI PASSWORD **************************


      if($error ne  0){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaUno(%errors);
        util::html_util::end_html();
        
      }
      else{

        # salvataggio parametri utente
 
          my $file = "../data/registrazione.xml";
          my $parser = XML::LibXML->new();
          my $doc = $parser->parse_file($file);
          my $padre= $doc->findnodes("//registrazione")->get_node(1);
          my $email_node= $doc->findnodes("//registrazione/email")->get_node(1);
          my $password_node= $doc->findnodes("//registrazione/password")->get_node(1);

          my $nuovaPassword="<password>$password</password>";
          my $nuovaEmail="<email>$email</email>";

          util::db_util::modifica($padre, $email_node, $nuovaEmail, $parser);
          util::db_util::modifica($padre, $password_node, $nuovaPassword, $parser);

        #salvataggio delle modifiche
           open(OUT,">$file") or die;
           print OUT $doc->toString;
            close(OUT);


      # Stampa form successivo

      util::html_util::start_html("Registrazione");
      # stampa form  REGISTRAZIONE: DATI PERSONALI
      util::base_util::showSchedaDue();
      util::html_util::end_html();
}