integer chan = -2637;
integer listener;

delete()
{
    llDie();    
    llOwnerSay("bye-bye");
}


remove()
{
    llRemoveInventory(llGetScriptName());
    llOwnerSay("Script deleted...");
}

default
{
    state_entry()
    {
        listener = llListen(chan,"","","");
        llListenControl(listener, FALSE);
    }

    touch_start(integer total_number)
    {
        llListenControl(listener, TRUE);
        llSetTimerEvent(60);
        llDialog(llDetectedKey(0),"What shall I do? \n 1. Remove Scripts \n 2. Delete Item",["1","2"],chan);
    }
    
    listen(integer ch, string name, key id, string msg)
    {
        llSetTimerEvent(0);
        llListenControl(listener, FALSE);
        //llOwnerSay(msg);
        if(msg=="1")
        {
           remove();
        }
        else if(msg=="2")
        {
            delete();
        }
    }
    
    timer()
    {
        llListenControl(listener, FALSE);
    }
    
    changed(integer C)
    {
        if(C&CHANGED_OWNER)
        {
            llResetScript();
        }
    }
        
}
