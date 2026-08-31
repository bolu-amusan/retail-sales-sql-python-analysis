# Process Log — Challenges & Design Decisions

A running log of real issues encountered and decisions made while building this project.

## 1. Inconsistent date formats within the same column

`Order Date` and `Ship Date` mixed two formats across rows: `DD-MM-YYYY` (e.g. `11-08-2016`) and `M/D/YYYY` with no leading zeros (e.g. `6/16/2016`). This was confirmed via regex checks that only these two patterns existed — no third format hiding in the data.

**Solution:** I Loaded all data as `TEXT` into a staging table first, deferring type conversion. During transform, I used a `CASE` statement with a regex check (`~ '^\d{2}-\d{2}-\d{4}$'`) to route each row to the correct `TO_DATE()` format string.

**Assumption flagged:** For `M/D/YYYY` rows, I assumed month-first (US convention), consistent with the dataset's US retail origin.

## 2. File path handling in Windows / Git Bash

I encountered a little confusion between the original downloaded zip file (in Downloads) and the unzipped, renamed working copy (in the repo's `data/` folder). This challenge was resolved by consistently using `pwd` and `ls` to confirm working directory and file locations before running path-dependent commands.

## 3. pgAdmin's Import/Export wizard generated incorrect COPY syntax

The GUI wizard defaulted to `ESCAPE ''''` (single quote as escape character), which is non-standard for CSV and broke parsing on the first embedded apostrophe in the data (`Eldon Fold 'N Roll Cart System`), throwing an "unterminated CSV quoted field" error partway through the file.

**Solution:** I wrote the `COPY` command manually instead of trusting the GUI-generated syntax, omitting the incorrect `ESCAPE` clause so Postgres defaulted to the correct CSV standard (quote character as its own escape).

## 4. Server-side vs. client-side file permissions

`COPY` failed with "Permission denied" because it executes on the Postgres **server process**, which doesn't have access to files inside a personal Windows user folder.

**Solution:** I switched to `\copy`, a psql meta-command that reads the file client-side (as the logged-in user) instead of server-side.

## 5. `psql` not found in PATH

Git Bash couldn't locate `psql` by name since Postgres's `bin` directory wasn't added to the system PATH during install.

**Solution:** I managed to locate the install path directly (`C:\Program Files\PostgreSQL\18\bin\psql.exe`) and called it explicitly.

## 6. Git authentication conflict between two GitHub accounts

`git push` failed with a 403 error — Windows Credential Manager had cached login credentials for a different GitHub account than the one owning this repo `bolu-amusan`. An older account was logged on my PC and that was processing my work.

**Solution:** I cleared the cached credential by going to 'Credential Manager' --> 'Windows Credential Manager' --> 'git:https://...' on my windows computer and removing old credentials; and fresh login resolved subsequent pushes.

## 7. Customer location modeling decision

Considered whether `City` / `State` / `Region` belonged on the `customers` table (home location) or the `orders` table (per-shipment destination).

**Decision:** Modeled as a customer attribute (home location) for simplicity, since this dataset doesn't clearly separate the two. Noted as a deliberate simplification — a production system would likely need a separate `addresses` table to support multiple shipping destinations per customer.