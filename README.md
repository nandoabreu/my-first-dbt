# My first dbt project

This project is my first attempt to explore and run [dbt](https://www.getdbt.com/product/what-is-dbt),
a powerful tool for transforming data in analytics engineering workflows.

The idea for this project came up during an interview where knowledge of dbt was mentioned as a requirement
or a "nice-to-have". Although I had no prior experience with dbt, the conversation took an interesting turn
when I was asked:

― Do you know Jinja?

For anyone familiar with Python frameworks like FastAPI, Django, or Flask, the name instantly rings a bell!
After the interview, I asked ChatGPT if dbt used Jinja the way I thought it did. AND IT DID! <3

This project represents my weekend/side-project to learn dbt hands-on and understand how it integrates with data workflows.
My goal is to explore how dbt transforms raw data into analytics-ready datasets through a simple, but structured project
and know about its:

- Data flow: source, staging, transformation, target
- Configuration and Engineering: how it works underneath

> This project is not intended to be a highly professional implementation.
> Its primary purpose is for learning and to provide some guidance for anyone
> who might attempt to run this draft.


## Set-up

As spoiled, dbt uses [Jinja2](https://jinja.palletsprojects.com/).
And dbt is installed with pip, how cute! :-)

To run this project as it is, you must have some database available.
The data we will mock, but the DB and user must be provided to dbt.

I am using Postgres, but dbt and the configuration probably accept MySQL, MariaDB, SQLite3, etc.
A podman or docker container also can quicly spin up a DB locally and for free.

The following commands should create and activate a virtual environment and install the necessary dependencies.

```shell
python -m venv venv
source venv/bin/activate
python -m pip install --upgrade -r requirements.txt
```

### Mock data

I added [this bash script](tests/setup/run.bash) to create a table and mock data in it.
It uses `psql` to send the commands to Postgres. Database, hostname, schema and table must be set inside
the file. I did not parametrize this data that will also be used in dbt files, sorry for that.

```shell
bash tests/setup/run.bash
```

## Run

TBD
