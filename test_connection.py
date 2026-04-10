#!/usr/bin/env python3
# coding: utf-8

import typer

from firebird.driver import connect, DESCRIPTION_NAME
from rich import print
from rich.table import Table

app = typer.Typer()

# region Commands ----------------------------------------------------------------------


@app.command()
def connect_to_firebird(
    database: str,
    host: str = "localhost",
    user: str = "sysdba",
    password: str = "masterkey",
    query: str = None,
) -> int:
    """Attach to an existing database/alias using server connection to host"""
    # @ See: https://firebird-driver.readthedocs.io/en/stable/getting-started.html#executing-sql-statements

    tab = Table("Query Results")
    db = f"{host}:{database}"

    with connect(db, user=user, password=password) as con:
        with con.cursor() as cursor:
            print(f"Connected to {db}")
            cursor.execute(query or "SELECT * FROM rdb$roles")

            for fieldDesc in cursor.description:
                tab.add_column(fieldDesc[DESCRIPTION_NAME])

            fieldIndices = range(len(cursor.description))
            for row in cursor:
                cols = []
                for fieldIndex in fieldIndices:
                    fieldValue = str(row[fieldIndex])
                    cols += [fieldValue]
                tab.add_row(*cols)

    print(tab)
    return 0


# endregion

# region Main ---------------------------------------------------------------------------

if __name__ == "__main__":
    app()

# endregion
