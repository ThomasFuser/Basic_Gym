#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;


util::html_util::start_html("Staff", "Staff");
util::html_content::stampaStaff();
util::html_util::end_html();
