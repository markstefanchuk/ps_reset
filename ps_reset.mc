/*----------------------------------------------------------------------+
|																		|
| name		ps_reset.mc 												|
|																		|
| Revision:	08.11.00.00													|
| Date:		2012														|
|																		|
| Copyright (c) 2017, Mark Stefanchuk, The Phocaz Group, LLC			|
| All rights reserved.													|
|																		|
| Redistribution and use in source and binary forms, with or without 	|
| modification, are permitted provided that the following conditions 	|
| are met:																|
|         																|
|   Redistribution of source code must retain the above copyright 		|
|   notice, this list of conditions and the following disclaimer. 		|
|              															|
|   Redistribution in binary form must reproduce the above copyright 	|
|   notice, this list of conditions and the following disclaimer in 	|
|   the documentation and/or other materials provided with the 			|
|   distribution.														|
|           															|
|   Neither name of Mark Stefanchuk, The Phocaz Group, LLC nor the		| 
|   names of its contributors may be used to endorse or promote			|
|   products derived from this software without specific prior          |
|   written permission.													|
|            															|
| THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 	|
| "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT 		|
| NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS |
| FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS| 
| OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 		|
| SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 		|
| LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF 		|
| USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 		|
| AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,| 
| OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 	|
| OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 		|
| OF SUCH DAMAGE.														|
|          																|
|																		|
+----------------------------------------------------------------------*/
#include    <mdl.h>
#include    <tcb.h>
#include    <dlogitem.h>
#include    <dlogids.h>
#include    <rscdefs.h>
#include    <mdlerrs.h>
#include    <userfnc.h>
#include    <global.h>
#include    <mselems.h>
#include    <accudraw.h>
#include    <cexpr.h>
#include    <math.h>
#include    <string.h>

#include    "ps_resetcmd.h"
#include    "ps_reset.h"
#include    "fdf.fdf"

int goFlag;
	
void ps_reset_newFile
(
char *filenameP,
int  state
);

/*----------------------------------------------------------------------+
| name		monitorQueue                      							|
+----------------------------------------------------------------------*/
Private int monitorQueue
(
Inputq_element	*queueElementP
)
{
    char sCmd[256];
    
    //printf("%S\n", mdlState_getCurrentCommandName());
    sprintf(sCmd, "%S", mdlState_getCurrentCommandName());
    //mdlOutput_messageCenter (MESSAGE_DEBUG, sCmd, sCmd, FALSE);
	
	
    // Element Selection Active
    if (strcmp(sCmd, "Element Selection") == 0)
	{
		goFlag = 0;
	} 
	
    if ((strcmp(sCmd, "Dimension Element") == 0) || (strcmp(sCmd, "Dimension Linear Size") == 0) ||
		(strcmp(sCmd, "Dimension Angle Size") == 0) || (strcmp(sCmd, "Dimension Ordinates") == 0) ||
		(strcmp(sCmd, "Change Dimension") == 0) || 
		(strcmp(sCmd, "Drop Dimension Element") == 0) ||
		(strcmp(sCmd, "Dimension Size Perpendicular to Points") == 0) ||
		(strcmp(sCmd, "Dimension Diameter") == 0) || 
	    (strcmp(sCmd, "Label Point Coordinate") == 0) || (strcmp(sCmd, "Dimension Symmetric") == 0) ||
		(strcmp(sCmd, "Dimension Half") == 0) || (strcmp(sCmd, "Dimension Chamfer Angle") == 0) ||
		(strcmp(sCmd, "Dimension Diameter Perpendicular") == 0) || (strcmp(sCmd, "Dimension Radius (Extended Leader)") == 0) ||
		(strcmp(sCmd, "Place Center Mark") == 0) || (strcmp(sCmd, "Dimension Radius") == 0) ||
		(strcmp(sCmd, "Dimension Arc Distance") == 0))
	{
		goFlag = 1;
	} 
	else
	{
		goFlag = 0;
	}
	
	if (queueElementP->hdr.cmdtype == RESET)
	{
		if (goFlag == 0)
			mdlInput_sendKeyin ("powerselector deselect", 0, 0, NULL);
	}

    return INPUT_ACCEPT;
}

/*----------------------------------------------------------------------+
| name		main		 												|
+----------------------------------------------------------------------*/
int main ()
{
    RscFileHandle   rfHandle;
	goFlag = 0;
    mdlResource_openFile (&rfHandle, NULL, FALSE);

    if (mdlParse_loadCommandTable (NULL) == NULL)
	mdlOutput_rscPrintf (MSG_ERROR, NULL, 0, 4);

    mdlInput_setMonitorFunction (MONITOR_ALL, monitorQueue);
     
    return  SUCCESS;
}
