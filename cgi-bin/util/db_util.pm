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

  my parser = XML::LibXML->new();

  return $parser->parse_file($filename);
}


#Questo file contiene subroutine per LETTURA E SCRITTURA del DATABASE in XML
