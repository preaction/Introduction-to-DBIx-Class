# Introduction to DBIx::Class

------

# Data is hard

------

# Schemas are hard

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

# Relationships

---

# Job has many Runs

---

```
package My::Schema::Result::Job;
__PACKAGE__->has_many(
    runs => 'My::Schema::Result::Run' => 'job_id',
);
```

---

# Run belongs to Job

---

```
package My::Schema::Result::Run;
__PACKAGE__->belongs_to(
    job => 'My::Schema::Result::Job' => 'job_id',
);
```

---

# Run has many Run Destinations

---

```
package My::Schema::Result::Run;
__PACKAGE__->has_many(
    run_dest => 'My::Schema::Result::RunDestination' => 'run_id',
);
```

---

# Destination has many Run Destinations

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
    dest => 'My::Schema::Result::Destination' => 'dest_id',
);
```

---

# Run has many Destinations

---

```
package My::Schema::Result::Run;
__PACKAGE__->many_to_many(
    dests => 'My::Schema::Result::RunDestination' => 'dest',
);
```

---

# Destination has many Runs

---

```
package My::Schema::Result::Destination;
__PACKAGE__->many_to_many(
    runs => 'My::Schema::Result::RunDestination' => 'run',
);
```

------

# Resultsets

XXX

------

# It's over!

* [See the Slides on Github](http://github.com/preaction/Introduction-to-DBIx-Class)
