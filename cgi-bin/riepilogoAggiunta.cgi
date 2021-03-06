#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;



    my $cgi = new CGI;
    my $file = "../data/prezzi.xml";
    my $parser = XML::LibXML->new();
    my $doc = $parser->parse_file($file);

    # Recupero dei dati dalla form                              
    my $Area_form = util::html_content::enc($cgi->param('area'));
    my $Descrizione_form = util::html_content::enc($cgi->param('descrizione'));
    my $Periodo_form = util::html_content::enc($cgi->param('periodo'));
    my $Prezzo_form = util::html_content::enc($cgi->param('prezzo'));
   

    # calcolo di un id univoco per il nuovo abbonamento
    my $id_abbonamento= util::html_content_admin::calcolaID();

    #CONTROLLI PER IL NUOVO PACCHETTO


     $Descrizione_form=~ s/^\s+|\s+$//g;

        my $tipoerrore=undef;
        my $error=0;
        my %errors;

        #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore

        $errors{'durata'}=$Periodo_form;
        $errors{'prezzo'}=$Prezzo_form;
        $errors{'descrizione'}=$Descrizione_form;
        $errors{'area'}=$Area_form;
        $errors{'id'}=$id_abbonamento;
        #******************** INIZIO CONTROLLI SULLA DESCRIZIONE PACCHETTO *******************
        if(length($Descrizione_form)==0){
          $tipoerrore="Errore: inserire descrizone";
          $error=1;
        }
       $errors{'errDesc'}=$tipoerrore;

        #******************** INIZIO CONTROLLI SU PREZZO PACCHETTO *******************
       $tipoerrore=undef;

       if(length($Prezzo_form)==0){
         $tipoerrore="Errore: inserire prezzo";
         $error=1;
       }if(($Prezzo_form+0)<0){
          $tipoerrore="Errore: inserire prezzo maggiore di zero";
          $error=1;
       } if(!($Prezzo_form=~ /^([1-9][0-9]*|0)(\.?[0-9]{2})?$/ ))     
        {
            $tipoerrore="Errore: inserire un prezzo che contenga caratteri non numerici.";
            $error=1;
        }
       $errors{'errPrezzo'}=$tipoerrore;



       if($error ne 0){ #errore nei dati inseriti

       		util::html_util::start_html("Aggiungi un nuovo abbonamento", "Nuovo Abbonamento");
			util::html_content_admin::creaAbbonamento(%errors);
			util::html_util::end_html();


       }
   else{



   #CREAZIONE DEL NUOVO PACCHETTO NELL'XML
    #recupero del nodo nel quale salvare il nuovo abbonamento (come figlio)
    my $categoria = $doc->findnodes("//categoria[titolo='$Area_form']")->get_node(1);    

    #creazione dei nodi del nuovo abbonamento
    my $AbbonamentoXML = XML::LibXML::Element->new('abbonamento');
    my $DescrizioneXML = XML::LibXML::Element->new('descrizione');
    my $PeriodoXML = XML::LibXML::Element->new('durata');
    my $PrezzoXML = XML::LibXML::Element->new('prezzo');

    #riempimento dei campi del nodo
    $AbbonamentoXML->setAttribute( 'ID', $id_abbonamento );
    $AbbonamentoXML->setAttribute( 'stato', "valido" );
    $DescrizioneXML->appendText($Descrizione_form);
    $PeriodoXML->appendText($Periodo_form);
    $PrezzoXML->appendText($Prezzo_form);

    #collegamento dei nodi (creazione del nodo abbonamento)
    $categoria->appendChild($AbbonamentoXML);
    $AbbonamentoXML->appendChild($PeriodoXML);
    $AbbonamentoXML->appendChild($PrezzoXML);
    $AbbonamentoXML->appendChild($DescrizioneXML);

    #salvataggio delle modifiche nel database -> (in generale non è nelle funzioni di modifica/elimina in quanto dal mio punto di vista a senso salvare una volta sola le modifiche nel file)
    open(OUT,">$file") or die $!;
    print OUT $doc->toString;
    close(OUT); 

    # STAMPA RIEPILOGO DEL NUOVO PACCHETTO CREATO
    util::html_util::start_html("Riepilogo inserimento nuovo abbonamento", "Nuovo Abbonamento");

    #stampa del nuovo abbonamento
     print "
           <div id=\"content\">
           <h1>Riepilogo dell'inserimento</h1>
       ";

    util::html_content::stampaPacchetto($Area_form, $Descrizione_form, $Periodo_form, $Prezzo_form);   
    print "
         <p id=\"ritorno\"> Ritorna alla pagina <a href=\"prezziModificabili.cgi\" > Prezzi </a> </p>   
    ";

    print " </div> "; 




#util::html_util::start_html("Riepilogo inserimento nuovo abbonamento");
#util::html_content_admin::riepilogoNuovoAbbonamento();
util::html_util::end_html();
}
