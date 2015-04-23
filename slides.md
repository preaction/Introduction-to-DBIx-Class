# Introduction to DBIx::Class

------

# Data is hard

------

# Schemas are hard

---

# ETL Job Reporting Database
## Extract, Transform, Load

---

# Jobs writing data to databases

---

# We have Jobs
## `jobs`

* id
* type
* name

---

# Jobs have Runs
## `runs`

* id
* job_id
* start
* end
* status

---

# We have data Destinations
## `dest`

* id
* type
* name

---

# Runs write to Destinations
## `run_dest`

* run_id
* dest_id

---

# schema.png

------

# SQL is hard

---

```
>>> SELECT id, name FROM jobs WHERE type = "Qar::Extract";
id     name
-----  ------------------------------
1      int_rate_fixings_emea
2      int_rate_fixings_amrs
4      ccy_spot
```

---

```
>>> INSERT INTO jobs ( type, name )
..> VALUES ( "Qar::Ops", "Qar::Ops::WmrSpotRates" );
```

---

```
>>> UPDATE runs
..> SET status = "done"
..> WHERE id = 4
```

---

```
>>> SELECT runs.id AS run_id, jobs.name, runs.status
..> FROM runs
..> JOIN jobs ON jobs.id = runs.job_id
..> WHERE runs.status = "error";
run_id    name                            status
--------  ------------------------------  -------
3         int_rate_fixings_emea           error
4         bbg_fx_spot                     error
```
---

# Build a module

------

# DBIx::Class

------

# The Schema

---

# Entry Point

---

```perl
package My::Schema;
use base qw/DBIx::Class::Schema/;
# Load My::Schema::Result::* and My::Schema::Resultset::*
__PACKAGE__->load_namespaces;
1;
```

---

# Connect to the Database

```
my $schema = My::Schema->connect( 'dbi:SQLite:data.db' );
```

---

# Set Aside

------

# Result Classes

---

# Row in a Table

---

```perl
package My::Schema::Result::Job;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'jobs' );
```

---

# Declare Columns

---

```perl
__PACKAGE__->add_columns( qw( id type name ) );
```

---

# Declare Primary Key

---

```perl
__PACKAGE__->set_primary_key( 'id' );
```

---

# Job

```perl
package My::Schema::Result::Job;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'jobs' );
__PACKAGE__->add_columns( qw( id type name ) );
__PACKAGE__->set_primary_key( 'id' );
```

---

# Run

```perl
package My::Schema::Result::Run;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'runs' );
__PACKAGE__->add_columns( qw( id job_id start end status ) );
__PACKAGE__->set_primary_key( 'id' );
```

---

# Destination

```perl
package My::Schema::Result::Destination;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'dest' );
__PACKAGE__->add_columns( qw( id type name ) );
__PACKAGE__->set_primary_key( 'id' );
```
---

# Run Destinations

```perl
package My::Schema::Result::RunDestination;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'run_dest' );
__PACKAGE__->add_columns( qw( run_id dest_id ) );
```

------

# Resultsets
## (Queries)

---

# Query All Jobs

---

```perl
my $job_rs = $schema->resultset( 'Job' );
```
```
SELECT * FROM jobs
```

---

# Retrieve Results
## My::Schema::Result::Job objects

---

```perl
for my $job ( $job_rs->all ) {
    say join ": ", $job->type, $job->name;
}
```

---

```
$ perl bin/list-jobs.pl
Qar::Extract: int_rate_fixings_emea
Qar::Extract: int_rate_fixings_amrs
Qar::Spider: bbg_fx_spot
Qar::Extract: ccy_spot
```
---

# Search Jobs

---

```perl
my $extract_job_rs = $job_rs->search({
    type => 'Qar::Extract',
});
```
```
SELECT * FROM jobs
    WHERE type = 'Qar::Extract'
```

---

# Logical Comparisons

---

```perl
my $int_rate_extract_job_rs
    = $extract_job_rs->search({
        name => { LIKE => 'int_rate_%' },
    });
```
```
SELECT * FROM jobs
    WHERE type = 'Qar::Extract'
        AND name LIKE 'int_rate_%'
```

---

# Search Returns Resultset
## Chain them together!

---

# Combined into one

---

```perl
my $int_rate_extract_job_rs
    = $schema->resultset( 'Job' )
    ->search({
        type => 'Qar::Extract',
        name => { LIKE => 'int_rate_%' },
    });
```
```
SELECT * FROM jobs
    WHERE type = 'Qar::Extract'
        AND name LIKE 'int_rate_%'
```

---

# Resultset Iterator

---

```perl
while ( my $job = $job_rs->next ) {
    say join ": ", $job->type, $job->name;
}
```

---

# Insert Data

---

# Add a Job

```perl
my $job_rs = $schema->resultset( 'Job' );
my $job = $job_rs->create({
    type => 'Qar::Spider',
    name => 'mim_misc_reuters',
});
say "New Job ID: " . $job->id;
```
```
INSERT INTO jobs ( type, name )
    VALUES ( 'Qar::Spider', 'mim_misc_reuters' )
```

------

# Relationships

---

# The Reason to use a Relational Database

---

# A Job has many Runs

---

```
package My::Schema::Result::Job;
__PACKAGE__->has_many(
    runs => 'My::Schema::Result::Run' => 'job_id',
);
```

---

# A Run belongs to Job

---

```
package My::Schema::Result::Run;
__PACKAGE__->belongs_to(
    job => 'My::Schema::Result::Job' => 'job_id',
);
```

---

