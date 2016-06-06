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
      $datiForm{'tipoCarta'}=$q->param('tipocarta');
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

      #*********************************FINE CONTROLLI CARTA DI CREDITO***********
       


 if($error eq  1){
        util::html_util::start_html("Registrazione");
        util::base_util::showSchedaQuattro(%datiForm);
        util::html_util::end_html();
        
      }
else{ #registrazione con dati corretti

       util::html_util::start_html("Accedi");
       #salvataggio dei dati nel DB

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
           ";

  print "</div>";
       util::html_util::end_html();

}

       






        







      
   
 
