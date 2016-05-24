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
  if(session->param('username') != "admin"){

  }
}

else{ # NON HO LA SESSIONE APERTA
      prova('');
      if($q->param('accedi')){

        my $username = $q->param('username');
        my $password = $q->param('password');

        my $doc = XML::LibXML->new()->parse_file('../data/utenti.xml');
        if ($doc->findnodes("utenti/utente/dati_accesso[mail/text()='$username' and password/text()='$password']")->size eq 1) {

           my $session = new CGI::Session(undef, $q, {Directory=>File::Spec->tmpdir});
           #my $session = new CGI::Session();
           $session->expire('60m');
           $session->param('username', $username);
           #print $session->header(-location=>"private-menu-cibi.cgi");
        }
        else{
          print "ERRORE";
          prova("dati errati");
        }

    }
    #else {prova('');}
}


sub prova {

  util::html_util::start_html('Accedi');

  print "</p>";

  print "<div class='form'>
           <h3>Login</h3>
           ";

  print "<form onsubmit=\"return checkLogin()\" id=\"login\" action=\"login.cgi\" method=\"post\">
                 <fieldset>
                    <label id=\"user\" for=\"username\">Username</label>
                    <input id=\"username\" type=\"text\" name=\"username\" size=\"25\"/>
                    <label id=\"pass\" for=\"password\">Password</label>
                    <input id=\"password\" type=\"password\" name=\"password\" size=\"25\"/>
                    <input id='submit' type=\"submit\" name=\"accedi\" value=\"Accedi\" />
                 </fieldset>
              </form>
           ";

  print "</div>";

  util::html_util::end_html();
}

1;
