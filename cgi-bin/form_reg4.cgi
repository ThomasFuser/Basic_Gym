#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::base_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

my $q = new CGI;
   util::html_util::start_html("Riepilogo registrazione");

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

      #controllo ancora la mail per capire se l'utente ha ricaricato la pagina di conferma della registrazione
      $datiForm{'email'}=$q->param('email');   #viene recuperato prima in quanto mi serve per il controllo
      my $sentinella=0;
      foreach my $utente($doc->findnodes("//utente"))
      {
        my $confMail = $utente->findnodes("./dati_accesso/mail/text()");
         if ($confMail eq $datiForm{'email'}){ $sentinella=1; } 
      }
         my $stringaFinale;

      if ($sentinella==0){
 
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
  else{                                          #registrazione con dati corretti

         
         
      #salvataggio dati nel database
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
      my $listaXML = XML::LibXML::Element->new('lista_acquistati');                                
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
      $utenteXML->appendChild($listaXML); 
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

      #salvataggio delle modifiche nel database
      open(OUT,">$file") or die $!;
      print OUT $doc->toString;
      close(OUT);
      $stringaFinale="avvenuta con successo";
  }
    
  }else{ $stringaFinale="gia eseguita"; }
    
   

print "
           <div id=\"content\">
           <h1>Riepilogo della registrazione</h1>
       ";
print "
         <p id=\"ritorno\"> Registrazione $stringaFinale . Accedi nella pagine <a href=\"login.cgi\" > Login </a> </p>   
    ";

    print " </div> "; 

util::html_util::end_html();
