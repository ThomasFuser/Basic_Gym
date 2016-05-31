#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::base_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

my $q = new CGI;


my $indirizzo=$q->param("indirizzo");
my $citta=$q->param("citta");
my $tel=$q->param("tel");


      my $tipoerrore=undef;
        my $error=0;
        my %errors;

        # scrivo i dati inseriti nell'array $errors per ripristinare i dati inseriti nella form in caso di errore
        $errors{'tel'}=$tel;
        $errors{'indirizzo'}=$indirizzo;
        $errors{'citta'}=$citta;
        #******************** INIZIO CONTROLLI NUMERO DI TELEFONO *******************
      
      if(length($q->param('tel'))==0){
        $tipoerrore="Errore: telefono è campo obbligatorio";
      }
    elsif(!($q->param('tel')=~/^[0-9]*$/)){
        $tipoerrore="Errore: inserire un numero di telefono valido";
        $error=1;
      }elsif(length($q->param('tel'))<10 || length($q->param('tel'))>10){
        $tipoerrore="Errore: inserire un numero di telefono valido";
        $error=1;
      }
      $errors{'errTelefono'}=$tipoerrore;
        #******************** FINE  CONTROLLI NUMERO DI TELEFONO *******************


 if($error ne  0){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaTre(%errors);
        util::html_util::end_html();
        
      }
      else{

        # salvataggio parametri utente
 
          my $file = "../data/registrazione.xml";
          my $parser = XML::LibXML->new();
          my $doc = $parser->parse_file($file);
          my $padre= $doc->findnodes("//registrazione")->get_node(1);
          my $indirizzo_node= $doc->findnodes("//registrazione/indirizzo")->get_node(1);
          my $citta_node= $doc->findnodes("//registrazione/citta")->get_node(1);
          my $tel_node= $doc->findnodes("//registrazione/tel")->get_node(1);

          my $nuovoINDIRIZZO="<indirizzo>$indirizzo</indirizzo>";
          my $nuovoCITTA="<citta>$citta</citta>";
          my $nuovoTEL="<tel>$tel</tel>";

          util::db_util::modifica($padre, $indirizzo_node, $nuovoINDIRIZZO, $parser);
          util::db_util::modifica($padre, $citta_node, $nuovoCITTA, $parser);
          util::db_util::modifica($padre, $tel_node, $nuovoTEL, $parser);


        #salvataggio delle modifiche
           open(OUT,">$file") or die;
           print OUT $doc->toString;
            close(OUT);


      # Stampa form successivo

      util::html_util::start_html("Registrazione");
      # stampa form  REGISTRAZIONE: DATI PAGAMENTO
      util::base_util::showSchedaQuattro();
      util::html_util::end_html();
}

       