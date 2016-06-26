#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use util::db_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Profilo");
my $session = CGI::Session->load();
if($session->param("username") ne undef ){
	if($session->param("username") ne "admin"){ 	
		util::html_content::stampaProfiloUtente($session->param("username"));
	
}
}


util::html_util::end_html();
