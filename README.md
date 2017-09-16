# ps_reset - Power Selector Reset
MicroStation V8i MDL Add-in to remove a selection set when the user clicks reset

## Usage
MDL LOAD ps_reset

On load a monitoring command is launches that watches for a reset (left mouse button). 
If a selection is active, this event will clear the selection.

## Files
fdf.fdf - include files.<br />
ps_reset.h - header file. <br />
ps_reset.ma - compiled add-in. <br />
ps_reset.mc - main source file and entry point. <br />
ps_reset.mke - make file. <br />
ps_reset.mki - make file called from mke. <br />
ps_reset.r - resources. <br />
ps_resetcmd.r - command resources. <br />

## Compiling the Source
Use bmake to compile via the MicroStation command window (delivered with the SDK).

Open the command window and cd to MircoStation\mdl\bin\

For a standard MicroStation insteall, that is C:\Program Files (x86)\Bentley\MicroStation V8i (Selectseries)\MicroStation\mdl\bin\

From this location you can run, bmake -a (path to app)\ps_reset.mke

For me, bmake -a Z:\Documents\Github\CADGURUS\ps_reset\ps_reset.mke
