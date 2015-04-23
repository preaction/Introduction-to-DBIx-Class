#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use Pod::Usage qw( pod2usage );
use My::Schema;

my ( $type, $name ) = @ARGV;
pod2usage( "ERROR: Not enough arguments" ) unless $type && $name;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $job_rs = $schema->resultset( 'Job' );
$job_rs->create({
    type => $type,
    name => $name,
});

__END__

=head1 SYNOPSIS

    add-job.pl <type> <name>
