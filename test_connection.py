#!/usr/bin/env python3
# coding: utf-8
"""Test connection to a Firebird database using a pure-Python driver.

Uses the `firebirdsql` package which implements the Firebird wire protocol
directly, so no native Firebird client library is required on the runner.
Works on Linux, macOS (ARM64 and x86_64), and Windows.
"""

import argparse
import socket
import sys
import time


def wait_for_port(host: str, port: int, timeout: int = 120) -> bool:
    """Wait until a TCP port is accepting connections."""
    start = time.monotonic()
    interval = 1
    while time.monotonic() - start < timeout:
        try:
            with socket.create_connection((host, port), timeout=1):
                elapsed = int(time.monotonic() - start)
                print(f"Port {port} on {host} is open after {elapsed}s")
                return True
        except (ConnectionRefusedError, TimeoutError, OSError):
            time.sleep(interval)
    return False


def test_firebird_connection(
    host: str,
    database: str,
    user: str,
    password: str,
    retries: int = 5,
) -> bool:
    """Connect to Firebird and run a test query, retrying on failure."""
    try:
        import firebirdsql  # type: ignore[import]
    except ImportError:
        print("ERROR: 'firebirdsql' package is not installed. Run: pip install firebirdsql", file=sys.stderr)
        return False

    last_error: Exception | None = None
    for attempt in range(retries):
        try:
            con = firebirdsql.connect(
                host=host,
                database=database,
                user=user,
                password=password,
            )
            try:
                cur = con.cursor()
                cur.execute("SELECT rdb$role_name FROM rdb$roles")
                rows = cur.fetchall()
                print(f"Connected to {host}:{database}")
                print(f"Query returned {len(rows)} row(s) from rdb$roles:")
                for row in rows:
                    print(f"  {row[0]}")
                return True
            finally:
                con.close()
        except Exception as exc:
            last_error = exc
            if attempt < retries - 1:
                print(f"Attempt {attempt + 1}/{retries} failed: {exc}  — retrying in 5s…")
                time.sleep(5)

    print(f"All {retries} connection attempts failed. Last error: {last_error}", file=sys.stderr)
    return False


def main() -> int:
    parser = argparse.ArgumentParser(description="Test Firebird database connectivity")
    parser.add_argument("database", help="Server-side database path, e.g. /var/lib/firebird/data/my.fdb")
    parser.add_argument("--host", default="localhost", help="Firebird host (default: localhost)")
    parser.add_argument("--user", default="sysdba", help="Database user (default: sysdba)")
    parser.add_argument("--password", default="masterkey", help="Database password")
    parser.add_argument("--port", type=int, default=3050, help="Firebird port (default: 3050)")
    parser.add_argument("--wait", type=int, default=120, metavar="SECS",
                        help="Seconds to wait for the port to open (default: 120)")
    parser.add_argument("--retries", type=int, default=5,
                        help="Connection attempts before giving up (default: 5)")
    args = parser.parse_args()

    print(f"Waiting up to {args.wait}s for Firebird on {args.host}:{args.port}…")
    if not wait_for_port(args.host, args.port, timeout=args.wait):
        print(f"Timed out waiting for Firebird on {args.host}:{args.port}", file=sys.stderr)
        return 1

    if not test_firebird_connection(
        host=args.host,
        database=args.database,
        user=args.user,
        password=args.password,
        retries=args.retries,
    ):
        return 1

    print("Connection test PASSED ✓")
    return 0


if __name__ == "__main__":
    sys.exit(main())
