#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Orari");
util::html_content::stampaOrario();
util::html_util::end_html();
