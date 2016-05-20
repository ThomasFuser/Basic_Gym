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

# funzione di stampa dell'inizio di una pagina html ( meta +logo Basic Gym )

sub start_html {
  my @pagina=@_;

print "Content-Type: text/html\n\n";
print
    "
    <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
    <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"it\" lang=\"it\">
    <head>
    <title> Home - Basic Gym </title>
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
    <meta name=\"title\" content=\"Basic Gym - Home\" />
    <meta name=\"description\" content=\"new offerte e descrizione della palestra\" />
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
                <h1><a href=\"../index.html\"> <span xml:lang=\"en\">BASIC GYM</span> </a> </h1>
            </div>
            <div class=\"header-right\">
                <label for=\"open\">
                    <span class=\"hidden-desktop\"></span>
                </label>";
nav(@pagina);
               
print"</div></div></div>";
    path(@pagina);
}
# funzione di stampa del footer
sub end_html {
  print"
  <div id=\"footer\">

          <p>
              <span xml:lang=\"en\">Basic Gym</span> - Via delle Acace 9, 31036, Casteminio di Resana - p. iva 02987250125
          </p>
              <div id=\"valid\"><img class=\"imgValidCode\" src=\"../images/vcss-blue.png\" alt=\"valid-CSS\"/>
              <img class=\"imgValidCode\" src=\"../images/valid-xhtml10.png\" alt=\"valid-xhtml 1.0\"/></div>
              <a href=\"amministratore/login.html\" id=\"LogAmm\" tabindex=\"-1\">Admin Login</a>  <!--non so come funziona il tabindex (Thomas)-->


  </div>
  </body>
  </html>
" ;
}

sub path{
 my @pathparam = @_;
  print " <div id=\"path\">
       <p>Ti trovi in:";
  if("@pathparam" eq "home") {
    print "<span xml:lang=\"en\"> <a href=\"index.html\"> Home </a> </span>";}
    if("@pathparam" eq "registrazione") {
    print "<span xml:lang=\"en\"> <a href=\"index.html\"> Home </a> </span> &gt; Registrati";}
 if("@pathparam" eq "login") {
    print "<span xml:lang=\"en\"> <a href=\"index.html\"> Home </a> </span> &gt; <span xml:lang=\"en\">Login</span>";}
  if("@pathparam" eq "staff") {
    print "<span xml:lang=\"en\"> <a href=\"index.html\"> Home </a> </span> &gt; <span xml:lang=\"en\">Staff</span>";}

 print"</p></div>";
}
sub nav{
  my @navparam=@_;
  my $session = CGI::Session->load();
  
      print"    <div id=\"nav\"> <a "; 
                    if(@navparam eq "home") {print "class=\"not-active\"";} print ">Home</a>";
      print"<a href=\"../corsi.html\">";
                    if(@navparam eq "corsi"){print "class=\"not-active\"";};  print "Corsi</a>";
      print"<a href=\"../prezzi.html\">";
                    if(@navparam eq "prezzi"){print "class=\"not-active\"";};  print "Prezzi</a>";
      print"<a href=\"../staff.html\">";
                    if(@navparam eq "staff"){print "class=\"not-active\"";};  print "Staff</a>";            
      print"<a href=\"../orari.html\">";
                    if(@navparam eq "orari"){print "class=\"not-active\"";};  print "Orari</a>";
  if($session->param("username") eq undef){
      print"<a href=\"../login.html\">";
                    if(@navparam eq "login"){print "class=\"not-active\"";};  print "Accedi</a>";
      print"<a href=\"../registrati.html\">";
                    if(@navparam eq "registrazione"){print "class=\"not-active\"";};  print "Registrati </a>";

  }
  print "</div>";

}

#funzione di stampa del menu corretto per ogni pagina (pagina passata come parametro)
#+ controllo di sessione per stampa menu utente loggato e admin
#sub stampa_menu{}

#stampa del breadcrumb corretto per ogni pagina (pagina passata come parametro)
#sub stampa_path{}
1;