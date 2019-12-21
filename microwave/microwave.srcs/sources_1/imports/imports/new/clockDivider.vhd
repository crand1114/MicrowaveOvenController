----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 12:05:02 PM
-- Design Name: 
-- Module Name: clockDivider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clockdivider is
Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           SlowClock,ledO : out  STD_LOGIC);
end Clockdivider;

architecture behavioral of Clockdivider is
signal slowSig: std_logic;
begin
     process         
      variable cnt :    std_logic_vector(26 downto 0):= "000000000000000000000000000";
          begin                            -- calculations 
            wait until ((clk'EVENT) AND (clk = '1'));   
            if (reset = '1') then
                  cnt := "000000000000000000000000000";
             else  
               cnt := cnt + 1; -- count to 26
             end if;
       
        SlowClock <= cnt(26);  
        slowSig<=cnt(26);
        
      if(slowSig='1')then 
        ledO<='1';
      else
        ledO<='0';
      end if;       
   end process;
end Behavioral;

