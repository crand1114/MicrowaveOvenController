----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2019 12:33:33 PM
-- Design Name: 
-- Module Name: vgaTop - Behavioral
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


library IEEE;
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

entity vgaTop is
  Port (clock,res:in std_logic;
        hS,vS:out std_logic;
        r,g,b:out std_logic_vector(3 downto 0));
end vgaTop;

architecture Behavioral of vgaTop is
signal sigCol,sigRow: integer;
signal enable,nblank,nsync,sigCLK: std_logic;


component  vga_controller PORT(
		pixel_clk	:	IN		STD_LOGIC;	--pixel clock at frequency of VGA mode being used
		reset_n		:	IN		STD_LOGIC;	--active low asycnchronous reset
		h_sync		:	OUT	STD_LOGIC;	--horiztonal sync pulse
		v_sync		:	OUT	STD_LOGIC;	--vertical sync pulse
		disp_ena		:	OUT	STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		column		:	OUT	INTEGER;		--horizontal pixel coordinate
		row			:	OUT	INTEGER;		--vertical pixel coordinate
		n_blank		:	OUT	STD_LOGIC;	--direct blacking output to DAC
		n_sync		:	OUT	STD_LOGIC); --sync-on-green output to DAC
END component;

component hw_image_generator PORT(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
    red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END component;
           
component Clockdivider port(clk : in  STD_LOGIC;
                             reset : in  STD_LOGIC;
                             SlowClock : out  STD_LOGIC);
                             end component;                                        

begin

ClockDivide: clockdivider port map( clk=>clock,
                                    reset=>res,
                                    slowClock=>sigCLK);

VGA: vga_controller port map(pixel_clk=>sigCLK,
                             reset_n=>res,
                             h_sync=>hs,
                             v_sync=>vs,
                             disp_ena=>enable,
                             column=>sigCol,
                             row=>sigRow,
                             n_blank=>nblank,
                             n_sync=>nsync);
                             
Image: hw_image_generator port map( disp_ena=>enable,
                                    row=>sigRow,
                                    column=>sigCol,
                                    red=>r,
                                    green=>g,
                                    blue=>b);                             

                                      

end Behavioral;