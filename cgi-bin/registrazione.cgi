#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

util::html_util::start_html("Registrazione");

my $q = new CGI;
my $session = CGI::Session->load();


if(!($session->is_empty())) { #HO LA SESSIONE APERTA
  print"Location:index.cgi\n\n";
}


else{ # NON HO LA SESSIONE APERTA
      if($q->param('registrati')){
      	my $cgi = CGI->new();
      	my $email = $cgi->param('email');
      	my $pw=$cgi->param("password");
      	my $pw_repeat=$cgi->param("password_repeat");
      	my $genere=$cgi->param("genere");
      	my $gg=$cgi->param("gg");
      	my $mese=$cgi->param("mese");
      	my $anno=$cgi->param("anno");
      	my $indirizzo=$cgi->param("indirizzo");
      	my $citta=$cgi->param("citta");
      	my $CF=$cgi->param("CF");
      	my $professione=$cgi->param("professione");
      	my $tel=$cgi->param("tel");
      	my $tipocarta=$cgi->param("tipocarta");
      	my $ncarta=$cgi->param("ncarta");

   
    }
  else { # form
     showRegistrationForm('');
  }
}
util::html_util::end_html();

sub showRegistrationForm{
	print"
  <div id=\"content\" >
        <h1> Registrazione </h1>
        <form action=\"registrazione.cgi\" method=\"post\">
            <ol>
                <li><label><span>Email</span></label><input type=\"text\" name=\"email\" value=\"\" /></li>
                <li><label><span lang=\"en\">Password</span></label><input type=\"text\" name=\"password\"  value=\"\" /></li>
                <li><label>Ripeti <span lang=\"en\">password</span></label><input type=\"text\" name=\"password_repeat\"  value=\"\" /></li>
                <li><label>Nome</label><input type=\"text\" name=\"nome\"  value=\"\" /></li>
                <li><label>Cognome</label><input type=\"text\" name=\"cognome\"  value=\"\" /></li>
                Genere<select name=\"genere\" id=\"genere\" >                                              
                        <option selected=\"selected\">M</option>
                        <option>F</option>
                 </select> </li>
                <li><label>Data di nascita</label><input type=\"text\" name=\"gg\"  value=\"\" />  \-
                <input type=\"text\" name=\"mese\"  value=\"\" />  \-<input type=\"text\" name=\"anno\"  value=\"\" /></li>

                <li><label>Professione</label><input type=\"text\" name=\"professione\"  value=\"\" /></li>
                <li><label>Indirizzo</label><input type=\"text\" name=\"indirizzo\"  value=\"\" /></li>
                <li><label>Città</label><input type=\"text\" name=\"citta\"  value=\"\" /></li>
                <li><label>Codice fiscale</label><input type=\"text\" name=\"CF\"  value=\"\" /></li>
                <li> <fieldset>
                    <li><label>Telefono</label><input type=\"text\" name=\"tel\"  value=\"\" /></li>
                <li>Tipo di carta di credito <select name=\"tipocarta\" id=\"tipocarta\" >                                              
                        <option selected=\"selected\">Visa</option>
                        <option>Mastercard</option>
                        <option>American Express</option>
                 </select> </li>
                <li><label>Numero carta</label><input type=\"text\" name=\"numbcarta\"  value=\"\" /></li>
		  </ol>
          <input type=\"submit\" name=\"registrati\"  value=\"Registati\" />
        </form>
    </div>
";}
