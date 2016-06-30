#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(start_html end_html);


  package util::html_util;
#Questo file contiene le sobroutine per la stampa dell'HTML 

sub start_html {
  my @pagina=@_;

print "Content-Type: text/html\n\n";
print
    "
    <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
    <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"it\" lang=\"it\">
    <head>
    <title> ".$pagina[1]." - Basic Gym </title>
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
    <meta name=\"title\" content=\"".$pagina[1]." - Basic Gym \" />
    <meta name=\"description\" content=\"descrizione della palestra, orari e prezzi\" />
    <meta name=\"keywords\" content=\"offerte, news, basic, gym, amici, palestra, lezioni, muscoli, corpo, tonificare, sport, abbonamento\" />
    <meta name=\"author\" content=\"gruppo tecweb\" />
    <meta name=\"language\" content=\"italian it\" />
    <link href=\"../css/style.css\" rel=\"stylesheet\" type=\"text/css\"/>
   
    <link rel=\"stylesheet\"  href=\"../css/print.css\" type=\"text/css\" media=\"print\"/>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>
    <link rel=\"SHORTCUT ICON\" href=\"../images/BasicGym_logo.png\" />
</head>
<body>
  <a class=\"skip-main\" href=\"#content\"><span xml:lang=\"en\">Skip to main content</span></a>
<!-- HEADER  -->
<div class=\"clearfix header\">
    <div class=\"container\">
  
            <div class=\"header-left\">
                <h1><a ";
if($pagina[0] eq "Home"){print " class=\"not-active\" ";}
print "href=\"../index.html\" id=\"LinkLogo\"> <span xml:lang=\"en\">BASIC GYM</span> </a> </h1>
            </div>
            <div class=\"header-right\">
                <label for=\"open\">
                    <span class=\"hidden-desktop\"></span>
                </label>";
nav($pagina[0]);
               
print"</div></div></div>";
    path($pagina[0]);
}
sub end_html {
  print"
  <div id=\"footer\">


          <p>
              <span xml:lang=\"en\">Basic Gym</span> - Via delle Acace 9, 35143, Padova- p. iva 02987250125
          </p>";
   my $session = CGI::Session->load();
   if($session->param("username") eq undef) {
         print" <a href=\"login_admin.cgi\"> Accesso amministratore</a>";}
            print"  <div id=\"valid\"><img class=\"imgValidCode\" src=\"../images/vcss-blue.png\" alt=\"valid-CSS\"/>
              <img class=\"imgValidCode\" src=\"../images/valid-xhtml10.png\" alt=\"valid-xhtml 1.0\"/></div>
          
  </div>
  </body>
  </html>
" ;
}








sub path{
 my @pathparam = @_;
  print " <div id=\"path\">
       <p>Ti trovi in:";
  if("@pathparam" eq "Home") {
  #  print "<span xml:lang=\"en\"> <a href=\"index.cgi\"> Home </a> </span>";}
     print "<span xml:lang=\"en\"> Home </span>";}
  else{
    print "<span xml:lang=\"en\"> <a href=\"index.cgi\"> Home </a> </span> &gt; <span xml:lang=\"en\"> @pathparam[0] </span>";}

 print"</p></div>";
}



sub nav{
  my @navparam=@_;
  my $session = CGI::Session->load();
      print"<input type=\"checkbox\" name=\"\" id=\"open\"/> ";
      print"    <div id=\"nav\">"; 
       if(@navparam[0] eq "Home") { print"<a class=\"not-active\">Home</a>"; }
       else{print"<a href=\"index.cgi\">Home</a>";}

       if(@navparam[0] eq "Corsi"){ print"<a class=\"not-active\">Corsi</a>"; }
       else{print"<a href=\"corsi.cgi\">Corsi</a>";}

       if(@navparam[0] eq "Prezzi"){ print"<a class=\"not-active\">Prezzi</a>"; }
       else{print"<a href=\"prezzi.cgi\">Prezzi</a>";}

       if(@navparam[0] eq "Staff"){ print"<a class=\"not-active\">Staff</a>"; }
       else{print"<a href=\"staff.cgi\">Staff</a>";}
      
       if(@navparam[0] eq "Orari"){ print"<a class=\"not-active\">Orari</a>"; }
       else{print"<a href=\"orari.cgi\">Orari</a>";}
        
     

  if($session->param("username") eq undef){
    
    if(@navparam[0] eq "Accedi"){ print"<a class=\"not-active\">Accedi</a>"; }
       else{print"<a href=\"login.cgi\">Accedi</a>";}

    if(@navparam[0] eq "Registrazione"){ print" <a class=\"not-active\">Registrati</a>"; }
       else{print"<a href=\"registrazione.cgi\">Registrati </a>";}

  }
  elsif($session->param("username") ne "admin"){

     if(@navparam[0] eq "Profilo"){ print"<a class=\"not-active\">Profilo</a>"; }
       else{print"<a href=\"utente.cgi\">Profilo </a>";}

     
      print"<a href=\"logout.cgi\">Esci</a>";

  }elsif($session->param("username") eq "admin"){
    print"<a href=\"logout.cgi\">Esci</a>";

  }
  print "</div>";

}


1;
