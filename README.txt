[Taylor Johnson](http://www.taylortjohnson.com)
University of Texas at Arlington
[Stanley Bak](http://www.stanleybak.com)
Steven Drager

Hynger (HYbrid iNvariant GEneratoR)

Hynger instruments Simulink/Stateflow (SLSF) block diagrams to generate textual log output files from SLSF simulations.  In particular, Hynger allows for integrating the Daikon invariant inference tool with SLSF diagrams.

Hynger is described in a paper under review:

Cyber-Physical Specification Mismatch Identification with Dynamic Analysis
[Submission PDF](http://verivital.com/hynger/)

INSTALLATION:

[Download Daikon](http://plse.cs.washington.edu/daikon/download/) and put daikon\daikon.jar at the path:

hynger\lib\daikon.jar

If an external version of Daikon is desired, the appropriate path may be entered in hynger.m.

EXAMPLES:

Several examples are included in the directory examples/.

A buck converter with hysteresis controller is described in 'buck_hvoltage_discrete.slx' (or .mdl).

These include the case study described in the ICCPS 2015 submission, as well as other models tested (from the ARCH 2014 workshop, models provided by Mathworks with Matlab, etc.).

RUNNING:

1. From the 'src' directory, execute:

clear all ; hynger('buck_hvoltage_discrete', 1)

2. This should instrument the diagram, simulate it, creating the traces in the file:

daikon-output\output_buck_hvoltage_discrete.dtrace

3. The second argument 1 will enable feeding the resulting traces to Daikon, then generate candidate invariants.  The resulting invariants will be in the file:

daikon-output\output_buck_hvoltage_discrete.inv

NOTES:
* This will automatically try to call Daikon (specified by the second argument 1).  In case of problems using this (as the Matlab-to-Java interface is a little delicate and can cause Matlab to crash if the called Java program terminates with certain exit codes), you may try:

clear all ; hynger('buck_hvoltage_discrete', 0)

* The manual command to call Daikon from Matlab will then be printed to screen.

INSTRUMENTING OTHER BLOCKS:
* By default, Hynger will instrument ONLY subsystem and function blocks.
* Alternative modes include:
A) Every block mode: Instrumenting EVERY block in EVERY sub-diagram recursively.  This may not be desired, as it may incur a heavy performance overhead.  To change the blocks that are instrumented, see hynger.m.
B) Whitelist mode: This mode instruments ONLY blocks specified in a whitelist, see hynger.m and block_whitelist_instrumentation.m.
C) Blacklist mode: Another alternative mode is to instrument EVERY block except those provided by a blacklist (see hynger.m and the file block_blacklist_instrumentation.m).