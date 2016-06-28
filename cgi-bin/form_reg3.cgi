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
          
          my $email=$q->param('email');
          my $password=$q->param('password');
          my $gg=$q->param('gg');
          my $mese=$q->param('mese');
          my $anno=$q->param('anno');
          my $nome=$q->param("nome");
          my $cognome=$q->param("cognome");
          my $CF=$q->param("CF");
          my $professione=$q->param("professione");
          my $genere=$q->param("genere");
          
          $datiForm {'email'}=$email ;
          $datiForm {'password'}=$password ;
          $datiForm {'gg'}=$gg ;
          $datiForm {'mese'}=$mese ;
          $datiForm {'anno'}=$anno ;
          $datiForm {'nome'}=$nome ;
          $datiForm {'cognome'}=$cognome ;
          $datiForm {'CF'}= $CF;
          $datiForm {'professione'}=$professione ;
          $datiForm {'genere'}=$genere ;
     
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
	#********************CONTROLLI SU INSERIMENTO CODICE-SCRIPT NOCIVI************
	foreach my $text (values %datiForm)
	{
		my $sostMinore="&lt;";
  	 	my $sostMaggiore="&gt;";
   		$text=~ s/</$sostMinore/g | s/>/$sostMaggiore/g;
	}
       #******************FINE CONTROLLI SU INSERIMENTO CODICE-SCRIPT NOCIVI************


 if($error ne  0){
        util::html_util::start_html("Registrazione", "Registrazione");
        util::base_util::showSchedaTre(%datiForm );
        util::html_util::end_html();
        
      }
      else{

      # Stampa form successivo

      util::html_util::start_html("Registrazione", "Registrazione");
      # stampa form  REGISTRAZIONE: DATI PAGAMENTO
      util::base_util::showSchedaQuattro(%datiForm);
      util::html_util::end_html();
}

       
