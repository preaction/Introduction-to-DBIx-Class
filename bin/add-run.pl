#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use Pod::Usage qw( pod2usage );
use Time::Piece;
use My::Schema;

my ( $type, $name ) = @ARGV;
pod2usage( "ERROR: Not enough arguments" ) unless $type && $name;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $run_rs = $schema->resultset( 'Run' );
my $run = $run_rs->create({
    start => gmtime->strftime( '%FT%TZ' ),
    status => 'running',
    job => {
        type => $type,
        name => $name,
    },
});
say "New Run ID: " . $run->id;

__END__

=head1 SYNOPSIS

    add-run.pl <type> <name>
