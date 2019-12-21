library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity timer is port( timeSet: in std_logic_vector(9 downto 0);
   		 doorStatus,start,reset,clk:in std_logic;
   		 timesUP:out std_logic;
   		 timeLeft:out std_logic_vector(9 downto 0));
end entity;

architecture beh of timer is
signal tmpSetTime,tmpTimeLeft:std_logic_vector(9 downto 0);
signal timeDone: std_logic; 
begin

process(reset,clk)
begin
timeDone<='0';         -- default value for timesUP/timeDone
tmpTimeLeft<=timeSet;  -- assigns the input time to signal to be manipulated for timer

if(reset='1')then   --reset will be  assigned to the cancel input
tmpTimeLeft<="0000000000";
timeDone<='0';
elsif(clk'event and (clk='1'))then 
    if(start='1' and doorStatus='0' and timeDone='0')then 
        if(tmpTimeLeft/="0000000000")then
   	        tmpTimeLeft<=tmpTimeLeft-"0000000001";  --decrements the time 
   	
        else
   	         timeDone<='1';  --microwave finished time
   	     end if;
    elsif(doorStatus='1') then    --if the door is open the timer should pause
   	    tmpTimeLeft<=tmpTimeLeft;
    elsif(timeDone='1')then
        tmpTimeLeft<="0000000000"; 	 
    end if;
end if;
end process;
timesUp<=timeDone;
timeLeft<=tmpTimeLeft;
end beh;

