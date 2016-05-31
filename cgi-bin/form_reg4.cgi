#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::base_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

my $q = new CGI;

my $tipocarta=$q->param("tipocarta");
my $ncarta=$q->param("ncarta");
my $mese_scadenza=$q->param("mese_scadenza");
my $anno_scadenza=$q->param("anno_scadenza");

my $scadenzacarta=$anno_scadenza."-".$mese_scadenza."-01";


      my $tipoerrore=undef;
        my $error=0;
        my %errors;
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
      $errors{'errCarta'}=$tipoerrore;

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
      $errors{'errScadenzaCarta'}=$tipoerrore;

      #*********************************FINE CONTROLLI CARTA DI CREDITO***********
       


 if($error eq  1){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaQuattro(%errors);

        util::html_util::end_html();
        
      }
else{

        # salvataggio parametri utente
 
          my $file = "../data/registrazione.xml";
          my $parser = XML::LibXML->new();
          my $doc = $parser->parse_file($file);
          my $padre= $doc->findnodes("//registrazione")->get_node(1);
          my $tipocarta_node= $doc->findnodes("//registrazione/tipocarta")->get_node(1);
          my $ncarta_node= $doc->findnodes("//registrazione/ncarta")->get_node(1);
          my $scadenzacarta_node= $doc->findnodes("//registrazione/scadenzacarta")->get_node(1);
         

          my $nuovoTIPOCARTA="<tipocarta>$tipocarta</tipocarta>";
          my $nuovoNCARTA="<ncarta>$ncarta</ncarta>";
          my $nuovoSCADENZACARTA="<scadenzacarta>$scadenzacarta</scadenzacarta>";

          util::db_util::modifica($padre, $tipocarta_node, $nuovoTIPOCARTA, $parser);
          util::db_util::modifica($padre, $ncarta_node, $nuovoNCARTA, $parser);
          util::db_util::modifica($padre, $scadenzacarta_node, $nuovoSCADENZACARTA, $parser);
        
        #salvataggio delle modifiche
           open(OUT,">$file") or die;
           print OUT $doc->toString;
            close(OUT);
       util::html_util::start_html("Registrazione");
        util::base_util::salva_dati_registrazione();
        util::html_util::end_html();


      # / my $username = "annabonaldo@gmail.com";
    # /   my $password = "ciaociao";

 # /      my $doc = XML::LibXML->new()->parse_file('../data/utenti.xml');
       # if ($doc->findnodes("utenti/utente/dati_accesso[mail/text()='$username' and password/text()='$password']")->size eq 1) {
    # /           my $session = new CGI::Session(undef, $q, {Directory=>File::Spec->tmpdir});
           #my $session = new CGI::Session();
    # /         $session->expire('60m');
     # /        $session->param('username', $username);
    # /         print $session->header(-location=>"index.cgi");
     #  }
      # Accedi al profilo utente 

}

       






        







      
   
 
