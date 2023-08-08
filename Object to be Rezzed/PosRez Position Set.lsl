##
integer SET = -8923;

vector pos;
rotation rot;
vector offset;
rotation roffset;

integer listener;
integer masteralive;


kill_script()
{
    llRemoveInventory(llGetScriptName());
}

default 
{
    state_entry()
    {
        listener=llListen(SET,"","","");
    }
    
    listen(integer chan, string name, key id, string message) 
    {
        list params = llParseString2List(message,["&&"],[]);
        vector masterpos = (vector)llList2String(params, 1);
        rotation masterrot = (rotation)llList2String(params, 2);
        if(llList2String(params,0)=="Set")
        {
            offset = llGetPos() - masterpos;
            offset = offset / masterrot;
            roffset = llGetRot() / masterrot;
            llSetObjectDesc((string)offset+"&&"+(string)roffset);
            llOwnerSay("Position set");
            kill_script();
        }
    }
    
    
    changed(integer c)
    {
        if(c&CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}
