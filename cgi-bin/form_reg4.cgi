#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::base_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

my $q = new CGI;

my $tipocarta=$q->param("tipoCarta");
my $ncarta=$q->param("ncarta");
my $mese_scadenza=$q->param("mese_scadenza");
my $anno_scadenza=$q->param("anno_scadenza");

my $scadenzacarta=$anno_scadenza."-".$mese_scadenza."-01";

# Percorso del db xml
    my $file = "../data/utenti.xml";

    # creazione oggetto parser
    my $parser = XML::LibXML->new();

    # apertura file e lettura input
    my $doc = $parser->parse_file($file);

    # estrazione radice
    my $root = $doc->getDocumentElement;

      my $tipoerrore=undef;
        my $error=0;
        my %datiForm;
      #**************************INIZIO CONTROLLI CARTA DI CREDITO*****************
      if(length($q->param('ncarta'))==0){
        $tipoerrore="Errore: il numero di carta di credito è un capo obbligatorio";
        $error=1;
      }elsif(!($q->param('ncarta')=~/^[0-9]*$/)){
        $tipoerrore="Errore: inserire un numero di carta valido";
        $error=1;
      }elsif($q->param('tipocarta') eq "mastercard"){
        if(length($q->param('ncarta'))<13 || length($q->param('ncarta'))>16){
          $tipoerrore="Errore: numero di carta non conforme al chip";
          $error=1;
        }
      }elsif ($q->param('tipocarta') eq "visa"){
        if(length($q->param('ncarta'))<16 || length($q->param('ncarta'))>16){
          $tipoerrore="Errore: numero di carta non conforme al chip";
          $error=1;
        }
      }elsif ($q->param('tipocarta') eq "american express"){
        if(length($q->param('ncarta'))<15 || length($q->param('ncarta'))>15){
          $tipoerrore="Errore: numero di carta non conforme al chip";
          $error=1;
        }
      }
      $datiForm{'errCarta'}=$tipoerrore;
      #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore
      $datiForm{'tipoCarta'}=$q->param('tipoCarta');
      $datiForm{'ncarta'}=$q->param('ncarta');
      #************************controlli data di scadenza carta di credito*******************


      my $sec,my $min ,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst; 
      ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);


      $tipoerrore=undef;
      if(($q->param("anno_scadenza")+0)< ($year+1900)){
         $tipoerrore="Errore: carta di credito scaduta";
          $error=1;
  
      }elsif(($q->param("anno_scadenza")+0) == ($year+1900)){
        if($q->param("mese_scadenza") <=($mon+1)){
          $tipoerrore="Errore: carta di credito scaduta";
          $error=1;
        }
      }
      $datiForm{'errScadenzaCarta'}=$tipoerrore;
      #salvo i dati inserti nell'array $error per ripristinare i valori inseriti nella form in caso di errore
      $datiForm{'anno_scadenza'}=$q->param('anno_scadenza');
      $datiForm{'mese_scadenza'}=$q->param('mese_scadenza');

      $datiForm{'email'}=$q->param('email');
      $datiForm{'password'}=$q->param('password');
      $datiForm{'nome'}=$q->param('nome');
      $datiForm{'cognome'}=$q->param('cognome');
      $datiForm{'anno'}=$q->param('anno');
      $datiForm{'mese'}=$q->param('mese');
      $datiForm{'gg'}=$q->param('gg');
      $datiForm{'genere'}=$q->param('genere');
      $datiForm{'CF'}=$q->param('CF');
      $datiForm{'indirizzo'}=$q->param('indirizzo');
      $datiForm{'citta'}=$q->param('citta');
      $datiForm{'tel'}=$q->param('tel');
      $datiForm{'professione'}=$q->param('professione');
      $datiForm{'tipoCarta'}=$q->param('tipoCarta');
      $datiForm{'ncarta'}=$q->param('ncarta');
      #*********************************FINE CONTROLLI CARTA DI CREDITO***********
       


 if($error eq  1){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaQuattro(%datiForm);
        util::html_util::end_html();
        
      }
