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
and [https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/slb/configuration/15-s/slb-15-s-book.pdf](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/slb/configuration/15-s/slb-15-s-book.pdf)

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
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c subagent.m2c       "$oid"
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c mfd-makefile.m2m   "$oid"

