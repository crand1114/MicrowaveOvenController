library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity microwaveFSM is
  Port (clk,reset,start,cancel,timesUP, doorStatus:std_logic;
         setTime:in std_logic_vector(9 downto 0);
         cType:in std_logic_vector(5 downto 0);
         level:in std_logic_vector(2 downto 0);
         dStat,str:out std_logic;
         getUserIn:out std_logic_vector(2 downto 0);
         lvl:out std_logic_vector(2 downto 0);
         timeSet,state:out std_logic_vector(9 downto 0));
end microwaveFSM;

architecture Behavioral of microwaveFSM is
signal customT,tme: std_logic_Vector(9 downto 0);
signal customP,power,userIN: std_logic_vector(2 downto 0);
type state_type is(Standby,C1,C2,C3,C4,C5,inPOwer,inTime,Cook,Pause,Finished);
signal cs,ns:state_type;
begin
process(clk,reset)
begin
        if(reset='1')then
            cs<=Standby;
        elsif(clk'event and clk='1')then
            cs<=ns;
        end if;
end process;

process(cs,cancel,start,tme)
begin
timeSet<="0000000000";
dStat<=doorStatus;
str<=Start;
getUserIN<="000";
lvl<="000";
customP<="000";

case cs is

--standby mode
when StandBy =>  
tme<="0000000000";
state<="0000000001";
userIN<="001";
    if(userIn="001")then
    getUserIN<=userIN;
                if(cType="100000")then--custom
                ns<=inPower;
                elsif(CType="010000")then--preset 1
                ns<=C1;
                elsif(CType="001000")then--preset 2
                ns<=C2;
                elsif(CType="000100")then 
                ns<=C3;
                elsif(CType="000010")then
                ns<=C4;
                elsif(CType="000001")then
                ns<=C5;
                else
                ns<=Standby;
                end if;                 
     end if;
--preset settings 1
when C1 =>
state<="0000000010";
        customP<="001";
        power<=customP;
        customT<="0000001111";--15 sec
        tme<=customT;
        if(doorStatus='0' and start='1')then
        ns<=Cook;
        elsif(cancel='1')then
        ns<=Standby;
        
        else
        ns<=cs;
        end if;
        
--preset settings 2
when C2 =>
state<="0000000100";
        customP<="010";
        power<=customP;
        customT<="0000001010";--10 sec
        tme<=customT;
        if(doorStatus='0' and start='1')then
        ns<=Cook;
        elsif(cancel='1')then
        ns<=Standby;
        
        else
        ns<=cs;
        end if;   
        
--preset settings 3
when C3 =>
state<="0000001000";
        customP<="100";
        power<=customP;
        customT<="0000011110";--30 sec
        tme<=customT;
        if(doorStatus='0' and start='1')then
        ns<=Cook;
        elsif(cancel='1')then
        ns<=Standby;
        else
        ns<=cs;
        end if;

--preset settings 4
when C4 =>
state<="0000010000";
       customP<="100";
       power<=customP;
        customT<="0000101101";--45 sec
        tme<=customT;
        if(doorStatus='0' and start='1')then
        ns<=Cook;
        elsif(cancel='1')then
        ns<=Standby;
        else
        ns<=cs;
        end if;
        
--preset settings 5
when C5 =>
state<="0000100000";
        customP<="010";
        power<=customP;
        customT<="0000011010";--25 sec
        tme<=customT;        
        if(doorStatus='0' and start='1')then
        ns<=Cook;
        elsif(cancel='1')then
        ns<=Standby;
        else
        ns<=cs;
        end if;
        
--custosm Power
when inPower =>
tme<="0000000000";
state<="0001000000";--inPower state
userIN<="010";
    if(userIn="010")then
    getUserIN<=userIN;
        power<=level;
        
        if(power/="000")then
        ns<=inTime;
        
        elsif(cancel='1')then
                ns<=Standby;
                else
                ns<=cs;
                end if;
      end if;
        
--custosm Time
when inTime =>
power<=level;
state<="0010000000";
userIN<="100";
if(userIn="100")then
    getUserIN<=userIN;
    tme<=setTime;
 if(start = '1' and tme/="0000000000" and doorStatus='0')then  --if start is pressed and a time has been input by user  and the door is closed then go to cook state
            ns<= cook;          
    elsif(cancel='1')then
      ns<=Standby;
  else
       ns<=cs;
        end if;
        end if;








--cooking state
when Cook =>
power<=level;
state<="0100000000";
        if(doorStatus='1')then
             ns<=Pause;
        elsif(timesUP='1')then
            ns<=Finished;

        elsif(cancel='1')then
             ns<=Standby;
        elsif(timesUP='0')then
            ns<=cs;
        end if;
        
        
       
       
       
       
        
--pause state
when Pause =>
power<=level;
state<="1000000000";
if(doorStatus='0')then
        ns<=cook;
elsif(cancel='1')then
        ns<=Standby;
else
ns<=cs;        
        end if;

--finished cooking
when Finished =>
tme<="0000000000";
state<="1111111111";
if(cancel='1' and  doorStatus='1')then -- user opens the door and a presses cancel button on keyboard to end their cook cycle
        ns<=Standby;
else
ns<=cs;        
        end if;
        
end case;
lvl<=power;
timeSet<=tme;

end process;



end Behavioral;



