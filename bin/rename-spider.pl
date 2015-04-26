#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( :5.10 );
use Pod::Usage qw( pod2usage );
use Time::Piece;
use My::Schema;

my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
my $job_rs = $schema->resultset( 'Job' );
my $spider_jobs = $job_rs->search({
    type => 'Qar::Spider',
});
$spider_jobs->update({
    type => 'Boa::ETL',
});
