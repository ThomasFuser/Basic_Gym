#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content_admin;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use CGI::Session;




util::html_util::start_html("Prezzi modificabili");
util::html_content_admin::stampaPrezziModificabili();
util::html_util::end_html();
