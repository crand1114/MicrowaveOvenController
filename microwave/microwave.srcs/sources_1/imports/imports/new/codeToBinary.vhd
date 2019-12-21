library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PS2toBinary is
  Port (  ps2Code:in std_logic_vector(7 downto 0);
        getUserIn: in std_logic_vector(2 downto 0);
        setTime:out std_logic_vector(9 downto 0);
        cancel: out std_logic;
        cType: out std_logic_vector(5 downto 0);
        level:out std_logic_vector(2 downto 0));
       
        
end PS2toBinary;

architecture Behavioral of PS2toBinary is
signal tmpCancel: std_logic;
signal tmpTime: std_logic_vector(9 downto 0);
signal tmpCook: std_logic_vector(5 downto 0);
signal tmpLevel:std_logic_vector(2 downto 0);


begin
process(getUserIn,ps2Code)
begin
tmpCancel<='0';
tmpCook<="000000";
tmpTime<="0000000000";
tmpLevel<="000";


case ps2Code is

--Cook Type Options
when "00010101"=> --Q custom
                   if(getUserIn="001")then
                    tmpCook<="100000";
                    end if;
                    
when "00011101"=> --W preset1
                   if(getUserIn="001")then
                    tmpCook<="010000";
                    end if;

when "00100100"=> --E preset2
                   if(getUserIn="001")then
                    tmpCook<="001000";
                    end if;
                    
when "00101101"=> --R preset3
                    if(getUserIn="001")then
                    tmpCook<="000100";
                    end if;

when "00101100"=> --T preset4
                   if(getUserIn="001")then
                    tmpCook<="000010";
                     end if;
                     
when "00110101"=> --Y preset5
                     if(getUserIn="001")then
                     tmpCook<="000001";
                     end if;

--=Power level options
when "00011100"=> --A  High
                     if(getUserIn="010")then
                     tmpLevel<="100";
                     end if;
                
when "00011011"=> --S Medium
                     if(getUserIn="010")then
                        tmpLevel<="010";
                        end if;
                    
when "00100011"=> --D Low
                     if(getUserIn="010")then
                        tmpLevel<="001";
                     end if;
-- Time Options 
when "00010110"=> --1
                   if(getUserIn="100")then
                    tmpTime<="0000111100";
                    
                    end if;
                    
when "00011110"=> --2
                    if(getUserIn="100")then
                        tmpTime<="0001111000";
                      
                    end if;    
when "00100110"=> --3
                    if(getUserIn="100")then
                        tmpTime<="0010110100";
                       
                    end if;
when "00100101"=> --4
                    if(getUserIn="100")then
                        tmpTime<="0011110000";
                        
                    end if;

when "00101110"=> --5
                    if(getUserIn="100")then
                        tmpTime<="0100101100";
                      
                    end if;
when "00110110"=> --6
                    if(getUserIn="100")then
                        tmpTime<="0101101000";
                        
                    end if;           
when "00111101"=> --7
                    if(getUserIn="100")then
                        tmpTime<="0110100100";
                       
                    end if;  
when "00111110"=> --8
                    if(getUserIn="100")then
                        tmpTime<="0111100000";
                        
                    end if;            
when "01000110"=> --9
                    if(getUserIn="100")then
                        tmpTime<="1000011100";
                        
                    end if;
when "01000101"=> --0
                    if(getUserIn="100")then
                        tmpTime<="1001011000";
                       
                    end if;
  --cancel/break                 
when "01110110"=>      --esc(escape key)          
                     tmpCancel<='1';   

when others=>
                    tmpCancel<=tmpCancel;
                    tmpTime<=tmpTime;
                    tmpCook<=tmpCook;
                    tmpLevel<=tmpLevel;
                   
            

end case;
cancel<=tmpCancel;
setTime<=tmpTime;
cType<=tmpCook;
level<=tmpLevel;

end process;
end Behavioral;
