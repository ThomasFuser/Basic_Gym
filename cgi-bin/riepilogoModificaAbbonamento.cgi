#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use util::db_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;






#util::html_content_admin::stampaRiepilogoModifica();


    my $cgi = CGI->new(); # create new CGI object

    # Dati recuperati dalle form
    my $Descrizione_form = $cgi->param('descrizione');
    my $Durata_form = $cgi->param('periodo');
    my $Prezzo_form = $cgi->param('prezzo');
    my $id_abbonamento= $cgi->param('modifica_Abbonamento');



        my $tipoerrore=undef;
        my $error=0;
        my %errors;

        #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore

        $errors{'durata'}=$Durata_form;
        $errors{'prezzo'}=$Prezzo_form;
        $errors{'descrizione'}=$Descrizione_form;
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
       } 
# da capire come fare sta cavolo di espressione regolare per fargli prendere numeri reali senza lettere  robe varie
       #if(!($Prezzo_form =~ /[0-9]+\.?[0-9]*/)){     #if(($Prezzo_form =~ /[-+]?[0-9]*\.?[0-9]+/)){    #if(($Prezzo_form =~ /[a-z] | /)){
         #if(!($Prezzo_form =~ /[0-9]*/)){
         #           $tipoerrore="Errore: inserire un prezzo che non contenga caratteri non numerici (sono ammessi . e ,)";
         #           $error=1;}
       #} 
       if(!($Prezzo_form=~ /^([1-9][0-9]*|0)(\.?[0-9]{2})?$/ ))     
        {
            $tipoerrore="Errore: inserire un prezzo che contenga caratteri non numerici.";
            $error=1;
        }
        $errors{'errPrezzo'}=$tipoerrore;


        if($error eq 1){
       	   util::html_util::start_html("Modifica abbonamento");
		   util::html_content_admin::modificaAbbonamentoForm(%errors);
		   util::html_util::end_html();   }
   else{

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
    my $padre = $doc->findnodes("//abbonamento[\@ID=$id_abbonamento]")->get_node(1);

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
    util::html_util::start_html("Riepilogo modifica abbonamento");
 
    print "
           <div id=\"content\">
           <h1>Riepilogo delle modifiche</h1>
       ";

    util::html_content::stampaPacchetto($area, $Descrizione_form,$Durata_form, $Prezzo_form);   
    print "
         <p id=\"ritorno\"> Ritorna alla pagina <a href=\"prezziModificabili.cgi\" > Prezzi </a> </p>   
    ";

    print " </div> ";


util::html_util::end_html();
}
