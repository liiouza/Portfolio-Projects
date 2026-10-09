#!/usr/bin/env python3 
"""NetWatch: a small TCP/IP diagnostic report tool. 
 
It resolves a hostname and attempts TCP connections only to ports 
provided by the user. It is designed for troubleshooting systems you own or 
are authorised to test; it is not a port scanner. 
""" 
  
from __future__ import annotations   # It makes using forward references cleaner
 
import argparse   # CLI
import json       # Turns data into JSON
import platform   # Information about the operating system 
import socket     # Interface for DNS, IP, TCP, Hostnames, Ports
import sys        # Return status code
import time       # Measures how long a connection takes
from dataclasses import asdict, dataclass   # Object that contains info converted into a dictionary
from datetime import datetime, timezone     # Current date and UTC time zone
 
 
@dataclass 
class PortResult: # One port check
    port: int     
    status: str   
    latency_ms: float | None  # Latency in milliseconds
    message: str  
  
 
def resolve_host(host: str) -> list[str]:    # Text input and list of values output
    # Returns unique IPv4/IPv6 addresses resolved through the system resolver
    records = socket.getaddrinfo(host, None, type=socket.SOCK_STREAM)   # Resolve the hostname  with addresses appropriate for stream-based TCP connections
    return sorted({record[4][0] for record in records}). # Unique set of addresses in an ordered list
 
   
def check_port(host: str, port: int, timeout: float) -> PortResult: 
    # Makes one TCP connection attempt and return a readable result
    started = time.perf_counter()   # Moment the connection attempt begins
    try: 
        with socket.create_connection((host, port), timeout=timeout):  # Checks whether a connection can be made
            latency = round((time.perf_counter() - started) * 1000, 2)  
            return PortResult(port, "reachable", latency, "TCP handshake completed") 
    except socket.timeout:   # If connection takes too long 
        return PortResult(port, "timed_out", None, f"No response within {timeout:.1f}s")   
    except ConnectionRefusedError:  # If the port rejects the connection
        return PortResult(port, "refused", None, "Host responded, but no service accepted the connection") 
    except OSError as error:   # Operating system/Network errors 
        return PortResult(port, "error", None, str(error)) 
 
 
def local_context() -> dict[str, str]:   # Text dictionary
    hostname = socket.gethostname()   # Current computer's name 
    try: 
        local_ip = socket.gethostbyname(hostname)   # Current IP address
    except socket.gaierror: 
        local_ip = "unavailable" 
    return {  
        "hostname": hostname, 
        "local_ip": local_ip,  
        "operating_system": f"{platform.system()} {platform.release()}", 
    } 
 
  
def make_report(host: str, ports: list[int], timeout: float) -> dict[str, object]: 
    report: dict[str, object] = { 
        "generated_at": datetime.now(timezone.utc).isoformat(), 
        "target": host, 
        "local_context": local_context(),   # Calls earlier function and stores the returned dictionary
    } 
    try: 
        report["resolved_addresses"] = resolve_host(host) 
        report["dns_status"] = "resolved" 
        report["port_checks"] = [asdict(check_port(host, port, timeout)) for port in ports] 
    except socket.gaierror as error: 
        report["dns_status"] = "failed" 
        report["dns_error"] = str(error) 
        report["port_checks"] = [] 
    return report 
 
 
def print_human_report(report: dict[str, object]) -> None:   # Display
    print("\nNetWatch diagnostic report") 
    print("=" * 30)
    print(f"Target: {report['target']}") 
    print(f"DNS: {report['dns_status']}") 
    addresses = report.get("resolved_addresses", [])  # Retrieves a dictionary value if it exists
    if addresses: 
        print("Addresses: " + ", ".join(addresses)) 
    for result in report["port_checks"]:  # type: ignore[index] 
        latency = f" ({result['latency_ms']} ms)" if result["latency_ms"] is not None else ""  # Conditional expression 
        print(f"Port {result['port']}: {result['status']}{latency} — {result['message']}") 
    if report["dns_status"] == "failed": 
        print(f"DNS error: {report['dns_error']}") 
 
 
def parse_args() -> argparse.Namespace:   # Function that reads the options typed into the terminal
    parser = argparse.ArgumentParser(description="Create a safe TCP/IP diagnostic report.") 
    parser.add_argument("host", help="Hostname or IP address you are authorised to test")   # Arguement typed directly after the filename 
    parser.add_argument("--ports", default="80,443", help="Comma-separated TCP ports (default: 80,443)")   
    parser.add_argument("--timeout", type=float, default=3.0, help="Connection timeout in seconds")   # Convert input to a decimal number
    parser.add_argument("--json", action="store_true", help="Print JSON instead of a readable report")   
    args = parser.parse_args() 
    try: 
        args.ports = [int(port.strip()) for port in args.ports.split(",")] 
    except ValueError: 
        parser.error("--ports must be comma-separated integers") 
    if not args.ports or any(port < 1 or port > 65535 for port in args.ports):   # Port range
        parser.error("each port must be between 1 and 65535") 
    if args.timeout <= 0: 
        parser.error("--timeout must be positive") 
    return args 
 
 
def main() -> int: 
    args = parse_args() 
    report = make_report(args.host, args.ports, args.timeout)   # Diagnostic report
    if args.json: 
        print(json.dumps(report, indent=2))   # Easier to read JSON with indentation
    else: 
        print_human_report(report) 
    return 0 if report["dns_status"] == "resolved" else 1   # Status code return to OS
 
 
if __name__ == "__main__":   # Only start the program if this file was run directly
    sys.exit(main())   
