#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(showSchedaUno showSchedaDue showSchedaTre showSchedaQuattro dati_formUno dati_formDue dati_formTre dati_formQuattro);


package util::base_util;

sub showSchedaUno{
  my %errform= @_;
	print"
  <div id=\"content\" >
  <h1>Registrazione</h1>
        <h2> Dati di accesso </h2>
        <form action=\"form_reg1.cgi\" method=\"post\">
            <ol>
                <li><label><span>Email</span></label><input type=\"text\" name=\"email\" value=\"\" />";
                if($errform{'errEmail'} ne undef){ print "<span>".$errform{'errEmail'}."</span>"; }

print"</li><li><label><span lang=\"en\">Password</span></label><input type=\"text\" name=\"password\"  value=\"\" />";
if($errform{'errPw'} ne undef){ print "<span>".$errform{'errPw'}."</span>"; }

print"</li><li><label>Ripeti <span lang=\"en\">password</span></label><input type=\"text\" name=\"password_repeat\"  value=\"\" />";      
 if($errform{'errPwRep'} ne undef){ print "<span>".$errform{'errPwRep'}."</span>"; }
               
print"</li></ol>
          <input type=\"submit\" name=\"reg1\"  value=\"Avanti\" />
        </form>
    </div>
";}
sub showSchedaDue{
  my %errform= @_;

  print"
  <div id=\"content\" >
    <h1>Registrazione</h1>
        <h1> Dati personali </h1>
        <form action=\"form_reg2.cgi\" method=\"post\">
            <ol>
                
                <li><label>Nome</label><input type=\"text\" name=\"nome\"  value=\"\" />";
  if($errform{'errNome'} ne undef){ print "<span>".$errform{'errNome'}."</span>"; }


  print"</li>
                <li><label>Cognome</label><input type=\"text\" name=\"cognome\"  value=\"\" />";
  if($errform{'errCognome'} ne undef){ print "<span>".$errform{'errCognome'}."</span>"; }
  print "</li>
                Genere<select name=\"genere\" id=\"genere\" >                                              
                        <option selected=\"selected\">M</option>
                        <option>F</option>
                 </select> </li>
                <li><label>Data di nascita</label><input type=\"text\" name=\"gg\"  value=\"\" />  \-
                      <input type=\"text\" name=\"mese\"  value=\"\" />  \-<input type=\"text\" name=\"anno\"  value=\"\" />";
    if($errform{'errDataNascita'} ne undef){ print "<span>".$errform{'errDataNascita'}."</span>"; }                  
  print "</li>

                <li><label>Professione</label><input type=\"text\" name=\"professione\"  value=\"\" /></li>
                <li><label>Codice fiscale</label><input type=\"text\" name=\"CF\"  value=\"\" />";
  if($errform{'errCF'} ne undef){ print "<span>".$errform{'errCF'}."</span>"; } 
print"</li></ol>
          <input type=\"submit\" name=\"reg2\"  value=\"Avanti\" />
        </form>
    </div>
";}

sub showSchedaTre{
  my %errform= @_;
  print"
  <div id=\"content\" >
    <h1>Registrazione</h1>
        <h1> Contatti </h1>
        <form action=\"form_reg3.cgi\" method=\"post\">
            <ol>
                <li><label>Indirizzo</label><input type=\"text\" name=\"indirizzo\"  value=\"\" /></li>
                <li><label>Città</label><input type=\"text\" name=\"citta\"  value=\"\" /></li>
                <li><label>Telefono</label><input type=\"text\" name=\"tel\"  value=\"\" />";
if($errform{'errTelefono'} ne undef){ print "<span>".$errform{'errTelefono'}."</span>"; }           
print"</li></ol>
          <input type=\"submit\" name=\"reg3\"  value=\"Avanti\" />
        </form>
    </div>
";}

sub showSchedaQuattro{
  my %errform= @_;
  print"
  <div id=\"content\" >
    <h1>Registrazione</h1>
        <h1> Metodo di pagamento </h1>
        <form action=\"form_reg4.cgi\" method=\"post\">
            <ol>
                <li>Tipo di carta di credito <select name=\"tipocarta\" id=\"tipocarta\" >                                              
                        <option selected=\"selected\">Visa</option>
                        <option>Mastercard</option>
                        <option>American Express</option>
                 </select> </li>
                <li><label>Numero carta</label><input type=\"text\" name=\"ncarta\"  value=\"\" />";
if($errform{'errCarta'} ne undef){ print "<span>".$errform{'errCarta'}."</span>"; }  
print"</li>
      </ol>
          <input type=\"submit\" name=\"reg4\"  value=\"Registati\" />
        </form>
    </div>
";}


1;

# Questo file contiene subroutine per la gestione delle sessioni 