# A Run has many Run Destinations

---

```
package My::Schema::Result::Run;
__PACKAGE__->has_many(
    run_dest => 'My::Schema::Result::RunDestination' => 'run_id',
);
```

---

# A Destination has many Run Destinations

---

```
package My::Schema::Result::Destination;
__PACKAGE__->has_many(
    run_dest => 'My::Schema::Result::RunDestination' => 'dest_id',
);
```

---

# Run Destinations belong to both

---

```
package My::Schema::Result::RunDestination;
__PACKAGE__->belongs_to(
    run => 'My::Schema::Result::Run' => 'run_id',
);
__PACKAGE__->belongs_to(
    destination => 'My::Schema::Result::Destination' => 'dest_id',
);
```

---

# A Run has many Destinations
## run -> run_dest -> dest

---

```
package My::Schema::Result::Run;
__PACKAGE__->many_to_many(
    destinations => 'My::Schema::Result::RunDestination' => 'destination',
);
```

---

# Destination has many Runs
## dest -> run_dest -> run

---

```
package My::Schema::Result::Destination;
__PACKAGE__->many_to_many(
    runs => 'My::Schema::Result::RunDestination' => 'run',
);
```

------

# Relationship Resultsets
## (Queries)

---

# Add a Run

---

```perl
my $run_rs = $schema->resultset( 'Run' );
my $run = $run_rs->create({
    start => '2015-04-23T18:41:19Z',
    status => 'running',
    job_id => 1,
});
say "New Run ID: " . $run->id;
```

---

# Use the Relationship!

---

# Find the right Job
## Create it if it doesn't exist!

---

```perl
my $run_rs = $schema->resultset( 'Run' );
my $run = $run_rs->create({
    start => '2015-04-23T18:41:19Z',
    status => 'running',
    job => {
        type => 'Qar::Extract',
        name => 'ccy_spot',
    },
});
say "New Run ID: " . $run->id;
```

---

# List Runs
## With Job information

---

# belongs_to are Result objects
```perl
for my $run ( $run_rs->all ) {
    say sprintf "%s (%s): %s (%s)",
        $run->job->name,
        $run->job->type,
        $run->status,
        $run->start;
}
```

---

# List Jobs
## With Latest Run information

---

# has_many are Resultset objects
```perl
for my $job ( $job_rs->all ) {
    my $latest_run_rs = $job->runs->search(
        { },
        {
            order_by => { -desc => 'start' },
            limit => 1,
        },
    );
```

---

```
    if ( my $run = $latest_run_rs->next ) {
        say sprintf '%s (%s): %s (%s)',
            $job->name, $job->type,
            $run->status, $run->start;
    }
    else {
        say sprintf '%s (%s): Never run',
            $job->name, $job->type;
    }
}
```

------

# Custom Methods
## Simplify Common Tasks

---

# Add Result methods

---

# Get the latest Run for a Job

---

```perl
package My::Schema::Result::Job;

sub latest_run {
    my ( $self, %search ) = @_;

    my $latest_run_rs = $self->runs->search(
        \%search,
        {
            order_by => { -desc => 'start' },
            limit => 1,
        },
    );

    return $latest_run_rs->next;
}
```

---

```
my $run = $job->latest_run;
my $last_success = $job->latest_run( status => 'success' );
```

---

# Add Resultset methods

---

# Start a Run
* Set defaults
* Add corresponding Job

---

```perl
package My::Schema::ResultSet::Run;
use base 'DBIx::Class::ResultSet';

sub start_run {
    my ( $self, %attrs ) = @_;
```

---

```perl
    # Get required job info
    my %job_attrs;
    for my $attr ( qw( type name ) ) {
        $job_attr{ $attr } = delete $attrs{ $attr }
            or die "Missing job $attr";
    }
```

---

```perl
    # Set defaults
    $attrs{ status } ||= "running";
    $attrs{ start } ||= gmtime->strftime( "%FT%TZ" );
```

---

```perl
    # Create the run
    return $self->create(
        job => \%job_attrs,
        %attrs,
    );
}
```

---

```perl
$schema->resultset( 'Run' )->start_run(
    type => 'Qar::Spider',
    name => 'mim_misc_reuters',
);
```

------

# Tips and Tricks

---

# DBIC_TRACE=1

---

```
$ DBIC_TRACE=1 perl bin/list-jobs.pl
SELECT me.id, me.type, me.name FROM jobs me:
SELECT me.id, me.job_id, me.start, me.end, me.status FROM runs me
WHERE ( me.job_id = ? ) ORDER BY start DESC: '1'
int_rate_fixings_emea (Qar::Extract): error (2015-04-04T18:00:01Z)
SELECT me.id, me.job_id, me.start, me.end, me.status FROM runs me
WHERE ( me.job_id = ? ) ORDER BY start DESC: '2'
int_rate_fixings_amrs (Qar::Extract): Never run
SELECT me.id, me.job_id, me.start, me.end, me.status FROM runs me
WHERE ( me.job_id = ? ) ORDER BY start DESC: '3'
bbg_fx_spot (Qar::Spider): error (2015-04-04T04:30:01Z)
```

---

# DBIx::Class::Schema::Loader

---

# Build a Schema from an existing Database

---

```
$ dbicdump -o dump_directory=./tmp Dump::Schema dbi:SQLite:data.db
```

------

# See Also
* [DBIx::Class docs](http://metacpan.org/pod/DBIx::Class)


------

# It's over!

* [See the Slides on Github](http://github.com/preaction/Introduction-to-DBIx-Class)
