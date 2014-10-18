Taylor Johnson
University of Texas at Arlington

Hynger (HYbrid iNvariant GEneratoR)

Hynger instruments Simulink/Stateflow (SLSF) block diagrams to generate textual log output files from SLSF simulations.

In particular, Hynger allows for integrating the Daikon invariant inference tool with SLSF diagrams.

INSTALLATION:

Nothing is required by default (a jar to the Daikon library is included).

If an external version of Daikon is desired, the appropriate path may be entered in hynger.m.

RUNNING:

Several examples are included in the directory examples/.

A buck converter with hysteresis controller is described in 'buck_hvoltage_discrete.slx' (or .mdl).

1. Open the SLSF diagram 'buck_hvoltage_discrete.slx'.
2. Run the initialization script 'examples\parameters'
3. Run the script 'hynger' (note, in the current version, the diagram must be open)
4. Call daikon on the output file by executing (from in Matlab, as hynger.m will have imported the Daikon library): 'daikon.Daikon.main('../daikon-output/output.dtrace')'


NOTES:
* By default, Hynger will instrument EVERY block in EVERY sub-diagram recursively.  This may not be desired, as it may incur a heavy performance overhead.  To change the blocks that are instrumented, modify hynger.m.