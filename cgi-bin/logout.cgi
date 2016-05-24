#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;

my $session = CGI::Session->load() or print "Location: login.cgi\n\n";
   $session->delete();

print "Location: ../public-html/index.html\n\n";

exit 0;
