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

# Draft

      mkdir ~/.snmp/
      pwd > ~/.snmp/snmp.conf
      oid=dynamicRatioProcess
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c mib2c.scalar.conf  "$oid"
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c subagent.m2c       "$oid"
      env MIBS="+DYNAMIC-WEIGHT-BACK-PROCESS-MIB" mib2c -c mfd-makefile.m2m   "$oid"

