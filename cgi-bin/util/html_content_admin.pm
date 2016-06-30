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

#use POSIX;
#use URI;

use Exporter qw(import);
our @EXPORT = qw(calcolaID modificaAbbonamentoForm Modifica_Abbonamento stampaRiepilogoModifica stampaPrezziModificabili deleteAbbonamento creaAbbonamento riepilogoNuovoAbbonamento);

package util::html_content_admin;

#--------------- FUNZIONE ELIMINAZIONE SPAZZI ---------------
sub  trim{ 
    my $s = shift;
    $s =~ s/^\s+|\s+$//g; return $s;
    }

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
sub stampaPrezziModificabili{

    #my $q = new CGI;
    #my ($user,$path)= @_;
    my $valuta = "€";
    my $doc = util::db_util::caricamentoLibXML();

    my $query = "listaAbbonamenti/categoria";

    print "
    <div id=\"nav2\"><ul>";
    foreach my $titArea($doc->findnodes($query))
    {
        my $area = util::html_content::enc($titArea->findnodes("./titolo"));
         ($area) = ($area =~ /<titolo>(.*)<\/titolo>/);
         my @areaSplit=split  " ", $area; #split della data in modo tale da poterla elaborare
       my  $areaUnita=$areaSplit[0].$areaSplit[1].$areaSplit[2];
        
         print" <li><a href=\"#$areaUnita\">".$area."</a></li>";
      }
     print" </ul></div>
    <div id=\"content\">
        <h1>Prezzi e Offerte</h1>
           <form class=\"add_button\" action=\"addAbbonamento.cgi\" method=\"post\">
           <button name=\"Nuovo\" type=\"submit\" class=\"\" value=\"\" >Crea un nuovo abbonamento</button>
        </form>

        ";


    foreach my $titArea($doc->findnodes($query))
    {
        my $area = util::html_content::enc($titArea->findnodes("./titolo"));
         ($area) = ($area =~ /<titolo>(.*)<\/titolo>/);
          my @areaSplit=split  " ", $area; #split della data in modo tale da poterla elaborare
        my $areaUnita=$areaSplit[0].$areaSplit[1].$areaSplit[2];
         print" 
         <div class=\"packages\" id=\"$areaUnita\"><h2> $area </h2> ";        

        foreach my $partAbb($titArea->findnodes("./abbonamento"))
        {
            my $stato = util::html_content::enc($partAbb->getAttribute('stato'));

            if($stato eq "valido"){


                  my $durata = util::html_content::enc($partAbb->findnodes("./durata"));
                  ($durata)=($durata=~ /<durata>(.*)<\/durata>/);
                  my $prezzo = util::html_content::enc($partAbb->findnodes("./prezzo"));
                  ($prezzo)=($prezzo=~ /<prezzo>(.*)<\/prezzo>/);
      
                 my $desc = util::html_content::enc($partAbb->findnodes("./descrizione"));
                 ($desc)=($desc=~ /<descrizione>(.*)<\/descrizione>/);
      
                  my $id = util::html_content::enc($partAbb->getAttribute('ID'));

            print"
                <ul class=\"package\">
               <li class=\"title\"> $durata </li>
                <li class=\"price\"> $prezzo $valuta </li>
                <li class=\"description\"> $desc </li>
                <li class=\"a_button\" > <form class=\"description\" action=\"ModificaAbbonamento.cgi\" method=\"post\">
                     <button name=\"Mod\" type=\"submit\" class=\"admin_button\" value=\"$id\" >Modifica</button>
          </form>  </li>
          <li class=\"a_button\"> <form class=\"description\" action=\"eliminazione_abbonamento.cgi\" method=\"post\">
                     <button name=\"Elim\" type=\"submit\"  value=\"$id\" >Elimina</button>
          </form>  </li>
                      </ul> "; }
                  }
    
        print "</div>";
    }# CHIUSURA FOREACH TITOLI

    print "</div>";

}

#--------------- FUNZIONE CHE CONSENTE DI ELIMINARE UN ABBONAMENTO SELEZIONATO DALL'UTENTE ---------------
sub deleteAbbonamento{

    my $cgi = new CGI;
    my $file = "../data/prezzi.xml";
    my $parser = XML::LibXML->new();
    my $doc = $parser->parse_file($file);

    #recupero dell'id dal bottone
    my $id_abbonamento = $cgi->param('Elim');

    #recupero del nodo da eliminare
    my $nodoElim =$doc->findnodes("//abbonamento[\@ID=$id_abbonamento]")->get_node(1);
    #inserimento del nodo tra quelli "non-validi" ovvero eliminati 
    $nodoElim->setAttribute( 'stato', "non-valido" );
    #salvataggio delle modifiche nel database -> (in generale non è nelle funzioni di modifica/elimina in quanto dal mio punto di vista a senso salvare una volta sola le modifiche nel file)
    open(OUT,">$file") or die $!;
    print OUT $doc->toString;
    close(OUT);      

    #redirect alla pagina "prezziModificabili"   
    print "Location:prezziModificabili.cgi\n\n";
}


#--------------- PAGINA DI INSERIMENTO DEI CAMPI PER CREARE UN NUOVO ABBONAMENTO ---------------

sub creaAbbonamento{

    my %formErr=@_;

    print "
    <div id=\"content\">
        <h1> Nuovo Abbonamento  </h1>
        <form action=\"riepilogoAggiunta.cgi\" method=\"post\" id=\"mod\">
            <ol>

                <li> <label> Area</label>";
            if($formErr{'area'} eq "Area Cross Fitness") 
            {print"<select name=\"area\" id=\"area\" >                                              
                    <option >Area Soft Fitness</option>
                    <option>Area Cardio Fitness</option>
                    <option selected=\"selected\">Area Cross Fitness</option>
                </select> </li>";}
            elsif($formErr{'area'} eq "Area Cardio Fitness"){
                print"<select name=\"area\" id=\"area\" >                                              
                    <option>Area Soft Fitness</option>
                    <option selected=\"selected\">Area Cardio Fitness</option>
                    <option>Area Cross Fitness</option>
                </select> </li>";

            }
            else{
                print"<select name=\"area\" id=\"area\" >                                              
                    <option selected=\"selected\" >Area Soft Fitness</option>
                    <option >Area Cardio Fitness</option>
                    <option>Area Cross Fitness</option>
                </select> </li>";

            }

           print" <li> <label> Descrizione </label> 
                <textarea cols=\"20\" rows=\"4\" name=\"descrizione\"  class=\"area\">".$formErr{'descrizione'}."</textarea> 
                <span class=\"erroreForm\"> ".$formErr{'errDesc'}."</span> </li>
                <li> <label> Periodo </label>";
                
              
            if($formErr{'durata'} eq "Abbonamento mensile")
            {
                print "
                    <select name=\"periodo\" id=\"periodo\" >                                              
                        <option selected=\"selected\">Abbonamento mensile</option>
                        <option>Abbonamento annuale</option>
                    </select> </li>
                ";
            }else{                   #if($Durata eq "Abbonamento annuale")
                 print "
                    <select name=\"periodo\" id=\"periodo\" >                                              
                        <option>Abbonamento mensile</option>
                        <option selected=\"selected\">Abbonamento annuale</option>
                    </select> </li>
                ";
              }
           
                 print "<li > <label> Prezzo (€)</label> 
                 <input name=\"prezzo\" id=\"prezzi\" value=\"".$formErr{'prezzo'}."\"/>
                 <span class=\"erroreForm\"> ".$formErr{'errPrezzo'}."</span> </li>    
                    </ol>
                        
                    <button name=\"crea_nuovo\" type=\"submit\" class=\"submit_button\"  id=\"invia_mod\" value=\"\" >Crea</button>
        </form>
    </div>
            ";

    

}
#--------------- FUNZIONE CHE PERMETTE DI CALCOLARE UN ID UNIVOCO ---------------

sub calcolaID{

    my $cgi = new CGI;
    my $file = "../data/prezzi.xml";
    my $parser = XML::LibXML->new();
    my $doc = $parser->parse_file($file);
    my $id=0;

    #ciclo che scorre tutti gli id presenti nel database
    my $dbID=0;
    foreach  my $abbonamenti($doc->findnodes("//abbonamento"))
    {
        $dbID= $abbonamenti->getAttribute('ID');
        if($id<$dbID){ $id=$dbID+0; }
    } 
   
    $id=$id+1;
    return $id;
}




#--------------- FUNZIONE DI STAMPA DELLA PAGINA DI MODIFICA DI UN ABONAMENTO (admin) --------------------
    sub Modifica_Abbonamento{

    #my $q = new CGI;
    #my ($user,$path)= @_;
    my $valuta = "€";

    my $cgi = CGI->new(); # create new CGI object
    
    my $id_abbonamento= $cgi->param('Mod'); #da inserire il parametro delle sessioni

    #print "<p> $id_abbonamento   </p>";

    #Query per recupero dati 
    my $QueryDurata = "//abbonamento[\@ID=$id_abbonamento]/durata/text()"; #trova durata dell'abbonamento =id
    my $QueryDescrizione = "//abbonamento[\@ID=$id_abbonamento]/descrizione/text()"; #trova durata dell'abbonamento =id
    my $QueryPrezzo = "//abbonamento[\@ID=$id_abbonamento]/prezzo/text()"; #trova il prezzo dell'abbonamento =id

    my $doc = util::db_util::caricamentoLibXML();
  
    #recupero dei dati dal database
    my $Durata = util::html_content::enc($doc->findnodes("$QueryDurata"));
    my $Descrizione =  util::html_content::enc($doc->findnodes("$QueryDescrizione"));
    my $Prezzo =  util::html_content::enc($doc->findnodes("$QueryPrezzo"));


    my %formInfo;
    $formInfo{'id'}=$id_abbonamento;
    $formInfo{'durata'}=$Durata;
    $formInfo{'descrizione'}=$Descrizione;
    $formInfo{'prezzo'}=$Prezzo;
    modificaAbbonamentoForm(%formInfo);
}

#------------------- FORM e GESTIONE DEGLI ERRORI per la modifica di un abbonamento
sub modificaAbbonamentoForm{
    my %formErr=@_;
    print "
    <div id=\"content\">
        <h1> Modifica Abbonamento </h1>
        <form action=\"riepilogoModificaAbbonamento.cgi\" method=\"post\" id=\"mod\">
            <ol>
                <li> <label>Descrizione</label> 
                <textarea cols=\"30\" rows=\"8\" name=\"descrizione\" class=\"area\">".$formErr{'descrizione'}."</textarea> 
                <span class=\"erroreForm\"> ".$formErr{'errDesc'}."</span> </li>
                <li> <label> <span>Periodo</span>  </label>
            ";

            if($formErr{'durata'} eq "Abbonamento mensile")
            {
                print "
                    <select name=\"periodo\" id=\"periodo\" >                                              
                        <option selected=\"selected\">\Abbonamento mensile\</option>
                        <option>Abbonamento annuale</option>
                    </select> </li>
                ";
            }else{                   #if($Durata eq "Abbonamento annuale")
                print "
                    <select name=\"periodo\" id=\"periodo\" >                                              
                        <option>Abbonamento mensile</option>
                        <option selected=\"selected\">Abbonamento annuale</option>
                    </select> </li>
                ";
              }

            print "
                 <li > <label> Prezzo (€) </label> 
                 <input name=\"prezzo\" id=\"prezzi\" value=\"".$formErr{'prezzo'}."\"/>
            
                  <span class=\"erroreForm\"> ".$formErr{'errPrezzo'}."</span> </li>    
                    </ol>
                        
                 <button name=\"modifica_Abbonamento\" type=\"submit\" class=\"submit_button\" 
                 id=\"invia_mod\" value=\"".$formErr{'id'}."\" >Modifica</button>
                </form>
                    </div>";

}



1;

