#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use Pod::Usage qw( pod2usage );
use Time::Piece;
use My::Schema;

my ( $id, $status ) = @ARGV;
pod2usage( "ERROR: Not enough arguments" ) unless $id && $status;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $run_rs = $schema->resultset( 'Run' );
my $run = $run_rs->find( $id );
$run->update({
    end => gmtime->strftime( '%FT%TZ' ),
    status => $status,
});

__END__

=head1 SYNOPSIS

    end-run.pl <id> <status>
