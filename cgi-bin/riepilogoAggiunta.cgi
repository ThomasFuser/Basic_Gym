#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Riepilogo inserimento nuovo abbonamento");
util::html_content_admin::riepilogoNuovoAbbonamento();
util::html_util::end_html();