else{ #registrazione con dati corretti

       util::html_util::start_html("Accedi");
       #salvataggio dei dati nel DB

    #creazione dei nodi del nuovo utente
    my $utenteXML = XML::LibXML::Element->new('utente');
    my $dati_accessoXML = XML::LibXML::Element->new('dati_accesso');
    my $mailXML = XML::LibXML::Element->new('mail');
    my $passwordXML = XML::LibXML::Element->new('password');
    my $dati_personaliXML = XML::LibXML::Element->new('dati_personali');
    my $nomeXML = XML::LibXML::Element->new('nome');
    my $cognomeXML = XML::LibXML::Element->new('cognome');
    my $datanascitaXML = XML::LibXML::Element->new('datanascita');
    my $genereXML = XML::LibXML::Element->new('genere');
    my $cfXML = XML::LibXML::Element->new('cf');
    my $indirizzoXML = XML::LibXML::Element->new('indirizzo');
    my $cittaXML = XML::LibXML::Element->new('citta');
    my $telXML = XML::LibXML::Element->new('tel');
    my $professioneXML = XML::LibXML::Element->new('professione');    
    my $dati_pagamentoXML = XML::LibXML::Element->new('dati_pagamento');
    my $tipo_cartaXML = XML::LibXML::Element->new('tipo_carta');
    my $num_cartaXML = XML::LibXML::Element->new('num_carta');
    my $scadenzaXML = XML::LibXML::Element->new('scadenza');

    #inserimento dei dati nel nuovo utente
    my $data_nascita_rec= $datiForm{'anno'}.'-'.$datiForm{'mese'}.'-'.$datiForm{'gg'};
    my $data_scadenza_rec= $datiForm{'anno_scadenza'}.'-'.$datiForm{'mese_scadenza'};

    $mailXML->appendText($datiForm{'email'});
    $passwordXML->appendText($datiForm{'password'});
    $nomeXML->appendText($datiForm{'nome'});
    $cognomeXML->appendText($datiForm{'cognome'});
    $datanascitaXML->appendText($data_nascita_rec);
    $genereXML->appendText($datiForm{'genere'});
    $cfXML->appendText($datiForm{'CF'});
    $indirizzoXML->appendText($datiForm{'indirizzo'});
    $cittaXML->appendText($datiForm{'citta'});
    $telXML->appendText($datiForm{'tel'});
    $professioneXML->appendText($datiForm{'professione'});
    $tipo_cartaXML->appendText($datiForm{'tipoCarta'});
    $num_cartaXML->appendText($datiForm{'ncarta'});
    $scadenzaXML->appendText($data_scadenza_rec);

   
    my $utenti = $doc->findnodes("//utenti")->get_node(1);
    
    $utenti->appendChild($utenteXML);
    $utenteXML->appendChild($dati_accessoXML);
    $utenteXML->appendChild($dati_personaliXML);
    $utenteXML->appendChild($dati_pagamentoXML);
    $dati_accessoXML->appendChild($mailXML);
    $dati_accessoXML->appendChild($passwordXML);
    $dati_personaliXML->appendChild($nomeXML);
    $dati_personaliXML->appendChild($cognomeXML);
    $dati_personaliXML->appendChild($datanascitaXML);
    $dati_personaliXML->appendChild($genereXML);
    $dati_personaliXML->appendChild($cfXML);
    $dati_personaliXML->appendChild($indirizzoXML);
    $dati_personaliXML->appendChild($cittaXML);
    $dati_personaliXML->appendChild($telXML);
    $dati_personaliXML->appendChild($professioneXML);
    $dati_pagamentoXML->appendChild($tipo_cartaXML);
    $dati_pagamentoXML->appendChild($num_cartaXML);
    $dati_pagamentoXML->appendChild($scadenzaXML);

    #salvataggio delle modifiche nel database -> (in generale non è nelle funzioni di modifica/elimina in quanto dal mio punto di vista a senso salvare una volta sola le modifiche nel file)
    open(OUT,">$file") or die $!;
    print OUT $doc->toString;
    close(OUT);

  print "<div id=\"content\" class=\"forms\">
        <p class=\"riepilogo\">Ti sei registrato correttamente! Ora puoi accedere al tuo nuovo profilo...</p>
  ";


  print "
        <h2> Accedi </h2>
       <form onsubmit=\"return checkLogin()\" id=\"login\" action=\"login.cgi\" method=\"post\">
            <ol>
                <li><label><span lang=\"en\">Email</span></label><input type=\"text\" name=\"username\" value=\"\" /></li>
                <li><label><span lang=\"en\">Password</span></label><input type=\"password\" name=\"password\"  value=\"\" /></li>
          <li><input type=\"submit\" name=\"submit_button\" class= \"submit_button\" value=\"Accedi\" /></li>          
         
          </ol>
        </form>
        </div>
           ";

  

       util::html_util::end_html();

}

       






        







      
   
 
