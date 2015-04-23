#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my @jobs = $schema->resultset( 'Job' )->all;
for my $job ( @jobs ) {
    say join ": ", $job->type, $job->name;
}
