#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::db_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;
use XML::LibXML;
use Data::Dumper qw(Dumper);


my $q = new CGI;
my $session = CGI::Session->load();

if($session->is_empty()) { # LA SESSIONE NON E' APERTA
  print"Location:index.cgi\n\n";
}
else{
	#stampo la prima parte di pagina html
	util::html_util::start_html("Acquisto abbonamento");

	#recupero db usati nella cgi
	my $doc = util::db_util::caricamentoLibXMLUtenti();
  my $doc_prezzi=util::db_util::caricamentoLibXML();
  my $parser = XML::LibXML->new();
  my $file=util::db_util::getFilenameUtenti();

	#recupero dati (utente e id dell' abbonamento da lui acquistato)
	$username=$session->param("username");
	$id=$q->param("acquista");

	#sentinella per identificare se l'abbonamento è gia presente + salvataggio nodo se l'abbonamento è presente
	my $presente=0;
	my $abbPresente;

	#ciclo che scorre tutti gli abbonamenti acquistati dall'utente per vedere se ha già acquistati in precedenza lo stesso abbonamento
	foreach my $acquistato($doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/lista_acquistati/abb_acquistato")){
		#recupero id degli abbonamenti posseduti dall'utente
		my $id_acq=$acquistato->findnodes("./id_abbonamento/text()");
		if($id eq $id_acq){
			$abbPresente=$doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/lista_acquistati/abb_acquistato[./id_abbonamento='$id_acq']")->get_node(1); #variabile che contiene il nodo da modificare
			$presente=1; 
		}
	}

	#variabili che consentono di salvare  dati relativi al tempo
	my $sec,my $min ,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst; 
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
  my $dataAttuale=($year+1900).'-'.($mon+1).'-'.$mday;

  #variabile che contiene info abbonamento (mensile o annuale)
  my $durataAbbComprato=$doc_prezzi->findnodes("listaAbbonamenti/categoria/abbonamento[\@ID=$id]/durata");

  #l'abbonamento è presente nel database oppure no?
	if($presente==1) #l'abbonamento è gia stato acquistato dall'utente
	{
		#recupero di alcuni dati riguardanti l'abbonamento uguale a quello che è appena stato acquistato (dal db utenti.xml)
		my $inizio_acq=$abbPresente->findnodes("./inizio/text()");
		my $scadenza_acq=$abbPresente->findnodes("./scadenza/text()");	  
		my @data_scadenza=split  "-", $scadenza_acq; #split della data in modo tale da poterla elaborare
			
		#variabile che consente di capire se un abbonamento è scaduto o ancora valido
    my $scaduto=0;
		

    #verifica della validità dell'abbonamento
            if($data_scadenza[0] < ($year+1900)){ $scaduto=1; }                 #abbonamento scaduto
            else{                                                               #abbonamento potenzialmente valido
              if($data_scadenza[0] > ($year+1900)){ $scaduto=0; }               #abbonamento valido                                    
              else{                                                             #l'abbonamento scade nell'anno corrente
                if($data_scadenza[1] > ($mon+1)){ $scaduto=0; }                 #abbonamento valido  
                else{                                                           #l'abbonamento scade in mese <= attuale
                  if($data_scadenza[1] < $mon){ $scaduto=1; }                   #abbonamento scaduto
                  else{                                                         #l'abbonamento scade nel mese corrente
                    if($data_scadenza[2]>=($mday+1)){ $scaduto=0; }             #abbonamento valido
                    else{ $scaduto=1; }                                       
                  }
                }
              }
            }

    #variabili utili alla modifica
     my $nuovaScad;
     my $inizioXML=$abbPresente->findnodes("./inizio")->get_node(1);
     my $scadenzaXML=$abbPresente->findnodes("./scadenza")->get_node(1);

    #abbonamento annuale
		if($durataAbbComprato eq "Abbonamento annuale"){

      if($scaduto==1){		#abbonamento scaduto -> aggiorno data di inizio e data di scadenza
      	#calcolo nuova data di scadenza -> aggiungendo 1 anno alla data attuale
      	$nuovaScad=($year+1900+1).'-'.($mon+1).'-'.$mday; 

      	#creazione dei nodi da inserire nel db
      	my $nuovaDataInizio="<inizio>$dataAttuale</inizio>";
      	my $nuovaDataScadenza="<scadenza>$nuovaScad</scadenza>";
          		
        #modifica XML
      	util::db_util::modifica( $abbPresente, $inizioXML, $nuovaDataInizio, $parser );					
      	util::db_util::modifica( $abbPresente, $scadenzaXML, $nuovaDataScadenza, $parser );

      }else{					#abbonamento non scaduto -> aggiorno solamente la data di scadenza
         $data_scadenza[0]=$data_scadenza[0]+1;
      	$nuovaScad=$data_scadenza[0].'-'.$data_scadenza[1].'-'.$data_scadenza[2];

      	my $nuovaDataScadenza="<scadenza>$nuovaScad</scadenza>";
      	util::db_util::modifica( $abbPresente, $scadenzaXML, $nuovaDataScadenza, $parser );
      }
	}else{			         #l'abbonamento mensile

    my $annoAttuale;
    my $sommaMese;
    if($scaduto==1){   #abbonamento scaduto
      
      #calcolo delle nuove date di riferimento per il nuovo abbonamento
      $sommaMese=$mon+1+1;
      $annoAttuale=$year+1900;
      if($sommaMese>12) { 
        $annoAttuale=$annoAttuale+1; 
        $sommaMese=1;
      }
    }else{    #abbonamento mensile non scaduto -> mantengo giorno scadenza. aggiorno mese ed eventualmente anno
        #calcolo delle nuove date di riferimento per il nuovo abbonamento
      $sommaMese=$data_scadenza[1]+1;
      $annoAttuale=$year+1900;
      if($sommaMese>12) { 
        $annoAttuale=$annoAttuale+1; 
        $sommaMese=1;
      }
    }
      $nuovaScad=$annoAttuale."-".$sommaMese."-".$mday;
      
      #creazione dei nodi da inserire nel db
      my $nuovaDataInizio="<inizio>$dataAttuale</inizio>";
      my $nuovaDataScadenza="<scadenza>$nuovaScad</scadenza>";

      #modifica XML
      util::db_util::modifica( $abbPresente, $inizioXML, $nuovaDataInizio, $parser );         
      util::db_util::modifica( $abbPresente, $scadenzaXML, $nuovaDataScadenza, $parser );
    }

  }else{     #l'abbonamento non è mai stato comprato dall'utente

    #creazione nodi
    my $abb_acquistoXML=XML::LibXML::Element->new('abb_acquisto');
    my $id_acquistoXML=XML::LibXML::Element->new('id_acquisto');
    my $inizioXML=XML::LibXML::Element->new('inizio');
    my $scadenzaXML=XML::LibXML::Element->new('scadenza');

    my $dataScadenza;
            
    if($durataAbbComprato eq "Abbonamento annuale"){  #abbonamento annuale
      $dataScadenza=($year+1900+1).'-'.($mon+1).'-'.$mday; 
    }
    else{   #abbonamento mensile                  
      $sommaMese=$mon+1+1;
      $annoAttuale=$year+1900;
      if($sommaMese>12) { 
        $annoAttuale=$annoAttuale+1; 
        $sommaMese=1;
      }
      $dataScadenza=$annoAttuale."-".$sommaMese."-".$mday;
    }

    #scrittura dati nei nodi
    $inizioXML->appendText($dataAttuale);
    $scadenzaXML->appendText($dataScadenza);
    $id_acquistoXML->appendText($id);
    
    my $listaAbb=$doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/lista_acquistati")->get_node(1);
    #aggiunta dell'abbonamento acquistato alla lista degli abbonamenti acquistati dall'utente
    $listaAbb->appendChild($abb_acquistoXML);
    $abb_acquistoXML->appendChild($id_acquistoXML);
    $abb_acquistoXML->appendChild($inizioXML);
    $abb_acquistoXML->appendChild($scadenzaXML);
  }

  #recupero dati dell'acquisto
  my $Descrizione=util::html_content::enc($doc_prezzi->findnodes("listaAbbonamenti/categoria/abbonamento[\@ID=$id]/descrizione/text()"));
  my $Periodo=$doc_prezzi->findnodes("listaAbbonamenti/categoria/abbonamento[\@ID=$id]/durata/text()");
  my $Prezzo=$doc_prezzi->findnodes("listaAbbonamenti/categoria/abbonamento[\@ID=$id]/prezzo/text()");

  #salvataggio delle modifiche 
  open(OUT,">$file") or die;
  print OUT $doc->toString;
  close(OUT);
  print "
           <div id=\"content\">
            <h1>Acquisto eseguito con successo</h1>
       ";
       
       util::html_content::stampaPacchetto($Area_form, $Descrizione, $Periodo, $Prezzo);
  print"
    <p id=\"ritorno\"> Ritorna alla pagina <a href=\"prezzi.cgi\" > Prezzi </a> per acquistare altri pacchetti </p>
    </div>
    ";

  util::html_util::end_html();
}



