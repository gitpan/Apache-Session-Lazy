package Apache::Session::Lazy;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.01';

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

Apache::Session::Lazy - Perl extension for opening Apache:Sessions when needed.

=head1 SYNOPSIS

  use Apache::Session::Lazy;
  my %session;
  
  #make a fresh session for a first-time visitor
  tie %session, 'Apache::Session::Lazy', 'Apache::Session::MySQL';


=head1 DESCRIPTION

Module is used to open Sessions only after they are either modified or examined.  Usefull for
when a programmer wants to automatically open a session at the beggining of a process, but doesn't
want to waste disk space or retrieval time, unless the session is actually used.

Just add 'Apache::Session::Lazy' after tie %session, and before the interface
you want to use.  Easy as that.  From that day on: It won't open the session until you mess with
them.


=head1 AUTHOR

Gyan Kapur <lt>gkapur@inboxusa.com<gt>
With help from merlyn.

=head1 SEE ALSO

L<perl>.

=cut
