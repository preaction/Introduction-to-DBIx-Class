#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $job_rs = $schema->resultset( 'Job' );
my $extract_job_rs = $job_rs->search({ type => 'Qar::Extract' });
my $int_rate_extract_job_rs
    = $extract_job_rs->search({
        name => { LIKE => 'int_rate_%' },
    });
while ( my $job = $int_rate_extract_job_rs->next ) {
    say join ": ", $job->type, $job->name;
}
