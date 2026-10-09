# NetWatch CLI

A dependency-free Python command-line tool that produces a short TCP/IP troubleshooting report: DNS resolution, local context, and explicitly requested TCP connection checks.

## Purpose

When diagnosing a connectivity issue, it helps to separate: whether the DNS works, or if I can reach the target, even if the particular service accepts TCP connections. NetWatch makes those checks visible in one report.

## Features

- Resolves IPv4 and IPv6 addresses using the operating system's DNS resolver
- Checks only the specific TCP ports supplied by the user
- Distinguishes successful connections, refused connections, timeouts, and DNS errors
- Produces readable terminal output or JSON suitable for a ticket attachment
- Uses only Python's standard library

## Running it

Requires Python 3.10 or newer.

```bash
python3 netwatch.py example.com --ports 80,443
python3 netwatch.py example.com --ports 443 --json
```

Example result:

```text
Target: example.com
DNS: resolved
Port 443: reachable (22.41 ms) — TCP handshake completed
```

## Safe use

Use this only for hosts and services you own or are authorised to test. It is intentionally not designed for broad port scanning.

## Skills demonstrated

Python · Command-Line Interfaces · error handling · TCP/IP · DNS · troubleshooting documentation
