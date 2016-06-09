# Hynger (HYbrid iNvariant GEneratoR) #

[Hynger Homepage](http://verivital.com/hynger/)

Hynger instruments Simulink/Stateflow (SLSF) block diagrams to generate textual log output files from SLSF simulations.  In particular, Hynger allows for integrating the Daikon invariant inference tool with SLSF diagrams.

## Contributors: ##
* [Taylor Johnson](http://www.taylortjohnson.com), University of Texas at Arlington
* [Stanley Bak](http://www.stanleybak.com), Air Force Research Lab
* Steven Drager, Air Force Research Lab

## Publications: ##
* Taylor T. Johnson, Stanley Bak, Steven Drager, "Cyber-Physical Specification Mismatch Identification with Dynamic Analysis", In 6th International Conference on Cyber-Physical Systems (ICCPS 2015), ACM/IEEE, Seattle, Washington, April 2015. [PDF](http://www.taylortjohnson.com/research/johnson2015iccps.pdf)

## INSTALLATION: ##

1. Clone the Hynger repository:
```
hg clone https://bitbucket.org/verivital/hynger
```
As some large trace files were committed in earlier versions, if hg has some problems you may try:

```
hg clone https://bitbucket.org/verivital/hynger -r 10
cd hynger/
hg pull -r 100
hg pull -r 20
hg pull -r 30
hg pull -r 40
hg update
hg fetch
```
2. [Download Daikon](http://plse.cs.washington.edu/daikon/download/) and put daikon\daikon.jar at the path:
```
hynger\lib\daikon.jar
```
If an external version of Daikon is desired, the appropriate path may be entered in hynger.m.

## EXAMPLES:##
Several examples are included in the directory examples/.

A buck converter with hysteresis controller is described in 'buck_hvoltage_discrete.slx' (or .mdl).

These include the case study described in the ICCPS 2015 submission, as well as other models tested (from the ARCH 2014 workshop, models provided by Mathworks with Matlab, etc.).

## RUNNING:##

1. From the 'src' directory, execute:

```
clear all ; hynger('buck_hvoltage_discrete', 1)
```

2. This should instrument the diagram, simulate it, creating the traces in the file:

daikon-output\output_buck_hvoltage_discrete.dtrace

3. The second argument 1 will enable feeding the resulting traces to Daikon, then generate candidate invariants.  The resulting invariants will be in the file:

daikon-output\output_buck_hvoltage_discrete.inv

NOTES:
* This will automatically try to call Daikon (specified by the second argument 1).  In case of problems using this (as the Matlab-to-Java interface is a little delicate and can cause Matlab to crash if the called Java program terminates with certain exit codes), you may try:

```
clear all ; hynger('buck_hvoltage_discrete', 0)
```

* The manual command to call Daikon from Matlab will then be printed to screen.

INSTRUMENTING OTHER BLOCKS:
* By default, Hynger will instrument ONLY subsystem and function blocks.
* Alternative modes include:
    1. Every block mode: Instrumenting EVERY block in EVERY sub-diagram recursively.  This may not be desired, as it may incur a heavy performance overhead.  To change the blocks that are instrumented, see hynger.m.
    2. Whitelist mode: This mode instruments ONLY blocks specified in a whitelist, see hynger.m and block_whitelist_instrumentation.m.
    3. Blacklist mode: Another alternative mode is to instrument EVERY block except those provided by a blacklist (see hynger.m and the file block_blacklist_instrumentation.m).

## LICENSE: ##

Hynger was developed with exclusive support provided by the Air Force Research Laboratory during the summer 2014 Visiting Faculty Research Program (VFRP) and by the Air Force Office of Scientific Research (AFOSR) during the summer 2015 Summer Faculty Fellowship Program (SFFP), both at the Information Directorate, in Rome, NY.

Hynger is licensed under the Lesser GPL version 3 and the license file is included in the repository.