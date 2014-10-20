Taylor Johnson
University of Texas at Arlington

Hynger (HYbrid iNvariant GEneratoR)

Hynger instruments Simulink/Stateflow (SLSF) block diagrams to generate textual log output files from SLSF simulations.

In particular, Hynger allows for integrating the Daikon invariant inference tool with SLSF diagrams.

INSTALLATION:

Nothing is required by default (a jar to the Daikon library is included).

If an external version of Daikon is desired, the appropriate path may be entered in hynger.m.

EXAMPLES:

Several examples are included in the directory examples/.

A buck converter with hysteresis controller is described in 'buck_hvoltage_discrete.slx' (or .mdl).

These include the case study described in the ICCPS 2015 submission, as well as other models tested (from the ARCH 2014 workshop and models provided by Mathworks with Matlab).

RUNNING:

1. From the 'src' directory, execute:

clear all ; hynger('buck_hvoltage_discrete', 1)

2. This should instrument the diagram, simulate it, creating the traces in the file:

daikon-output\output_buck_hvoltage_discrete.dtrace

3. The second argument 1 will enable feeding the resulting traces to Daikon, then generate candidate invariants.  The resulting invariants will be in the file:

daikon-output\output_buck_hvoltage_discrete.inv

NOTES:
* This will automatically try to call Daikon (specified by the second argument 1).  In case of problems using this (as the Matlab-to-Java interface is delicate), you may try:

clear all ; hynger('buck_hvoltage_discrete', 0)

* The manual command to call Daikon from Matlab will then be printed to screen.

INSTRUMENTING OTHER BLOCKS:
* By default, Hynger will instrument ONLY subsystem and function blocks.
* Alternative modes include:
A) Every block mode: Instrumenting EVERY block in EVERY sub-diagram recursively.  This may not be desired, as it may incur a heavy performance overhead.  To change the blocks that are instrumented, see hynger.m.
B) Whitelist mode: This mode instruments ONLY blocks specified in a whitelist, see hynger.m and block_whitelist_instrumentation.m.
C) Blacklist mode: Another alternative mode is to instrument EVERY block except those provided by a blacklist (see hynger.m and the file block_blacklist_instrumentation.m).