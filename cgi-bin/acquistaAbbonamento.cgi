#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
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
      $username=$session->param("username");
      $id=$q->param("acquista");
      my $doc = util::db_util::caricamentoLibXMLUtenti();
      
      my $doc_prezzi=util::db_util::caricamentoLibXML();
      my $query_prezzi = "listaAbbonamenti/categoria/abbonamento";

      
      util::html_util::start_html("Acquisto abbonamento");
      foreach $acquistato(
      	$doc->findnodes("utenti/utente[dati_accesso/mail/text()='$username']/lista_acquistati/abb_acquistato")){
      	my $id_acq=$acquistato->findnodes("./id_abbonamento/text()");
      	print $id_acq;
      	print $id;



         my $sec,my $min ,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst; 
         ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

 		  my $abbonamento=$doc_prezzi->findnodes("listaAbbonamenti/categoria/abbonamento[\@ID='$id']")->get_node(1);
          my $durata=$abbonamento->findnodes("./durata");

      	if($id eq $id_acq) # l'utente ha gia acquistato questo abbonamento
      	{
      		
    
      		my $inizio_acq=$acquistato->findnodes("./inizio/text()");
      		my $scadenza_acq=$acquistato->findnodes("./scadenza/text()");
      		my @data_scadenza = split  "-", $scadenza_acq;

      		my $nuovadata;
      		my $dataattuale=($year+1900).'-'.($mon+1).'-'.$day;
    		 
    		if($durata eq "Abbnamento annuale"){

    			$nuovadata=($year+1900+1).'-'.($mon+1).'-'.$day;
    			my $scaduto=0;

      			if($data_scadenza[0] > ($year+1900)){ #non scaduto
      				$data_scadenza[0]=$data_scadenza[0]+1;
      				
      			}elsif($data_scadenza[1] > ($mon+1)){ #non scaduto
      				$data_scadenza[0]=$data_scadenza[0]+1;


      			}elsif($data_scadenza[2]> ($day)){ #non scaduto
      				$data_scadenza[0]=$data_scadenza[0]+1;

      			}
      			else{ $scaduto=1;}
      			

      			if ($scaduto eq 1){ #abbonamento in memoria scaduto
      				#memorizzo 
      				#scadenza=$nuovadate
      				#inizio=$dataattuale

      			}else{ #abbonamento in memoria scaduto
      				#memorizzo
      				#scadenza=$datascadenza[0]."-".$datascadenza[1]."-".$datascadenza[2]
      			}


    		}else{ #ABBONAMENTO MENSILE
    				$nuovadata=($year+1900).'-'.($mon+2).'-'.$day;

      			if($data_scadenza[0] > ($year+1900)){ #non scaduto
      				$data_scadenza[1]=$data_scadenza[1]+1;
      				
      			}elsif($data_scadenza[1] > ($mon+1)){ #non scaduto
      				$data_scadenza[1]=$data_scadenza[1]+1;


      			}elsif($data_scadenza[2]> ($day)){ #non scaduto
      				$data_scadenza[1]=$data_scadenza[1]+1;

      			}
      			else{ #abbonamento in memoria scaduto
      				#memorizzo 
      				#scadenza=$nuovadate
      				#inizio=$dataattuale

      			}
    			}


      		#controllo scadenza

      		

       	}else{ # l'utente non ha mai acquistato questo abbonamento


      	#AGGIUNGO NODO <abb_acquistato> 

      	}

      	
      }



      util::html_util::end_html();
}