#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::base_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;



my $q = new CGI;
my $session = CGI::Session->load();


if(!($session->is_empty())) { #HO LA SESSIONE APERTA
  print"Location:index.cgi\n\n";
}


else{ # NON HO LA SESSIONE APERTA
     util::html_util::start_html("Registrazione");
     util::base_util::showSchedaUno();
     util::html_util::end_html();
 }