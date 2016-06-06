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
        my %datiForm ;

        # scrivo i dati inseriti nell'array $datiForm  per ripristinare i dati inseriti nella form in caso di errore
        $datiForm {'tel'}=$tel;
        $datiForm {'indirizzo'}=$indirizzo;
        $datiForm {'citta'}=$citta;
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
      $datiForm {'errTelefono'}=$tipoerrore;
        #******************** FINE  CONTROLLI NUMERO DI TELEFONO *******************


 if($error ne  0){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaTre(%datiForm );
        util::html_util::end_html();
        
      }
      else{

      # Stampa form successivo

      util::html_util::start_html("Registrazione");
      # stampa form  REGISTRAZIONE: DATI PAGAMENTO
      util::base_util::showSchedaQuattro(%datiForm);
      util::html_util::end_html();
}

       