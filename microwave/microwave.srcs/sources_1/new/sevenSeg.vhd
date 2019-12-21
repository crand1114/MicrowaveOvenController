----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2019 12:27:35 PM
-- Design Name: 
-- Module Name: sevenSeg - Behavioral
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

entity sevenSeg is
 Port (clk : in STD_LOGIC;   -- 100Mhz clock on Basys 3 FPGA board
            reset : in STD_LOGIC;
            timeIN:in std_logic_vector(9 downto 0);
            anode: out std_logic_vector(3 downto 0);
            timeSeg:out std_logic_vector(6 downto 0));
end sevenSeg;

architecture Behavioral of sevenSeg is
signal one_second_counter: STD_LOGIC_VECTOR (27 downto 0);
-- counter for generating 1-second clock enable
signal one_second_enable: std_logic;
-- one second enable for counting numbers
signal displayed_number: STD_LOGIC_VECTOR (9 downto 0);
-- counting decimal number to be displayed on 4-digit 7-segment display
signal LED_BCD: STD_LOGIC_VECTOR (4 downto 0);
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
-- creating 10.5ms refresh period
signal LED_activating_counter: std_logic_vector(1 downto 0);
begin
displayed_number<=timeIN;

process(LED_BCD)
begin
    case LED_BCD is
    when "00000" => timeSeg <= "0000001"; -- "0"     
    when "00001" => timeSeg <= "1001111"; -- "1" 
    when "00010" => timeSeg <= "0010010"; -- "2" 
    when "00011" => timeSeg <= "0000110"; -- "3" 
    when "00100" => timeSeg <= "1001100"; -- "4" 
    when "00101" => timeSeg <= "0100100"; -- "5" 
    when "00110" => timeSeg <= "0100000"; -- "6" 
    when "00111" => timeSeg <= "0001111"; -- "7" 
    when "01000" => timeSeg <= "0000000"; -- "8"     
    when "01001" => timeSeg <= "0000100"; -- "9" 
    when "01010" => timeSeg <= "0000010"; -- a
    when "01011" => timeSeg <= "1100000"; -- b
    when "01100" => timeSeg <= "0110001"; -- C
    when "01101" => timeSeg <= "1000010"; -- d
    when "01110" => timeSeg <= "0110000"; -- E
    when "01111" => timeSeg <= "0111000"; -- F
    when others=> timeSeg<="1111111";
    end case;
end process;
-- 7-segment display controller


-- generate refresh period of 10.5ms
process(clk,reset)
begin 
    if(reset='1') then
        refresh_counter <= (others => '0');
    elsif(clk'event and clk='1') then
        refresh_counter <= refresh_counter + 1;
    end if;
end process;
 LED_activating_counter <= refresh_counter(19 downto 18);

-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "01" =>
        anode <= "1011"; 
        -- activate LED2 and Deactivate LED1, LED3, LED4
        LED_BCD <= "000" & displayed_number( 9 downto 8);
        -- the second hex digit of the 16-bit number
    when "10" =>
        anode <= "1101"; 
        -- activate LED3 and Deactivate LED2, LED1, LED4
        LED_BCD <='0'& displayed_number(7 downto 4);
        -- the third hex digit of the 16-bit number
    when "11" =>
        anode <= "1110"; 
        -- activate LED4 and Deactivate LED2, LED3, LED1
        LED_BCD <= '0'&displayed_number(3 downto 0);
        --  
    when others=>
        LED_BCD<= "10000"; 
    end case;
end process;

end Behavioral;