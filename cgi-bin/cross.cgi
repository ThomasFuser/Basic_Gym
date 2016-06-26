#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("<a href=\"corsi.cgi\"> Corsi </a>  &gt; <span lang=\"en\">Cross</span>", "Cross-Corsi");
util::html_content::stampaCross();
util::html_util::end_html();
