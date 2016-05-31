#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);
use util::html_content;


use Exporter qw(import);
our @EXPORT = qw(salva_dati_registrazione showSchedaUno showSchedaDue showSchedaTre showSchedaQuattro dati_formUno dati_formDue dati_formTre dati_formQuattro);


package util::base_util;

sub showSchedaUno{
  my %errform= @_;
	print"
  <div id=\"content\" >
  <h1>Registrazione</h1>
        <h2> Dati di accesso </h2>
        <form action=\"form_reg1.cgi\" method=\"post\">
            <ol>
                <li><label><span>Email</span></label><input type=\"text\" name=\"email\" value=\"".$errform{'mail'}."\" />";
                if($errform{'errEmail'} ne undef){ print "<span>".$errform{'errEmail'}."</span>"; }

print"</li><li><label><span lang=\"en\">Password</span></label><input type=\"text\" name=\"password\"  value=\"".$errform{'password'}."\" />";
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
                
                <li><label>Nome</label><input type=\"text\" name=\"nome\"  value=\"".$errform{'nome'}."\" />";
  if($errform{'errNome'} ne undef){ print "<span>".$errform{'errNome'}."</span>"; }


  print"</li>
                <li><label>Cognome</label><input type=\"text\" name=\"cognome\"  value=\"".$errform{'cognome'}."\" />";
  if($errform{'errCognome'} ne undef){ print "<span>".$errform{'errCognome'}."</span>"; }
  print "</li>
                Genere<select name=\"genere\" id=\"genere\" >                                              
                        <option selected=\"selected\">M</option>
                        <option>F</option>
                 </select> </li>
                <li><label>Data di nascita</label><input type=\"text\" name=\"gg\"  value=\"".$errform{'gg'}."\" />  \-
                      <input type=\"text\" name=\"mese\"  value=\"".$errform{'mese'}."\" />  \-<input type=\"text\" name=\"anno\"  value=\"".$errform{'anno'}."\" />";
    if($errform{'errDataNascita'} ne undef){ print "<span>".$errform{'errDataNascita'}."</span>"; }                  
  print "</li>

                <li><label>Professione</label><input type=\"text\" name=\"professione\"  value=\"".$errform{'professione'}."\" /></li>
                <li><label>Codice fiscale</label><input type=\"text\" name=\"CF\"  value=\"".$errform{'CF'}."\" />";
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
                <li><label>Indirizzo</label><input type=\"text\" name=\"indirizzo\"  value=\"".$errform{'indirizzo'}."\" /></li>
                <li><label>Città</label><input type=\"text\" name=\"citta\"  value=\"".$errform{'citta'}."\" /></li>
                <li><label>Telefono</label><input type=\"text\" name=\"tel\"  value=\"".$errform{'tel'}."\" />";
if($errform{'errTelefono'} ne undef){ print "<span>".$errform{'errTelefono'}."</span>"; }           
print"</li></ol>
          <input type=\"submit\" name=\"reg3\"  value=\"Avanti\" />
        </form>
    </div>
";}

sub showSchedaQuattro{
  my %errform= @_;
  my $prova="ciaociao";
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
                <li><label>Numero carta</label><input type=\"text\" name=\"ncarta\"  value=\"".$errform{'ncarta'}."\"/>";
if($errform{'errCarta'} ne undef){ print "<span>".$errform{'errCarta'}."</span>"; }  
print"</li>
      <li>Scadenza <select name=\"mese_scadenza\" id=\"mese_scadenza\">                                              
                        <option selected=\"selected\">1</option>
                        <option>2</option>
                        <option>3</option>
                        <option>4</option>
                        <option>6</option>
                        <option>7</option>
                        <option>8</option>
                        <option>9</option>
                        <option>10</option>
                        <option>11</option>
                        <option>12</option>
  </select> <select name=\"anno_scadenza\" id=\"anno_scadenza\" >                                              
                        <option selected=\"selected\">2016</option>
                        <option>2017</option>
                        <option>2018</option>
                        <option>2019</option>
                        <option>2020</option>
                        <option>2021</option>
                        <option>2022</option>
                        <option>2023</option>
                        <option>2025</option>
                        <option>2026</option>
                        <option>2027</option>
                        <option>2028</option>
                        <option>2029</option>
                        <option>2030</option>
                        <option>2031</option>
                        <option>2032</option>
                        <option>2033</option>
                        <option>2034</option>
                        <option>2035</option>
                        <option>2036</option>
                        <option>2037</option>
  </select>";
  if($errform{'errScadenzaCarta'} ne undef){ print "<span>".$errform{'errScadenzaCarta'}."</span>"; }  

  print"</li>
      </ol>
          <input type=\"submit\" name=\"reg4\"  value=\"Registati\" />
        </form>
    </div>
";}



sub salva_dati_registrazione{

   my $doc = util::db_util::caricamentoLibXMLRegistrazione();
   my $email = util::html_content::enc($doc->findnodes("//registrazione/email"));
   my $password = util::html_content::enc($doc->findnodes("//registrazione/password"));
   my $nome = util::html_content::enc($doc->findnodes("//registrazione/nome"));
   my $cognome = util::html_content::enc($doc->findnodes("//registrazione/cognome"));
   my $genere = util::html_content::enc($doc->findnodes("//registrazione/genere"));
   my $CF = util::html_content::enc($doc->findnodes("//registrazione/cf"));
   my $datanascita= util::html_content::enc($doc->findnodes("//registrazione/datanascita"));
   my $indirizzo = util::html_content::enc($doc->findnodes("//registrazione/indirizzo"));
   my $citta = util::html_content::enc($doc->findnodes("//registrazione/citta"));
   my $tel = util::html_content::enc($doc->findnodes("//registrazione/tel"));
   my $tipocarta= util::html_content::enc($doc->findnodes("//registrazione/tipocarta"));
   my $ncarta = util::html_content::enc($doc->findnodes("//registrazione/ncarta"));
   
        

}


1;

# Questo file contiene subroutine per la gestione delle sessioni 