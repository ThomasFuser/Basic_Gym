#!/usr/bin/perl
# use module
use util::html_content;
use util::html_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;


util::html_util::start_html("Home");
util::html_content::stampaIndex();
util::html_util::end_html();
