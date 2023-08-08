integer COMM= -28903;

vector pos;
rotation rot;
vector offset;
rotation roffset;

integer recorded = FALSE;
integer listener;
integer masteralive;

GetOffsets()
{
    list offsets = llParseString2List(llGetObjectDesc(), ["&&"], []);
    offset = (vector)llList2String(offsets, 0);
    roffset = (rotation)llList2String(offsets,1);
    recorded = TRUE;
    llSay(COMM,"request");
}

kill_script()
{
    llRemoveInventory(llGetScriptName());
}

scan()
{
    llSensor(llGetObjectName(), "", PASSIVE|ACTIVE, 10, PI );
}

default 
{
    state_entry()
    {
        listener=llListen(COMM,"","","");
    }
    
    listen(integer chan, string name, key id, string message) 
    {
        list params = llParseString2List(message,["&&"],[]);
        vector masterpos = (vector)llList2String(params, 1);
        rotation masterrot = (rotation)llList2String(params, 2);
        if(llList2String(params,0)=="Place")
        {
            if (recorded)
            {
                //add offsets to master pos and rot, then set
                vector newpos = masterpos + offset * masterrot;
                rotation newrot = roffset * masterrot;
                llSetPrimitiveParams([PRIM_POSITION, newpos, PRIM_ROTATION, newrot]);
                    //double check that we've gotten there
                    if (llGetPos() != newpos)
                    {
                        while (llGetPos() != newpos)
                        {
                            llSetPos(newpos);
                        }
                        llSetRot(newrot);
                    }
                    masteralive = TRUE;                    
            }
            scan();
        }
    }
    
    on_rez(integer param)
    {
        if (param != 0)
        {
            GetOffsets();  
            masteralive = TRUE;   
        }
        else if(param ==0)
        {
            kill_script();
        }
    }
    
    sensor (integer numberDetected)
    {
        if(llDetectedPos(0)==llGetPos())
        {
            llDie();
        }
        else kill_script();
    }
    no_sensor()
    {
        kill_script();
    }
}
