#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my @runs = $schema->resultset( 'Run' )->all;
for my $run ( @runs ) {
    say sprintf "%s (%s): %s (%s)", $run->job->name, $run->job->type, $run->status, $run->start;
}
