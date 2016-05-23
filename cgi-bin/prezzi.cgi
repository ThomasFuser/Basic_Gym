#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Prezzi");
my $session = CGI::Session->load();
if($session->param("username") eq undef){
 	util::html_content::stampaPrezzi();
}
#elsif($session->param("username") eq "admin"){

#}
#else{
#	html_util::html_content::stampaPrezziAcquistabili();
#}

util::html_util::end_html();
