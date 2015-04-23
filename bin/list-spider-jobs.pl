#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $job_rs = $schema->resultset( 'Job' );
my $spider_job_rs = $job_rs->search({ type => 'Qar::Spider' });
for my $job ( $spider_job_rs->all ) {
    say join ": ", $job->type, $job->name;
}
