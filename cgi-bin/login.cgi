#!/usr/bin/perl
# use module
use util::html_util;
use util::html_content;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI;
use utf8;
binmode STDIN, ":encoding(utf8)";
binmode STDOUT, ":encoding(utf8)";
use Encode;

#my $cgi = new CGI;
#my $sid = $cgi->cookie('CGISESSID') || $cgi->param('CGISESSID') || undef;
#my $session = load CGI::Session();
#my $err = $session->param("errore");

my $q = new CGI;
my $session = CGI::Session->load();
 # Sessione già aperta
     if($q->param('accedi')) { # submit form
      
      my $username = $q->param('username');
      my $password = $q->param('password');
      print "Content-Type: text/html\n\n";

      print "$username";
      print "$password";
    }
     
else{

util::html_util::start_html("Accedi");
print"
      <h2 id=\"h2Login\">Accedi</h2>
      		
          <form  id=\"login\" action=\"login.cgi\" method=\"get\">
                  <fieldset>
                     <label id=\"user\" for=\"username\">Username</label>
                     <input id=\"username\" type=\"text\" name=\"username\" size=\"25\"/>
                     <label id=\"pass\" for=\"password\">Password</label>
                     <input id=\"password\" type=\"password\" name=\"password\" size=\"25\"/>
                     <input id='submit' type=\"submit\" name=\"accedi\" value=\"Accedi\" />
                  </fieldset>
               </form> ";
    }
util::html_util::end_html();
    1;





          
#}#else{
  #my $nome = $session->param("utenteNome");
	#print
	#{}"<h2 id=\"h2Login\">Errore</h2>
	#<p id=\"erroreLogin\">Sei già loggato come $nome.
	#	Se non sei tu procedi al <a href=\"Logout.cgi\">logout</a> e rieffettua il login con il tuo account.</p>";
#}

#util::MyLib::foot_pages();
