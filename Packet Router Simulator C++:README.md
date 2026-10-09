# Packet Router Simulator

A C++17 console program that simulates a router processing packets in priority order. It demonstrates a simplified routing table, TTL handling, interface capacity, and forwarding statistics.

## Concepts demonstrated

- `std::priority_queue` for prioritising time-sensitive traffic
- `std::map` as a compact routing table
- TTL expiry and default-route behaviour
- Reproducible test data through a fixed random seed

## Build and run

C++17 compiler:

```bash
g++ -std=c++17 -Wall -Wextra -pedantic src/main.cpp -o router_simulator
./router_simulator
```

## Important limitation

This is an educational simulation, not an implementation of real IP packet forwarding. It uses network labels instead of parsing packet headers.

## Skills demonstrated

C++ · data structures · priority queues · routing concepts · TCP/IP fundamentals · console applications
