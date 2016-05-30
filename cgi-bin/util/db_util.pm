#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(getFilename getFilenameUtenti caricamentoLibXML caricamentoLibXMLUtenti );

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

#---------------- PARSA IL FILE RESTITUITO DALLA SUB getFilenameUtenti() ---------------
sub caricamentoLibXMLUtenti{
  my $filename = getFilenameUtenti();

  my $parser = XML::LibXML->new();

  return $parser->parse_file($filename);
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

#Questo file contiene subroutine per LETTURA E SCRITTURA del DATABASE in XML
