#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use util::db_util;
use util::html_content;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(stampaRiepilogoModifica stampaPrezziAcquistabili deleteAbbonamento);

package util::html_content_admin;



################## FUNZIONE DI STAMPA DEL RIEPILOGO DELLA MODIFICA APPENA EFFETTUATA ######################

sub stampaRiepilogoModifica{
   
    my $cgi = CGI->new(); # create new CGI object

    # Dati recuperati dalle form
    my $Descrizione_form = $cgi->param('descrizione');
    my $Durata_form = $cgi->param('periodo');
    my $Prezzo_form = $cgi->param('prezzo');
    my $id_abbonamento= $cgi->param('modifica_Abbonamento');

    #sostituzione dei caratteri '<' e '>' con caratteri safe che non danno problemi nel database xml
    my $sostMinore="&lt;";
    my $sostMaggiore="&gt;";
    $Descrizione_form=~ s/</$sostMinore/g | s/>/$sostMaggiore/g; 

    # Percorso del db xml
    my $file = "../data/prezzi.xml";

    # creazione oggetto parser
    my $parser = XML::LibXML->new();

    # apertura file e lettura input
    my $doc = $parser->parse_file($file);

    # estrazione radice
    my $root = $doc->getDocumentElement;

    # nodi
    my $PathDescrizione = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]/descrizione")->get_node(1);
    my $PathDurata = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]/durata")->get_node(1);
    my $PathPrezzo = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]/prezzo")->get_node(1);

    #nuovi nodi che andranno salvati nel db
    my $nuovaDurata="<durata>$Durata_form</durata>";
    my $nuovoPrezzo="<prezzo>$Prezzo_form</prezzo>";
    my $nuovaDescrizione="<descrizione>$Descrizione_form</descrizione>";

    #nodo padre dei nodi da modificare
    my $padre = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]");

    #modifica del campo durata
    util::db_util::modifica( $padre, $PathDurata, $nuovaDurata, $parser);              #nodo padre, nodo da sostituire, nuovo tag, parser

    #modifica del campo prezzo
    util::db_util::modifica( $padre, $PathPrezzo, $nuovoPrezzo, $parser);              #nodo padre, nodo da sostituire, nuovo tag, parser

    #modifica del campo descrizione
    util::db_util::modifica( $padre, $PathDescrizione, $nuovaDescrizione, $parser);    #nodo padre, nodo da sostituire, nuovo tag, parser

    #salvataggio delle modifiche 
    open(OUT,">$file") or die;
    print OUT $doc->toString;
    close(OUT);

    # area:
    my $area = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]/area/text()");
 
    print "
           <div id=\"content\">
           <h1>Riepilogo delle modifiche</h1>
       ";

    util::html_content::stampaPacchetto($area, $Descrizione_form,$Durata_form, $Prezzo_form);   
    print "
         <p id=\"ritorno\"> Ritorna alla pagina <a href=\"prezziModificabili.cgi\" > Prezzi </a> </p>   
    ";

    print " </div> ";
}

#--------------- PAGINA PREZZI DA STAMPARE QUANDO SI E' UN AMMINISTRATORE ---------------
sub stampaPrezziAcquistabili{

    #my $q = new CGI;
    #my ($user,$path)= @_;
    my $valuta = "€";
    my $doc = util::db_util::caricamentoLibXML();

    my $query = "listaAbbonamenti/categoria";


    print "
    <div id=\"content\">
        <h1>Prezzi e Offerte</h1>
    ";


    foreach my $titArea($doc->findnodes($query))
    {
        my $area = util::html_content::enc($titArea->findnodes("./titolo"));
         ($area) = ($area =~ /<titolo>(.*)<\/titolo>/);

         print"
         <div class=\"packages\"><h2> $area </h2> ";

        foreach my $partAbb($titArea->findnodes("./abbonamento"))
        {
            my $durata = util::html_content::enc($partAbb->findnodes("./durata"));
            ($durata)=($durata=~ /<durata>(.*)<\/durata>/);

            my $prezzo = util::html_content::enc($partAbb->findnodes("./prezzo"));
            ($prezzo)=($prezzo=~ /<prezzo>(.*)<\/prezzo>/);

            my $desc = util::html_content::enc($partAbb->findnodes("./descrizione"));
            ($desc)=($desc=~ /<descrizione>(.*)<\/descrizione>/);

            my $id = util::html_content::enc($partAbb->getAttribute('ID'));  #recupero dell'id selezionato
            
            print"
            <ul class=\"package\">
            <li class=\"title\"> $durata </li>
            <li class=\"price\"> $prezzo $valuta </li>
            <li class=\"description\"> $desc </li>
            <li> <form class=\"description\" action=\"ModificaAbbonamento.cgi\" method=\"post\">
           <button name=\"Mod\" type=\"submit\" class=\"submit_button\" value=\"$id\" >Modifica</button>
</form>  </li>
<li> <form class=\"description\" action=\"eliminazione_abbonamento.cgi\" method=\"post\">
           <button name=\"Elim\" type=\"submit\" class=\"submit_button\" value=\"$id\" >Elimina</button>
</form>  </li>
            </ul>
            
            ";

            }
        print "</div>";
    }# CHIUSURA FOREACH TITOLI

    print "</div>";

}

sub deleteAbbonamento{

    my $cgi = new CGI;
    my $file = "../data/prezzi.xml";
    my $parser = XML::LibXML->new();
    my $doc = $parser->parse_file($file);

    #recupero dell'id dal bottone
    my $id_abbonamento = $cgi->param('Elim');

    #eliminazione del pacchetto
    my $nodoElim = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]")->get_node(1);
    my $parent = $nodoElim->parentNode;
    $parent->removeChild($nodoElim);

    #salvataggio delle modifiche nel database
    open(OUT,">$file") or die $!;
    print OUT $doc->toString;
    close(OUT);      

    #redirect alla pagina "prezziModificabili"   
    print "Location:prezziModificabili.cgi\n\n";
}



1;

