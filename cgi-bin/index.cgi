#!/usr/bin/perl
# use module
use util::MyLib;
use util::Pinco;
use util::html_util;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;

#print "Content-Type: text/html\n\n";



util::html_util::start_html("Home");
util::Pinco::center_home();
util::html_util::end_html();
