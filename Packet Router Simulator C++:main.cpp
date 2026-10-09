#include <iostream> 
#include <map> 
#include <queue> 
#include <random> 
#include <string> 
#include <vector> 
using namespace std;
 
struct Packet { 
    int id; 
    string destination_network; 
    int size_bytes; 
    int ttl;   // Time To Live to prevent neverending looping 
    int priority;   // 3 is highest priority 
}; 
 
struct HigherPriorityFirst { 
    bool operator()(const Packet& left, const Packet& right) const {   // Comparing the packets 
        if (left.priority == right.priority) return left.id > right.id; 
        return left.priority < right.priority; 
    } 
}; 
 
struct Statistics { 
    int forwarded = 0; 
    int dropped_ttl = 0; 
    int dropped_no_route = 0; 
    int bytes_forwarded = 0; 
}; 
 
int main() { 
    const map<string, string> routing_table{ 
        {"10.10.0.0/24", "eth0 (Sofia LAN)"}, 
        {"10.20.0.0/24", "eth1 (Office VPN)"},
        {"0.0.0.0/0", "eth2 (Default gateway)"}, 
    }; 
    priority_queue<Packet, vector<Packet>, HigherPriorityFirst> queue;
    mt19937 generator(42);   // Random number generator with a fixed seed for testing 
    uniform_int_distribution<int> destination(0, 2); 
    uniform_int_distribution<int> size(64, 1500);
    uniform_int_distribution<int> ttl(0, 4);
    uniform_int_distribution<int> priority(1, 3);
    const vector<string> networks{"10.10.0.0/24", "10.20.0.0/24", "172.16.0.0/16"}; 
 
    cout << "Packet Router Simulator\n=========================\n";
    for (int id = 1; id <= 12; ++id) { 
        Packet packet{id, networks[destination(generator)], size(generator), ttl(generator), priority(generator)}; 
        queue.push(packet); 
        cout << "Queued packet " << packet.id << " | destination=" << packet.destination_network
                  << " | priority=" << packet.priority << " | ttl=" << packet.ttl << '\n'; 
    } 
 
    Statistics stats; 
    constexpr int interface_budget = 4000;   // Bytes allowed in this simulation cycle (limited interface capacity)
    cout << "\nForwarding cycle (budget: " << interface_budget << " bytes)\n"; 
    while (!queue.empty()) { 
        Packet packet = queue.top();   // Take the most important packet out of the queue
        queue.pop(); 
        if (packet.ttl <= 0) { 
            ++stats.dropped_ttl; 
            cout << "DROP packet " << packet.id << ": TTL expired\n";
            continue; 
        } 
 
        auto route = routing_table.find(packet.destination_network); 
        if (route == routing_table.end()) route = routing_table.find("0.0.0.0/0"); 
        if (route == routing_table.end()) { 
            ++stats.dropped_no_route;
            cout << "DROP packet " << packet.id << ": no route\n";   // If there's no route, counts a no-route drop, prints the result, and moves to the next packet
            continue; 
        } 
        if (stats.bytes_forwarded + packet.size_bytes > interface_budget) {   // If the packet exceeds 4000 bytes
            cout << "DEFER packet " << packet.id << ": interface budget exhausted\n" 
            continue; 
        } 
 
        ++stats.forwarded; 
        stats.bytes_forwarded += packet.size_bytes; 
        cout << "FORWARD packet " << packet.id << " via " << route->second
                  << " (TTL " << packet.ttl - 1 << ")\n"; 
    } 
 
    cout << "\nSummary\n-------\n"; 
    cout << "Forwarded: " << stats.forwarded << "\nDropped (TTL): " << stats.dropped_ttl
              << "\nDropped (no route): " << stats.dropped_no_route 
              << "\nBytes forwarded: " << stats.bytes_forwarded << '\n'; 
} 
 