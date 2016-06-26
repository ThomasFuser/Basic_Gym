#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;

use util::html_util;
use util::db_util;

my $q = new CGI;
my $session = CGI::Session->load();


if(!($session->is_empty())) { #HO LA SESSIONE APERTA
  print"Location:index.cgi\n\n";
}

else{ # NON HO LA SESSIONE APERTA
      if($q->param('accedi')){

        my $username = $q->param('username');
        my $password = $q->param('password');

        my $doc = XML::LibXML->new()->parse_file('../data/admin.xml');
        if ($doc->findnodes("admin[id/text()='$username' and pw/text()='$password']")->size eq 1) {
           my $session = new CGI::Session(undef, $q, {Directory=>File::Spec->tmpdir});
           #my $session = new CGI::Session();
           $session->expire('60m');
           $session->param('username', $username);
           print $session->header(-location=>"index.cgi");
        }
        else{

          showForm("Nome utente o password non corretti.");
        }
    }
  else { # form
     showForm('');
  }
}

sub showForm{

  my $error = $_[0];
  util::html_util::start_html('Accesso amministratore', 'Accesso amministratore');


  print "<div id=\"content\" class='forms'>
          
           ";



  print " <h1>Accesso amministratore</h1><form onsubmit=\"return checkLogin()\" id=\"login\" action=\"login_admin.cgi\" method=\"post\">";
                if ($error ne '') {print" <span class=\"erroreForm\" >".$error."</span>";}
	print"
                 <fieldset>
                    <label id=\"user\" for=\"username\">Username</label>
                    <input id=\"username\" type=\"text\" name=\"username\" size=\"25\"/>
                    <label id=\"pass\" for=\"password\">Password</label>
                    <input id=\"password\" type=\"password\" name=\"password\" size=\"25\"/>
                    <input id='submit' type=\"submit\" name=\"accedi\" value=\"Accedi\" class=\"submit_button\" />
                 </fieldset>
              </form>
           ";

  print "</div>";

  util::html_util::end_html();
}

1;
