#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(lettura_dati_utente getFilename getFilenameUtenti caricamentoLibXML caricamentoLibXMLUtenti caricamentoLibXMLRegistrazione getFilenameRegistrazione getFilenamePrezzi caricamentoLibXMLPrezzi);

package util::db_util;

#---------------- PRELEVA IL FILE PREZZI.XML -----------------
sub getFilename{
    return "../data/prezzi.xml";
}

#---------------- PARSA IL FILE RESTITUITO DALLA SUB getFilename() ---------------
sub caricamentoLibXML{

    my $filename = getFilename(); # ATTENZIONE path Windows

    my $parser = XML::LibXML->new();

    return $parser->parse_file($filename);

}

#--------------- PRELEVA IL FILE UTENTI.XML --------------------
sub getFilenameUtenti{
  return "../data/utenti.xml"
}


sub getFilenamePrezzi{
  return "../data/prezzi.xml"
}

#---------------- PARSA IL FILE RESTITUITO DALLA SUB getFilenameUtenti() ---------------
sub caricamentoLibXMLUtenti{
  my $filename = getFilenameUtenti();

  my $parser = XML::LibXML->new();

  return $parser->parse_file($filename);
}

sub caricamentoLibXMLPrezzi{
  my $filename = getFilenamePrezzi();

  my $parser = XML::LibXML->new();

  return $parser->parse_file($filename);
}

sub caricamentoLibXMLRegistrazione{
  my $filename = getFilenameRegistrazione();

  my $parser = XML::LibXML->new();

  return $parser->parse_file($filename);
}
sub getFilenameRegistrazione{
  return "../data/registrazione.xml"

}
#---------------- MODIFICA NODO GENERICA  ---------------
#parametri da passare:   #nodo padre di quello da sostituire, nodo da sostituire, nuovo tag da inserire, parser
sub modifica{ 
    my @parm = @_;

    my $padre=$parm[0];
    my $pathNodoDaSostituire=$parm[1];
    my $nuovoNodo=$parm[2];
    my $parser=$parm[3];
    $padre->removeChild($pathNodoDaSostituire);
    if(eval{$nuovoNodo=$parser->parse_balanced_chunk($nuovoNodo);}) {
        if($padre){
                    $padre->appendChild($nuovoNodo) || die('Non riesco a trovare il padre del nodo in QueryDescrizione');
                  } else { print "<p>Il campo nome deve contenere tag o entità html validi.</p>";  }
    } else { print "<p>I campi devono essere validi</p>"; }
}


#---------------- ELIMINAZIONE DI UN NODO E DI TUTTI I SUOI FIGLI  ---------------
# è necessario passasre $doc + nodo da eliminare
sub eliminaNodo{

    #recupero dei parametri passati attuali
    my @parm = @_;
    my $doc=$parm[0];
    my $nodoElim=$parm[1];

    #eliminazione del pacchetto
    my $parent = $nodoElim->parentNode;
    $parent->removeChild($nodoElim);
}


sub lettura_dati_utente{
  my $username=@_[0];
  my %utente;
  my $doc = util::db_util::caricamentoLibXMLUtenti();
  $utente{'email'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_accesso/mail/text()"));
  $utente{'password'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_accesso/password/text()"));
  $utente{'nome'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/nome/text()"));
  $utente{'cognome'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/cognome/text()"));
  $utente{'genere'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/genere/text()"));
  $utente{'CF'}= util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/cf/text()"));
  $utente{'professione'}= util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/professione/text()"));
 
   
  my $data= util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/datanascita/text()"));
  my @datanascita = split  "-", $data;

  $utente{'datanascita'}=$datanascita[2]."-".$datanascita[1]."-".$datanascita[0];
  $utente{'indirizzo'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/indirizzo/text()"));
  $utente{'citta'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/citta/text()"));
  $utente{'tel'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_personali/tel/text()"));
  $utente{'tipocarta'}= util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_pagamento/tipo_carta/text()"));
  $utente{'ncarta'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_pagamento/num_carta/text()"));
  $utente{'scadenzacarta'} = util::html_content::enc($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/dati_pagamento/scadenza/text()"));

  return %utente;

}



#Questo file contiene subroutine per LETTURA E SCRITTURA del DATABASE in XML
1;