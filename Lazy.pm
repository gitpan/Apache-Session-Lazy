package Apache::Session::Lazy;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.02';

# Thanks for the perltie info, Merlyn.

sub TIEHASH {
  my $class = shift;
  require $_[0];
  bless [@_], $class; # remember real args
}

sub FETCH {
  ## DO NOT USE shift HERE
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->FETCH($_[1]);
}

sub STORE {
  ## DO NOT USE shift HERE
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->STORE($_[1], $_[2]);
}

sub DELETE   {
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->DELETE($_[1]);
}

sub CLEAR {

  if ( defined $_[0]->[1] && $_[0]->[1] ) {  # Why Clear An Uncreated Sesion?
    $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
    $_[0]->CLEAR();
  }

}

sub EXISTS {
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->EXISTS($_[1]);
}

sub FIRSTKEY {
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->FIRSTKEY();
}

sub NEXTKEY {
  $_[0] = delete($_[0]->[0])->TIEHASH(@{$_[0]});
  $_[0]->NEXTKEY();
}

sub DESTROY {
    # Why destroy something we haven't created?
}

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Apache::Session::Lazy - Perl extension for opening Apache::Sessions on first read/write access.

=head1 SYNOPSIS

See L<Apache::Session>

=head1 DESCRIPTION

=head2 The Module

Apache::Session is a persistence framework which is particularly useful
for tracking session data between httpd requests.  Apache::Session is
designed to work with Apache and mod_perl, but it should work under
CGI and other web servers, and it also works outside of a web server
altogether.

Apache::Session::Lazy extends Apache::Session by opening Sessions only after they are either
modified or examined (first read or write access to the tied hash.)  It should provide
transparent access to the session hash at all times.

=head2 Uses Of Apache::Session::Lazy

Apache::Session::Lazy was designed to allow Apache::Session to achieve two objectives:

a) Prevent unnecessary work in accessing the data store, if a session is not going to be touched.

b) Allow for session locking to exist for the least possible amount of time, so that other
access to the same session is possible.

Just add 'Apache::Session::Lazy' after tie %session, and before the interface
you want to use.  Easy as that.  From that day on: It won't open the session until you mess with
them.

=head1 INTERFACE

The interface for Apache::Session::Lazy is only different for tieing the Session.  You must
an additional parameter after tie %session. So the new tie will look like-

Get a new session using DBI:

 tie %session, 'Apache::Session::Lazy', 'Apache::Session::MySQL', undef,
    { DataSource => 'dbi:mysql:sessions' };
    
Restore an old session from the database:

 tie %session, 'Apache::Session::Lazy', 'Apache::Session::MySQL', $session_id,
    { DataSource => 'dbi:mysql:sessions' };

=head1 AUTHOR

Gyan Kapur <gkapur@inboxusa.com>

With help from merlyn.

=head1 SEE ALSO

L<Apache::Session>,L<Apache::SessionX>, 
http://groups.yahoo.com/group/modperl/message/46287

=cut
