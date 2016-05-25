my $q = new CGI;
my $session = CGI::Session->load();

if(!($session->is_empty())) { #HO LA SESSIONE APERTA
  print"Location:index.cgi\n\n";
}


 my $error=0;
 my %errori;

else{ # NON HO LA SESSIONE APERTA
       my $tipoerrore=undef;
      if($q->param('registrati')){

        #******************** INIZIO CONTROLLI SULLA MAIL *******************
        if(length($q->param('mail'))==0){
          $tipoerrore="Errore: email è un campo obbligatorio";
          $error=1;
        }elsif (!($q->param('mail')=~/^([\w\-\+\.]+)@([\w\-\+\.]+)\.([\w\-\+\.]+)$/)){
          $tipoerrore="Errore: email non valida";
          $error=1;

        }else{
          my $doc = XML::LibXML->new()->parse_file('../data/utenti.xml');
          my $confMail = $doc->findnodes("utenti/utente/dati_accesso[mail/text()]");
          if ($confMail eq $q->param('mail')){
            $tipoerrore="Errore: email già esistente";
            $error=1;
        }
      }
      $errors{'errEmail'}=$tipoerrore;

      #*********************** FINE CONTROLLI MAIL**************************

      #*********************** INIZIO CONTROLLI SULLA PASSWORD ***************************
      $tipoerrore=undef;
      if(length($q->param('pw'))==0){
        $tipoerrore="Errore: password è un campo obbligatorio";
        $error=1;
      }elsif(length($q->param('pw'))<8){
        $tipoerrore"Errore: la password deve contenere almeno 8 caratteri";
        $error=1;
      }
      $errors{'errPw'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($q->param('pw_repeat'))==0){
        $tipoerrore="Errore: password di conferma è un campo obbligatorio";
        $error=1;
      }else{
        if($q->param('pw') ne $q->param('pw_repeat')){
          $tipoerrore="Errore: password e password di corferma devono essere uguali";
          $error=1;
        }
      }
      $errors{'errPwRep'}=$tipoerrore;
      #******************** FINE CONTROLLI PASSWORD **************************

      #******************** INIZIO CONTROLLI NOME E COGNOME ******************
      $tipoerrore=undef;
      if(length($q->param('nome'))==0){
        $tipoerrore="Errore: nome è un campo obbligatorio";
        $error=1;
      }
      $errors{'errNome'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($q->param('cognome'))==0){
        $tipoerrore="Errore: cognome è un campo obbligatorio";
        $error=1;
      }
      $errors{'errCognome'}=$tipoerrore;
      #******************** fine CONTROLLI NOME E COGNOME ******************

      ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
      $tipoerrore=undef;
      if (length($q->param('gg'))==0 || length($q->param('mese'))==0 || length($q->param('anno'))==0){
        $tipoerrore="Errore: data non completa";
        $error=1;
      }elsif (!($q->param('gg')=~/^[0-9]*$/)){
        $tipoerrore="Errore: giorno contiene caratteri non validi";
        $error=1;
      }elsif (!($q->param('mese')=~/^[0-9]*$/)){
        $tipoerrore="Errore: mese contiene caratteri non validi";
        $error=1;
      }elsif (!($q->param('anno')=~/^[0-9]*$/)){
        $tipoerrore="Errore: anno contiene caratteri non validi";
        $error=1;
      }elsif ($q->param('gg')>31){
        $tipoerrore="Errore: giorno non valido";
        $error=1;
      }elsif ($q->param('mese')>12){
        $tipoerrore="Errore: mese non valido";
        $error=1;
      }elsif ($q->param('anno')>($year+1900-6)||$q->param('anno')<($year+1900-120)){
        $tipoerrore="Errore: anno non valido";
        $error=1;
      }elsif ($q->param('giorno')>30 and ($q->param('mese')==11 || $q->param('mese')==4 || $q->param('mese')==6 || $q->param('mese')==9)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif (($q->param('giorno')>28 and $q->param('mese')==2 and $input('anno')%4!=0)){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }elsif ($q->param('giorno')>29 and $q->param('mese')==2 and $q->param('anno')%4==0){
        $tipoerrore="Errore: data non valida";
        $error=1;
      }
      $errors{"errDataNascita"}=$tipoerrore;

      $tipoerrore=undef;
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

      $tipoerrore=undef;
      if(length($q->param('CF'))==0){
        $tipoerrore="Errore: Codice Fiscale è un campo obbligatorio";
        $error=1;
      }elsif(!($q->param('CF')=~/^[a-z]{6}[0-9]{2}[a-z][0-9]{2}[a-z][0-9]{3}[a-z]$/)){
        $tipoerrore="Errore: inserire un codice fiscale valido";
        $error=1;
      }elsif (length($q->param('CF'))<16 || length($q->param('CF'))>16){
        $tipoerrore="Errore: inserire un codice fiscale con 16 cifre";
        $error=1;
      }
      $errors{'errCF'}=$tipoerrore;

      $tipoerrore=undef;
      if(length($q->param('ncarta'))==0){
        $tipoerrore="Errore: il numero di carta di credito è un capo obbligatorio";
        error=1;
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



    }


}
