#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Riepilogo modifica abbonamento");

util::html_content_admin::stampaRiepilogoModifica();


util::html_util::end_html();
