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
my $ripetipassword=$q->param("password_repeat");


        my $tipoerrore=undef;
        my $error=0;
        my %datiForm;
        #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore
        $datiForm{'email'}=$email;
        $datiForm{'password'}=$password;
        $datiForm{'ripetipassword'}=$ripetipassword;
        #******************** INIZIO CONTROLLI SULLA MAIL *******************
        if(length($q->param("email"))==0){
          $tipoerrore="Errore: email è un campo obbligatorio";
          $error=1;
          
        }elsif (!($q->param('email')=~/([a-zA-Z0-9][-a-zA-Z0-9_\+\.]*[a-zA-Z0-9])@([a-z0-9][-a-z0-9\.]*[a-z0-9]\.(org|it|com)|([0-9]{1,3}\.{3}[0-9]{1,3}))/)){
          $tipoerrore="Errore: email non valida";
          $error=1;

        }
    else{
         my $sentinella=0;
         my $doc = XML::LibXML->new()->parse_file('../data/utenti.xml');
         foreach my $utente($doc->findnodes("//utente"))
         {
            my $confMail = $utente->findnodes("./dati_accesso/mail/text()");
            if ($confMail eq $email){  $sentinella=1; } 
        }
         
        if (($sentinella==1)){
            $tipoerrore="Errore: email già esistente";
            $error=1;
        }
        
      }
      $datiForm{'errEmail'}=$tipoerrore;

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
      $datiForm{'errPw'}=$tipoerrore;

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
      $datiForm{'errPwRep'}=$tipoerrore;
      #******************** FINE CONTROLLI PASSWORD **************************
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
        util::base_util::showSchedaUno(%datiForm);
        util::html_util::end_html();
        
      }
      else{

       #Stampa form successivo

      util::html_util::start_html("Registrazione", "Registrazione");
       #stampa form  REGISTRAZIONE: DATI PERSONALI
      util::base_util::showSchedaDue(%datiForm);
      util::html_util::end_html();
}
