#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("<a href=\"prezzi.cgi\">Prezzi</a>  &gt; Aggiungi un nuovo abbonamento", "Crea Abbonamento");
util::html_content_admin::creaAbbonamento();
util::html_util::end_html();
