#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my @jobs = $schema->resultset( 'Job' )->all;
for my $job ( @jobs ) {
    if ( my $run = $job->latest_run ) {
        say sprintf '%s (%s): %s (%s)',
            $job->name, $job->type,
            $run->status, $run->start;
    }
    else {
        say sprintf '%s (%s): Never run',
            $job->name, $job->type;
    }
}
