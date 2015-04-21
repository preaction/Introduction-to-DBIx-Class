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
>>> SELECT id, name FROM person WHERE username = "preaction"
id          name
----------  ----------
1           Doug
```

---

```
>>> INSERT INTO profile ( person_id, twitter, github )
..> VALUES ( 1, "preaction", "preaction" );
```

---

```
>>> UPDATE person
..> SET name = "Doug Bell" 
..> WHERE username = "preaction"
```

---

```
>>> SELECT id, name, twitter FROM person
..> JOIN profile ON person.id = profile.person_id
..> WHERE username = "preaction";
id          name        twitter
----------  ----------  ----------
1           Doug Bell   preaction
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
