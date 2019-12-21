library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity keyboardToFSM is
  Port (clock,res,keyclk,keyData,str,ds:in std_logic;
        dOUt,vert,horiz:out std_logic;
        nodeDisplay:out std_logic_vector(3 downto 0);
        timeDisplay: out std_logic_vector(6 downto 0);
        lvlOUT,rgbOut:out std_logic_vector(2 downto 0);
        endOUT:out std_logic_vector(9 downto 0));
end keyboardToFSM;

architecture Behavioral of keyboardToFSM is
signal keycode: std_logic_vector(7 downto 0);
signal newkeycode,slowClk:std_logic;
signal lvlSig,useIn: std_logic_vector(2 downto 0);
signal cook: std_logic_vector(5 downto 0);
signal timeSig: std_logic_vector(9 downto 0);
signal tUP,sigStr,cncl:std_logic;
signal tme,stateO,timeO: std_logic_vector(9 downto 0);

component PS2toBinary port( ps2Code:in std_logic_vector(7 downto 0);
        getUserIn: in std_logic_vector(2 downto 0);
        setTime:out std_logic_vector(9 downto 0);
        cancel: out std_logic;
        cType: out std_logic_vector(5 downto 0);
        level:out std_logic_vector(2 downto 0));
         end component;
         
component ps2_keyboard port(    clk          : IN  STD_LOGIC;                     
         ps2_clk      : IN  STD_LOGIC;                    
         ps2_data     : IN  STD_LOGIC;                    
         ps2_code_new : OUT STD_LOGIC;                
         ps2_code     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));  
         end component;      
         
component microwaveFSM port(clk,reset,start,cancel,timesUP, doorStatus:std_logic;
                  setTime:in std_logic_vector(9 downto 0);
                  cType:in std_logic_vector(5 downto 0);
                  level:in std_logic_vector(2 downto 0);
                  dStat,str:out std_logic;
                  getUserIn:out std_logic_vector(2 downto 0);
                  lvl:out std_logic_vector(2 downto 0);
                  timeSet,state:out std_logic_vector(9 downto 0));
                  end component;
                  
component Clockdivider port(clk : in  STD_LOGIC;
                             reset : in  STD_LOGIC;
                             SlowClock : out  STD_LOGIC);
                             end component; 
                             
component timer port( timeSet: in std_logic_vector(9 downto 0);
                                         doorStatus,start,reset,clk:in std_logic;
                                         timesUP:out std_logic;
                                         timeLeft:out std_logic_vector(9 downto 0));
                                         end component;                                

component sevenSeg port (clk : in STD_LOGIC;   -- 100Mhz clock on Basys 3 FPGA board
                        reset : in STD_LOGIC;
                        timeIN:in std_logic_vector(9 downto 0);
                        anode: out std_logic_vector(3 downto 0);
                        timeSeg:out std_logic_vector(6 downto 0));
end component;   

component  vgaController port(mclk, reset: in std_logic; 
                        timeDisp: in std_logic_vector(9 downto 0);
                        vs, hs: out std_logic; 
                        rgb: out std_logic_vector(2 downto 0)); 
                        
                        end component;                          
                                       

begin
Cdivider: Clockdivider port map(clk=>clock,
                                reset=>res,
                                SlowClock=>slowClk);
                                                             
                                
    
Keyboard: ps2_keyboard port map(clk=>clock,
                                ps2_clk=>keyclk,
                                ps2_data=>keyData,
                                ps2_code_new=>newkeycode,
                                ps2_code=>keycode);
                                
Mapping: PS2toBinary port map(ps2Code=>keycode,
                              getUserIN=>usein,
                              setTime=>timeSig,
                              cancel=>cncl,
                              cType=>cook,
                              level=>lvlSig);
                              
FSM: microwaveFSM port map(clk=>slowClk,
                            reset=>res,
                            start=>str,
                            cancel=>cncl,
                            timesUP=>tUP, 
                            doorStatus=>ds,
                            setTime=>timeSig,
                            cType=>cook,
                            level=>lvlSig,
                            dStat=>dOUT,
                            str=>sigStr,
                            getUserIn=>useIn,
                            lvl=>lvlOUT,
                            timeSet=>tme,
                            state=>endOUT);
                            
TimerComp: timer port map(clk=>slowClk,
                            timeSet=>tme,
                            doorStatus=>ds,
                            start=>str,
                            reset=>res,
                            timesUP=>tUP,
                            timeLeft=>timeO);  
                             
Display: vgaController port map(mclk=>clock,
                           reset=>res,
                           timeDisp=>timeO,
                           vs=>vert,
                           hs=>horiz,
                           rgb=>rgbOut); 
                                      

end Behavioral;
