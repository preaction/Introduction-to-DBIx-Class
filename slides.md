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

---

# Build a model

------

# DBIx::Class

---

# XXX

------

# It's over!

* [See the Slides on Github](http://github.com/preaction/Introduction-to-DBIx-Class)
