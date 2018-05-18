# lb_wrr_dynamic_weights

Test of dynamic weights for [dynamic] Weighted Round Robin in load-balancing

# WIP

This project is a *work in progress*. The implementation is *incomplete* and
subject to change. The documentation can be inaccurate.

# Backend Agent for the Load Balancer

Usually, for Dynamic Weighted Round Robin in load-balancing, there needs to
be an agent running in the backend instances informing the load balancer of
the current, dynamic weights of the backend instances. This backend agent
is called by different names. Some, like Cisco, what define is a protocol
the agent needs to follow, like the *Dynamic Feedback Protocol* (DFP) for the
*Cisco IOS SLB* (Server Load Balancing). Others, like F5, call it the
*Data Collection Agent* (DCA) and simply use SNMP for the load balancer to
query the DCA agent running in the backend instance, using some agreed
upon OIDs. In all cases, the backend agent informs the load-balancer of the
current values of several metrics which directly affect the calculation of
the dynamic weight of the backend instance inside the load-balanced pool.

For the Cisco's Dynamic Feedback Protocol (DFP) Agent Subsystem for Dynamic
Weighted Round Robin, see
[https://www.cisco.com/c/en/us/td/docs/ios/12_2sx/feature/guide/dfpsxd1.html](https://www.cisco.com/c/en/us/td/docs/ios/12_2sx/feature/guide/dfpsxd1.html),
[https://www.cisco.com/c/en/us/td/docs/ios/slb/configuration/guide/slb_cg_book/slb_cg_info.html](https://www.cisco.com/c/en/us/td/docs/ios/slb/configuration/guide/slb_cg_book/slb_cg_info.html),
and [https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/slb/configuration/15-s/slb-15-s-book.pdf](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/slb/configuration/15-s/slb-15-s-book.pdf).

For F5 SNMP-based Data Collection Agent for Dynamic Weighted Round Robin
(called Dynamic Ratio by F5), see
[https://support.f5.com/csp/article/K9125](https://support.f5.com/csp/article/K9125),
how to specify custom SNMP OIDs in [https://support.f5.com/csp/article/K14110](https://support.f5.com/csp/article/K14110),
and [https://support.f5.com/csp/article/K14114](https://support.f5.com/csp/article/K14114).

For an equivalent in the Linux IP Virtual Server (IPVS), see its
Dynamic Feedback Load Balancing Scheduling, at
[http://kb.linuxvirtualserver.org/wiki/Dynamic_Feedback_Load_Balancing_Scheduling](http://kb.linuxvirtualserver.org/wiki/Dynamic_Feedback_Load_Balancing_Scheduling)


# Draft

      mkdir ~/.snmp/
      pwd > ~/.snmp/snmp.conf
      oid=dynamicRatioProcess
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c mib2c.scalar.conf  "$oid"
      # To compile Net-SNMP sub-agent (not used):
      # env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c subagent.m2c       "$oid"

Once the shared object is compiled, then add in the `snmpd.conf` config file:

      dlmod  dynamicRatioProcess  /<path>/<to>/dynamicRatioProcess.so

and restart `snmpd` after that.

To test, once configured:

      # Get CPU metric of the backend process (its CPU%)
      # (The OID for the CPU metric is below)
       
      snmpget  [-options...]  localhost  1.3.6.1.4.1.99999.3.1.0
       
      # Get memory metric of the backend process (its RSS size in KB)
      # (The OID for the memory metric is below)
       
      snmpget  [-options...]  localhost  1.3.6.1.4.1.99999.3.2.0

# TODO

1. How to configure the name of the backend process to report through SNMP (or any characteristic of the backend process to distinguish it) -- right now it is reporting now about PID=1, because it doesn't know how to distinguish the backend process to report about.

2. Related to the above, handle the case that the backend process has children or "sub-agents" (ie., independent processes with which the backend process communicates through IPC), so that it is not a single PID.

For points 1 and 2, probably use in the "snmpd.conf" file:

        LbDWRRregexpCmdLine   <extended-regular-expression-on-backend-process-command-line>

which can be specified multiple times in "snmpd.conf" to indicate all the processes to add together in the metrics.

3. For the value of the memory metric, to know whether to report to the load-balancer the backend process(es) size, or, alternatively, the available memory (under the rationale that, among a set of backend processes served by the load-balancer, if one of the backend processes happens to be running in a machine or container with more available memory, then the load-balancer should favored it -*if the values of all the other metrics are the same, e.g., health checks, CPU metrics, etc*). Note that, if all the backend processes run in machines or containers with the same amount of *total* memory each one, then the first memory metric (the process(es) size) is related to the second memory metric (the available memory): `available_memory ~ is directly proportional to ~ unique_total_memory - processes_size`, so that for the dynamic weighted round robin in the load-balancer either memory metric may be used (but with different coefficients).

4. Other, different metrics about the backend processes, besides the above two (CPU% and a memory metric).

