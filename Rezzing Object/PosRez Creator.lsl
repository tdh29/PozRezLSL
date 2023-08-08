integer MENU = -28903;
integer SET = -8923;
integer REZ_MENU = -92837;
integer handle;
integer rez_handle;
 
list    BUTTONS = [];          
integer CURRENT_DIALOG = 0;  
integer INVENTORY_NUMBER = 0;  
integer MAX_MENUS = 0;       
                                        
string  ITEMS = "";
integer i = 0;                          
key     TOUCHER;                    

list ORDER_BUTTONS(list buttons) 
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4)
         + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

showMenu() 
{
    llListenControl(rez_handle,TRUE);
    BUTTONS = [];
    ITEMS = "";
    i=0;
    do 
    {
        if (llGetInventoryName(INVENTORY_OBJECT, CURRENT_DIALOG*9+i) != "") 
        {
            BUTTONS += (string)(CURRENT_DIALOG*9+i);
            ITEMS += "\n" + (string)(CURRENT_DIALOG*9+i) + ") " +
            llGetInventoryName(INVENTORY_OBJECT, CURRENT_DIALOG*9+i);
        }
    } 
    while (i++ < 8);
    BUTTONS += "<---";
    BUTTONS += "OPTIONS"; 
    BUTTONS += "--->"; 

    llDialog(TOUCHER,
             "\nPlease select item  Menu No." + (string)( CURRENT_DIALOG+1) + "/" + 
             (string)(MAX_MENUS+1) + "\n"+ITEMS,
             ORDER_BUTTONS(BUTTONS),
             REZ_MENU);
}
    
    
rez(string object)
{
    llRezObject(object,llGetPos() + <0.0,0.0,0>, <0.0,0.0,0.0>, llGetRot(), 1);
    llSay(MENU,"Place&&"+(string)llGetPos()+"&&"+(string)llGetRot());
}

on()
{
    llListenControl(handle, TRUE);
    llSetTimerEvent(60);
}

off()
{
    llListenControl(rez_handle, FALSE);
    llListenControl(handle, FALSE);
    llSetTimerEvent(0);
}
    
reset()
{
    llResetScript();
}

Rez_Menu()
{
    INVENTORY_NUMBER = llGetInventoryNumber(INVENTORY_OBJECT);  
    MAX_MENUS = llFloor(INVENTORY_NUMBER/9); 
    if ((((float)INVENTORY_NUMBER/9) - llFloor((float)INVENTORY_NUMBER/9))==0)  MAX_MENUS--;
    CURRENT_DIALOG = 0;
    showMenu();
}

rez_all()
{
    integer x = llGetInventoryNumber(INVENTORY_OBJECT);
    integer y;
    for(y=0;y<=x;y++)
    {
        string temp = llGetInventoryName(INVENTORY_OBJECT,y);
        if(temp!="")
        {
            rez(temp);
        }
    }          
}


default
{
    state_entry()
    {
        handle=llListen(MENU,"","","");
        rez_handle=llListen(REZ_MENU,"","","");
        off();
    }

    touch_start(integer total_number)
    {
        on();
        llDialog(llDetectedKey(0),"Choose option",["Set","Rez"],MENU);
        llListenControl(handle, TRUE);
        TOUCHER = llDetectedKey(0);
    }
    
    listen(integer chan, string name,key id,  string message)
    {
        TOUCHER = id; 
        off();
        if(chan==MENU)
        {
            if(message=="Rez")
            {
                Rez_Menu();
                llListenControl(rez_handle,TRUE);
            }
            else if(message=="Set")
            {
                llOwnerSay("Setting positions");
                llSay(SET,"Set&&"+(string)llGetPos()+"&&"+(string)llGetRot());
            }
            else if(message=="Rez All")
            {
                rez_all();   
            }
        }
        
        else if(chan==REZ_MENU)
        {
            if (message == "--->") 
            { 
                if (CURRENT_DIALOG<MAX_MENUS) 
                {
                    CURRENT_DIALOG++; 
                } 
                else 
                {
                    CURRENT_DIALOG = 0;
                }
                showMenu();
            } 
            
            else if (message == "<---") 
            {
                if (CURRENT_DIALOG>0)                     
                {
                    --CURRENT_DIALOG; 
                } 
                else 
                {
                    CURRENT_DIALOG =  MAX_MENUS;
                }
                showMenu(); 
            }
            else if (message == "OPTIONS") 
            {
                llListenControl(handle,TRUE);
                llSetTimerEvent(60);
                llDialog(TOUCHER,"What shall we do?",["Exit Menu","Rez All"],MENU);
            }
            
            else 
            {
                rez(llGetInventoryName(INVENTORY_OBJECT,(integer)message));
                showMenu();
            }            
        }         
    }
    
    timer()
    {
        off();
    }
     
    changed(integer C)
    {
        if(C&CHANGED_INVENTORY|C&CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}
