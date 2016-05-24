#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Profilo");
my $session = CGI::Session->load();
if($session->param("username") ne undef ){
	if($session->param("username") ne "admin"){ 	
		util::html_content::stampaProfiloUtente();
	}
}


util::html_util::end_html();
