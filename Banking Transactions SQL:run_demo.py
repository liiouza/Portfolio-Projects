#!/usr/bin/env python3 
"""Build and query the fictional banking database using Python's stdlib.""" 
 
from pathlib import Path 
import sqlite3 
 
 
HERE = Path(__file__).resolve().parent 
DB_PATH = HERE / "banking_demo.db" 
 
 
def main() -> None:  
    if DB_PATH.exists(): 
        DB_PATH.unlink() 
 
    connection = sqlite3.connect(DB_PATH) 
    connection.row_factory = sqlite3.Row 
    connection.execute("PRAGMA foreign_keys = ON") 
    try: 
        connection.executescript((HERE / "schema.sql").read_text(encoding="utf-8")) 
        connection.executescript((HERE / "seed.sql").read_text(encoding="utf-8")) 
 
        # Execute each numbered SELECT independently so the console output is readable. 
        query_text = (HERE / "queries.sql").read_text(encoding="utf-8") 
        statements = [ 
            statement.strip() 
            for statement in query_text.split(";") 
            if statement.strip() and any(line.strip() and not line.lstrip().startswith("--") for line in statement.splitlines()) 
        ] 
        for number, statement in enumerate(statements, start=1): 
            cursor = connection.execute(statement) 
            rows = cursor.fetchall() 
            print(f"\nQuery {number}") 
            if not rows: 
                print("(no rows)") 
                continue 
            headers = rows[0].keys() 
            print(" | ".join(headers)) 
            for row in rows: 
                print(" | ".join(str(row[key]) for key in headers)) 
    finally: 
        connection.close() 
 
     print(f"\nDatabase created at: {DB_PATH.name}")
 
 
if __name__ == "__main__": 
    main() 