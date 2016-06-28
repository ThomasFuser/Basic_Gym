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
our @EXPORT = qw(showSchedaUno showSchedaDue showSchedaTre showSchedaQuattro dati_formUno dati_formDue dati_formTre dati_formQuattro);


package util::base_util;

sub showSchedaUno{
  my %datiForm= @_;
  print"
  <div id=\"content\" class=\"forms\">
  
  <h1>Registrazione</h1>
     <script type=\"text/javascript\" src=\"../js/registrationLong.js\"></script>
        <h2> Dati di accesso </h2>
        <form action=\"form_reg1.cgi\" method=\"post\">
            <ol>
                <li><label><span>Email</span></label><input type=\"text\" name=\"email\" value=\"".$datiForm{'email'}."\" id=\"email_user\" onblur=\"checkEmail()\" />";
                if($datiForm{'errEmail'} ne undef){ print "<span class=\"erroreForm\" >".$datiForm{'errEmail'}."</span>"; }

print"</li><li><label><span lang=\"en\">Password</span></label><input type=\"password\" name=\"password\"  value=\"".$datiForm{'password'}."\" id=\"password_user\" onblur=\"checkPassword()\" />";
if($datiForm{'errPw'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errPw'}."</span>"; }

print"</li><li><label>Ripeti <span lang=\"en\">password</span></label><input type=\"password\" name=\"password_repeat\"  value=\"".$datiForm{'ripetipassword'}."\" id=\"password_user_repeat\" onblur=\"checkPasswordRepeat()\" />";      
 if($datiForm{'errPwRep'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errPwRep'}."</span>"; }
               
print"</li></ol> 
        <input type=\"submit\" name=\"reg1\"  value=\"Avanti\" class=\"submit_button\"/>
             
        </form>

    </div>
   
}
";}


sub showSchedaDue{
  my %datiForm= @_;

  print"
  <div id=\"content\" class=\"forms\">
    <h1>Registrazione</h1>
        <script type=\"text/javascript\" src=\"../js/registrationLong.js\"></script>
        <h2> Dati personali </h2>
        <form action=\"form_reg2.cgi\" method=\"post\">
             <input type=\"hidden\" name=\"email\" value=\"".$datiForm{'email'}."\"  />
             <input type=\"hidden\" name=\"password\"  value=\"".$datiForm{'password'}."\" />

            <ol>                
                <li><label>Nome</label><input type=\"text\" name=\"nome\" id=\"name_user\"  value=\"".$datiForm{'nome'}."\" onblur=\"checkWord(this, 'nome')\" />";
  if($datiForm{'errNome'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errNome'}."</span>"; }


  print"</li>
                <li><label>Cognome</label> <input type=\"text\" name=\"cognome\" id=\"surname_user\"  value=\"".$datiForm{'cognome'}."\" onblur=\"checkWord(this, 'cognome')\" />";
  if($datiForm{'errCognome'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errCognome'}."</span>"; }
  print "</li>
               <li> Genere<select name=\"genere\" id=\"genere\" >                                              
                        <option selected=\"selected\">M</option>
                        <option>F</option>
                 </select> </li>
                <li  class=\"dateinput\"><label>Data di nascita</label>
                      <input type=\"text\" name=\"gg\" value=\"".$datiForm{'gg'}."\" onblur=\"check_giorno(this, 'giorno')\"/>  
                      <input type=\"text\" name=\"mese\" value=\"".$datiForm{'mese'}."\" onblur=\"check_mese(this, 'mese')\"/>  
                      <input id=\"yearinput\" type=\"text\" name=\"anno\" value=\"".$datiForm{'anno'}."\" onblur=\"check_anno(this, 'anno')\"/>";
    if($datiForm{'errDataNascita'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errDataNascita'}."</span>"; }                  
  print "</li>

                <li><label>Professione</label><input type=\"text\" name=\"professione\"  id=\"job_user\"  value=\"".$datiForm{'professione'}."\" onblur=\"checkPhrase(this, 'professione')\" /></li>
                <li><label>Codice fiscale</label><input type=\"text\" name=\"CF\" id=\"codicefiscale_user\" value=\"".$datiForm{'CF'}."\" onblur=\"checkCodiceFiscale()\" />";
  if($datiForm{'errCF'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errCF'}."</span>"; } 
print"</li></ol>
          <input type=\"submit\" name=\"reg2\"  value=\"Avanti\" class=\"submit_button\" />
        </form>
    </div>
";}

sub showSchedaTre{
  my %datiForm= @_;
  print"
  <div id=\"content\" class=\"forms\">
    <h1>Registrazione</h1>
    <script type=\"text/javascript\" src=\"../js/registrationLong.js\"></script>
        <h2> Contatti </h2>
        <form action=\"form_reg3.cgi\" method=\"post\">
             <input type=\"hidden\" name=\"email\" value=\"".$datiForm{'email'}."\" />
             <input type=\"hidden\" name=\"password\"  value=\"".$datiForm{'password'}."\" />

             <input type=\"hidden\" name=\"nome\" value=\"".$datiForm{'nome'}."\" />
             <input type=\"hidden\" name=\"cognome\"  value=\"".$datiForm{'cognome'}."\" />
             <input type=\"hidden\" name=\"CF\"  value=\"".$datiForm{'CF'}."\" />
             <input type=\"hidden\" name=\"genere\" value=\"".$datiForm{'genere'}."\" />
             <input type=\"hidden\" name=\"gg\" value=\"".$datiForm{'gg'}."\" />
             <input type=\"hidden\" name=\"mese\"  value=\"".$datiForm{'mese'}."\" />
             <input type=\"hidden\" name=\"anno\" value=\"".$datiForm{'anno'}."\" />
             <input type=\"hidden\" name=\"professione\"  value=\"".$datiForm{'professione'}."\" />

            <ol>
                <li><label>Indirizzo</label><input type=\"text\" name=\"indirizzo\" id=\"address_user\"  value=\"".$datiForm{'indirizzo'}."\"  onblur=\"checkPhrase(this, 'indirizzo')\" /></li>
                <li><label>Città</label><input type=\"text\" name=\"citta\" id=\"city_user\" value=\"".$datiForm{'citta'}."\" onblur=\"checkPhrase(this, 'città')\"/></li>
                <li><label>Telefono</label><input type=\"text\" name=\"tel\" id=\"phone_user\" value=\"".$datiForm{'tel'}."\" onblur=\"checkPhoneNumber()\" />";
if($datiForm{'errTelefono'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errTelefono'}."</span>"; }           
print"</li></ol>
          <input type=\"submit\" name=\"reg3\"  value=\"Avanti\" class=\"submit_button\"/>
        </form>
    </div>
";}

sub showSchedaQuattro{
  my %datiForm= @_;


 
       

  print"
  <div id=\"content\" class=\"forms\">
    <h1>Registrazione</h1>
    <script type=\"text/javascript\" src=\"../js/registrationLong.js\"></script>
        <h2> Metodo di pagamento </h2>
        <form action=\"form_reg4.cgi\" method=\"post\">
             <input type=\"hidden\" name=\"email\" value=\"".$datiForm{'email'}."\" />
             <input type=\"hidden\" name=\"password\"  value=\"".$datiForm{'password'}."\" />

             <input type=\"hidden\" name=\"nome\" value=\"".$datiForm{'nome'}."\" />
             <input type=\"hidden\" name=\"cognome\"  value=\"".$datiForm{'cognome'}."\" />
             <input type=\"hidden\" name=\"CF\"  value=\"".$datiForm{'CF'}."\" />
             <input type=\"hidden\" name=\"genere\" value=\"".$datiForm{'genere'}."\" />
             <input type=\"hidden\" name=\"gg\" value=\"".$datiForm{'gg'}."\" />
             <input type=\"hidden\" name=\"mese\"  value=\"".$datiForm{'mese'}."\" />
             <input type=\"hidden\" name=\"anno\" value=\"".$datiForm{'anno'}."\" />
             <input type=\"hidden\" name=\"professione\"  value=\"".$datiForm{'professione'}."\" />

             <input type=\"hidden\" name=\"indirizzo\" value=\"".$datiForm{'indirizzo'}."\" />
             <input type=\"hidden\" name=\"citta\"  value=\"".$datiForm{'citta'}."\" />
             <input type=\"hidden\" name=\"tel\" value=\"".$datiForm{'tel'}."\" />

            <ol>
                <li>Tipo di carta di credito <select name=\"tipoCarta\" id=\"tipocarta\" >                                              
                        <option selected=\"selected\">Visa</option>
                        <option>Mastercard</option>
                        <option>American Express</option>
                 </select> </li>
                <li><label>Numero carta</label><input type=\"text\" name=\"ncarta\" id=\"numbercard_user\"  value=\"".$datiForm{'ncarta'}."\" onblur=\"checkNumberCard()\"/>";
if($datiForm{'errCarta'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errCarta'}."</span>"; }  
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
  if($datiForm{'errScadenzaCarta'} ne undef){ print "<span class=\"erroreForm\">".$datiForm{'errScadenzaCarta'}."</span>"; }  

  print"</li>
      </ol>
          <input type=\"submit\" name=\"reg4\"  value=\"Registati\" class=\"submit_button\"/>
        </form>
    </div>
";}



1;

#Questo file contiene subroutine per la stampa dei form registrazione 