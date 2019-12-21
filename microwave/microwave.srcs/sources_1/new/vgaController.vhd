library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vgaController is port(mclk, reset: in std_logic; 
                        timeDisp: in std_logic_vector(9 downto 0);
                        vs, hs: out std_logic; 
                        rgb: out std_logic_vector(2 downto 0)); 
                        attribute syn_noclockbuf : boolean; 
                        end vgaController; 

architecture Behavioral of vgaController is 

signal clkPix: std_logic; 
signal cntHorz, cntVert: std_logic_vector(9 downto 0); 
signal sncHorz, clkLine, blkHorz, sncVert, blkVert, blkDisp, clkColor: std_logic; 
signal cntImg: std_logic_vector(6 downto 0); 
signal cntColor: std_logic_vector(2 downto 0); 
signal upper, left, lower, right: std_logic_vector(11 downto 0); 
signal upper2, left2, lower2, right2: std_logic_vector(11 downto 0); 
signal upper3, left3, lower3, right3: std_logic_vector(11 downto 0); 
signal cnt1 : integer:= 0; 
signal cnt2 : integer:= 0; 
signal cnt3 : integer:= 0; 
signal cnt4 : integer:= 0; -- 
signal cnt5 : integer:= 0;
type value is array (0 to 31) of std_logic_vector( 0 to 31 ); 
--type value is array(31 downto 0) of std_logic_vector(31 downto 0);

constant blankDIS: value := (
0  =>"00000000000000000000000000000000", 
1  =>"00000000000000000000000000000000", 
2  =>"00000000000000000000000000000000", 
3  =>"00000000000000000000000000000000", 
4  =>"00000000000000000000000000000000", 
5  =>"00000000000000000000000000000000", 
6  =>"00000000000000000000000000000000", 
7  =>"00000000000000000000000000000000", 
8  =>"00000000000000000000000000000000", 
9  =>"00000000000000000000000000000000", 
10 =>"00000000000000000000000000000000", 
11 =>"00000000000000000000000000000000", 
12 =>"00000000000000000000000000000000", 
13 =>"00000000000000000000000000000000", 
14 =>"00000000000000000000000000000000", 
15 =>"00000000000000000000000000000000", 
16 =>"00000000000000000000000000000000", 
17 =>"00000000000000000000000000000000", 
18 =>"00000000000000000000000000000000", 
19 =>"00000000000000000000000000000000", 
20 =>"00000000000000000000000000000000", 
21 =>"00000000000000000000000000000000", 
22 =>"00000000000000000000000000000000", 
23 =>"00000000000000000000000000000000", 
24 =>"00000000000000000000000000000000", 
25 =>"00000000000000000000000000000000", 
26 =>"00000000000000000000000000000000", 
27 =>"00000000000000000000000000000000", 
28 =>"00000000000000000000000000000000", 
29 =>"00000000000000000000000000000000", 
30 =>"00000000000000000000000000000000", 
31 =>"00000000000000000000000000000000"); 

constant zeroDis: value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000001111111100", 
4  =>"00111111110000000000001111111100", 
5  =>"00111111110000000000001111111100", 
6  =>"00111111110000000000001111111100", 
7  =>"00111111110000000000001111111100", 
8  =>"00111111110000000000001111111100", 
9  =>"00111111110000000000001111111100", 
10 =>"00111111110000000000001111111100", 
11 =>"00111111110000000000001111111100", 
12 =>"00111111110000000000001111111100", 
13 =>"00111111110000000000001111111100", 
14 =>"00111111110000000000001111111100", 
15 =>"00111111110000000000001111111100", 
16 =>"00111111110000000000001111111100", 
17 =>"00111111110000000000001111111100", 
18 =>"00111111110000000000001111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant oneDis : value := (
0 =>"00000000011111111111000000000000", 
1  =>"00000000110111111111000000000000", 
2  =>"00000001110111111111000000000000", 
3  =>"00000011110111111111000000000000", 
4  =>"00000111110111111111000000000000", 
5  =>"00001111110111111111000000000000", 
6  =>"00000000000111111111000000000000", 
7  =>"00000000000111111111000000000000", 
8  =>"00000000000111111111000000000000", 
9  =>"00000000000111111111000000000000", 
10 =>"00000000000111111111000000000000", 
11 =>"00000000000111111111000000000000", 
12 =>"00000000000111111111000000000000", 
13 =>"00000000000111111111000000000000", 
14 =>"00000000000111111111000000000000", 
15 =>"00000000000111111111000000000000", 
16 =>"00000000000111111111000000000000", 
17 =>"00000000000111111111000000000000", 
18 =>"00000000000111111111000000000000", 
19 =>"00000000000111111111000000000000", 
20 =>"00000000000111111111000000000000", 
21 =>"00000000000111111111000000000000", 
22 =>"00000000000111111111000000000000",
23 =>"00000000000111111111000000000000", 
24 =>"00000000000111111111000000000000", 
25 =>"00000000000111111111000000000000", 
26 =>"00000000000111111111000000000000", 
27 =>"00000000000111111111000000000000", 
28 =>"00000000000111111111000000000000", 
29 =>"00000000000111111111000000000000", 
30 =>"11111111111111111111111111111111", 
31 =>"11111111111111111111111111111111"); 

constant twoDis : value := (
0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00000000000000000000001111111100", 
4  =>"00000000000000000000001111111100", 
5  =>"00000000000000000000001111111100", 
6  =>"00000000000000000000001111111100", 
7  =>"00000000000000000000001111111100", 
8  =>"00000000000000000000001111111100", 
9  =>"00000000000000000000001111111100", 
10 =>"00000000000000000000001111111100", 
11 =>"00000000000000000000001111111100", 
12 =>"00000000000000000000001111111100", 
13 =>"00000000000000000000001111111100", 
14 =>"00000000000000000000001111111100", 
15 =>"00000000000000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000000000000000", 
20 =>"00111111110000000000000000000000", 
21 =>"00111111110000000000000000000000", 
22 =>"00111111110000000000000000000000", 
23 =>"00111111110000000000000000000000", 
24 =>"00111111110000000000000000000000", 
25 =>"00111111110000000000000000000000", 
26 =>"00111111110000000000000000000000", 
27 =>"00111111110000000000000000000000", 
28 =>"00111111110000000000000000000000", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant threeDis: value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00000000000000000000001111111100", 
4  =>"00000000000000000000001111111100", 
5  =>"00000000000000000000001111111100", 
6  =>"00000000000000000000001111111100", 
7  =>"00000000000000000000001111111100",
8  =>"00000000000000000000001111111100", 
9  =>"00000000000000000000001111111100", 
10 =>"00000000000000000000001111111100", 
11 =>"00000000000000000000001111111100", 
12 =>"00000000000000000000001111111100", 
13 =>"00000000000000000000001111111100", 
14 =>"00000000000000000000001111111100", 
15 =>"00000000000000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00000000000000000000001111111100", 
20 =>"00000000000000000000001111111100", 
21 =>"00000000000000000000001111111100", 
22 =>"00000000000000000000001111111100", 
23 =>"00000000000000000000001111111100", 
24 =>"00000000000000000000001111111100", 
25 =>"00000000000000000000001111111100", 
26 =>"00000000000000000000001111111100", 
27 =>"00000000000000000000001111111100", 
28 =>"00000000000000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant fourDis : value := (
0  =>"00111111110000000000001111111100", 
1  =>"00111111110000000000001111111100", 
2  =>"00111111110000000000001111111100", 
3  =>"00111111110000000000001111111100", 
4  =>"00111111110000000000001111111100", 
5  =>"00111111110000000000001111111100", 
6  =>"00111111110000000000001111111100", 
7  =>"00111111110000000000001111111100", 
8  =>"00111111110000000000001111111100", 
9  =>"00111111110000000000001111111100", 
10 =>"00111111110000000000001111111100", 
11 =>"00111111110000000000001111111100", 
12 =>"00111111110000000000001111111100", 
13 =>"00111111110000000000001111111100", 
14 =>"00111111110000000000001111111100", 
15 =>"00111111110000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00000000000000000000001111111100", 
20 =>"00000000000000000000001111111100", 
21 =>"00000000000000000000001111111100", 
22 =>"00000000000000000000001111111100", 
23 =>"00000000000000000000001111111100", 
24 =>"00000000000000000000001111111100", 
25 =>"00000000000000000000001111111100", 
26 =>"00000000000000000000001111111100", 
27 =>"00000000000000000000001111111100", 
28 =>"00000000000000000000001111111100", 
29 =>"00000000000000000000001111111100", 
30 =>"00000000000000000000001111111100", 
31 =>"00000000000000000000001111111100"); 


constant fiveDis : value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00000000000000000000001111111100", 
20 =>"00000000000000000000001111111100", 
21 =>"00000000000000000000001111111100", 
22 =>"00000000000000000000001111111100", 
23 =>"00000000000000000000001111111100", 
24 =>"00000000000000000000001111111100", 
25 =>"00000000000000000000001111111100", 
26 =>"00000000000000000000001111111100", 
27 =>"00000000000000000000001111111100", 
28 =>"00000000000000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant sixDis : value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 


constant sevenDis: value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00000000000000000000001111111100", 
4  =>"00000000000000000000001111111100", 
5  =>"00000000000000000000001111111100", 
6  =>"00000000000000000000001111111100", 
7  =>"00000000000000000000001111111100", 
8  =>"00000000000000000000001111111100", 
9  =>"00000000000000000000001111111100", 
10 =>"00000000000000000000001111111100", 
11 =>"00000000000000000000001111111100", 
12 =>"00000000000000000000001111111100", 
13 =>"00000000000000000000001111111100", 
14 =>"00000000000000000000001111111100", 
15 =>"00000000000000000000001111111100", 
16 =>"00000000000000000000001111111100", 
17 =>"00000000000000000000001111111100", 
18 =>"00000000000000000000001111111100", 
19 =>"00000000000000000000001111111100", 
20 =>"00000000000000000000001111111100", 
21 =>"00000000000000000000001111111100", 
22 =>"00000000000000000000001111111100", 
23 =>"00000000000000000000001111111100", 
24 =>"00000000000000000000001111111100", 
25 =>"00000000000000000000001111111100", 
26 =>"00000000000000000000001111111100", 
27 =>"00000000000000000000001111111100", 
28 =>"00000000000000000000001111111100", 
29 =>"00000000000000000000001111111100", 
30 =>"00000000000000000000001111111100", 
31 =>"00000000000000000000001111111100"); 

constant eightDis: value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000001111111100", 
4  =>"00111111110000000000001111111100", 
5  =>"00111111110000000000001111111100", 
6  =>"00111111110000000000001111111100", 
7  =>"00111111110000000000001111111100", 
8  =>"00111111110000000000001111111100", 
9  =>"00111111110000000000001111111100", 
10 =>"00111111110000000000001111111100", 
11 =>"00111111110000000000001111111100", 
12 =>"00111111110000000000001111111100", 
13 =>"00111111110000000000001111111100", 
14 =>"00111111110000000000001111111100", 
15 =>"00111111110000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 


constant nineDis : value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000001111111100", 
4  =>"00111111110000000000001111111100", 
5  =>"00111111110000000000001111111100", 
6  =>"00111111110000000000001111111100", 
7  =>"00111111110000000000001111111100", 
8  =>"00111111110000000000001111111100", 
9  =>"00111111110000000000001111111100", 
10 =>"00111111110000000000001111111100", 
11 =>"00111111110000000000001111111100", 
12 =>"00111111110000000000001111111100", 
13 =>"00111111110000000000001111111100", 
14 =>"00111111110000000000001111111100", 
15 =>"00111111110000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00000000000000000000001111111100", 
20 =>"00000000000000000000001111111100", 
21 =>"00000000000000000000001111111100", 
22 =>"00000000000000000000001111111100", 
23 =>"00000000000000000000001111111100", 
24 =>"00000000000000000000001111111100", 
25 =>"00000000000000000000001111111100", 
26 =>"00000000000000000000001111111100", 
27 =>"00000000000000000000001111111100", 
28 =>"00000000000000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant tenDis : value := (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000001111111100", 
4  =>"00111111110000000000001111111100", 
5  =>"00111111110000000000001111111100", 
6  =>"00111111110000000000001111111100", 
7  =>"00111111110000000000001111111100", 
8  =>"00111111110000000000001111111100", 
9  =>"00111111110000000000001111111100", 
10 =>"00111111110000000000001111111100", 
11 =>"00111111110000000000001111111100", 
12 =>"00111111110000000000001111111100", 
13 =>"00111111110000000000001111111100", 
14 =>"00111111110000000000001111111100", 
15 =>"00111111110000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111110000000000001111111100", 
30 =>"00111111110000000000001111111100", 
31 =>"00111111110000000000001111111100"); 

constant elevenDis:value:= (

0  =>"00111111110000000000000000000000", 
1  =>"00111111110000000000000000000000", 
2  =>"00111111110000000000000000000000", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant twelveDis:value:= (

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111110000000000000000000000", 
17 =>"00111111110000000000000000000000", 
18 =>"00111111110000000000000000000000", 
19 =>"00111111110000000000000000000000", 
20 =>"00111111110000000000000000000000", 
21 =>"00111111110000000000000000000000", 
22 =>"00111111110000000000000000000000", 
23 =>"00111111110000000000000000000000", 
24 =>"00111111110000000000000000000000", 
25 =>"00111111110000000000000000000000", 
26 =>"00111111110000000000000000000000", 
27 =>"00111111110000000000000000000000", 
28 =>"00111111110000000000000000000000", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant thirteenDis:value:=(

0  =>"00000000000000000000001111111100", 
1  =>"00000000000000000000001111111100", 
2  =>"00000000000000000000001111111100", 
3  =>"00000000000000000000001111111100", 
4  =>"00000000000000000000001111111100", 
5  =>"00000000000000000000001111111100", 
6  =>"00000000000000000000001111111100", 
7  =>"00000000000000000000001111111100", 
8  =>"00000000000000000000001111111100", 
9  =>"00000000000000000000001111111100", 
10 =>"00000000000000000000001111111100", 
11 =>"00000000000000000000001111111100", 
12 =>"00000000000000000000001111111100", 
13 =>"00000000000000000000001111111100", 
14 =>"00000000000000000000001111111100", 
15 =>"00000000000000000000001111111100", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000001111111100", 
20 =>"00111111110000000000001111111100", 
21 =>"00111111110000000000001111111100", 
22 =>"00111111110000000000001111111100", 
23 =>"00111111110000000000001111111100", 
24 =>"00111111110000000000001111111100", 
25 =>"00111111110000000000001111111100", 
26 =>"00111111110000000000001111111100", 
27 =>"00111111110000000000001111111100", 
28 =>"00111111110000000000001111111100", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant fourteenDis:value:=(

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000000000000000", 
20 =>"00111111110000000000000000000000", 
21 =>"00111111110000000000000000000000", 
22 =>"00111111110000000000000000000000", 
23 =>"00111111110000000000000000000000", 
24 =>"00111111110000000000000000000000", 
25 =>"00111111110000000000000000000000", 
26 =>"00111111110000000000000000000000", 
27 =>"00111111110000000000000000000000", 
28 =>"00111111110000000000000000000000", 
29 =>"00111111111111111111111111111100", 
30 =>"00111111111111111111111111111100", 
31 =>"00111111111111111111111111111100"); 

constant fifteenDis :value:=(

0  =>"00111111111111111111111111111100", 
1  =>"00111111111111111111111111111100", 
2  =>"00111111111111111111111111111100", 
3  =>"00111111110000000000000000000000", 
4  =>"00111111110000000000000000000000", 
5  =>"00111111110000000000000000000000", 
6  =>"00111111110000000000000000000000", 
7  =>"00111111110000000000000000000000", 
8  =>"00111111110000000000000000000000", 
9  =>"00111111110000000000000000000000", 
10 =>"00111111110000000000000000000000", 
11 =>"00111111110000000000000000000000", 
12 =>"00111111110000000000000000000000", 
13 =>"00111111110000000000000000000000", 
14 =>"00111111110000000000000000000000", 
15 =>"00111111110000000000000000000000", 
16 =>"00111111111111111111111111111100", 
17 =>"00111111111111111111111111111100", 
18 =>"00111111111111111111111111111100", 
19 =>"00111111110000000000000000000000", 
20 =>"00111111110000000000000000000000", 
21 =>"00111111110000000000000000000000", 
22 =>"00111111110000000000000000000000", 
23 =>"00111111110000000000000000000000", 
24 =>"00111111110000000000000000000000", 
25 =>"00111111110000000000000000000000", 
26 =>"00111111110000000000000000000000", 
27 =>"00111111110000000000000000000000", 
28 =>"00111111110000000000000000000000", 
29 =>"00111111110000000000000000000000", 
30 =>"00111111110000000000000000000000", 
31 =>"00111111110000000000000000000000"); 



signal node0: value; 
signal node1: value; 
signal node2: value; 


begin ------------------------------------------------------------------------ 

-- VGA Controller Test 

------------------------------------------------------------------------ 
 




left2 <= X"1A8"; --
right2 <= X"1CA"; --
lower2 <= X"173"; --
upper2<= X"152"; --

left3  <= X"160"; --
right3 <= X"182"; --
lower3 <= X"173"; --
upper3 <= X"152"; --

node0<=zeroDis when (timeDisp(3 downto 0) = "0000") else 
oneDis when (timeDisp(3 downto 0) = "0001") else 
twoDis when (timeDisp(3 downto 0) = "0010") else 
threeDis when (timeDisp(3 downto 0) = "0011") else 
fourDis when (timeDisp(3 downto 0) = "0100") else 
fiveDis when (timeDisp(3 downto 0) = "0101") else 
sixDis when (timeDisp(3 downto 0) = "0110") else 
sevenDis when (timeDisp(3 downto 0) = "0111") else 
eightDis when (timeDisp(3 downto 0) = "1000") else 
nineDis when (timeDisp(3 downto 0) = "1001") else 
tenDis when (timeDisp(3 downto 0) = "1010") else 
elevenDis when (timeDisp(3 downto 0) = "1011") else 
twelveDis when (timeDisp(3 downto 0) = "1100") else 
thirteenDis when (timeDisp(3 downto 0) = "1101") else 
fourteenDis when (timeDisp(3 downto 0) = "1110") else 
fifteenDis when (timeDisp(3 downto 0) = "1111");

node1<=zeroDis when (timeDisp(7 downto 4) = "0000") else 
oneDis when (timeDisp(7 downto 4) = "0001") else 
twoDis when (timeDisp(7 downto 4) = "0010") else 
threeDis when (timeDisp(7 downto 4) = "0011") else 
fourDis when (timeDisp(7 downto 4) = "0100") else 
fiveDis when (timeDisp(7 downto 4) = "0101") else 
sixDis when (timeDisp(7 downto 4) = "0110") else 
sevenDis when (timeDisp(7 downto 4) = "0111") else 
eightDis when (timeDisp(7 downto 4) = "1000") else 
nineDis when (timeDisp(7 downto 4) = "1001") else 
tenDis when (timeDisp(7 downto 4) = "1010") else 
elevenDis when (timeDisp(7 downto 4) = "1011") else 
twelveDis when (timeDisp(7 downto 4) = "1100") else 
thirteenDis when (timeDisp(7 downto 4) = "1101") else 
fourteenDis when (timeDisp(7 downto 4) = "1110") else 
fifteenDis when (timeDisp(7 downto 4) = "1111"); 

node2<=zeroDis when ("00" & timeDisp(9 downto 8) = "0000") else 
oneDis when ("00" & timeDisp(9 downto 8) = "0001") else 
twoDis when ("00" & timeDisp(9 downto 8) = "0010") else 
threeDis when ("00" & timeDisp(9 downto 8) = "0011") else 
fourDis when ("00" & timeDisp(9 downto 8) = "0100") else 
fiveDis when ("00" & timeDisp(9 downto 8) = "0101") else 
sixDis when ("00" & timeDisp(9 downto 8) = "0110") else 
sevenDis when ("00" & timeDisp(9 downto 8) = "0111") else 
eightDis when ("00" & timeDisp(9 downto 8) = "1000") else 
nineDis when ("00" & timeDisp(9 downto 8) = "1001") else 
tenDis when ("00" & timeDisp(9 downto 8) = "1010") else 
elevenDis when ("00" & timeDisp(9 downto 8) = "1011") else 
twelveDis when ("00" & timeDisp(9 downto 8) = "1100") else 
thirteenDis when ("00" & timeDisp(9 downto 8) = "1101") else 
fourteenDis when ("00" & timeDisp(9 downto 8) = "1110") else 
fifteenDis when ("00" & timeDisp(9 downto 8) = "1111"); 

 


process (mclk)
begin

if(mclk = '1' and mclk'Event)then 
    clkPix <= not clkPix; 
    end if; 
end process; 

-- Generate the horizontal timing. 
process (clkPix) 
begin 

if (clkPix = '1' and clkPix'Event) then 
    if (cntHorz = "0001011101") then 
        cntHorz <= cntHorz + 1; 
        sncHorz <= '1'; 

    elsif (cntHorz = "0010001100") then 
        cntHorz <= cntHorz + 1; 
        blkHorz <= '0'; 
    elsif (cntHorz = "1100001100") then 
        cntHorz <= cntHorz + 1; 
        blkHorz <= '1'; 
    elsif (cntHorz = "1100011010") then 
        cntHorz <= "0000000000"; 
        clkLine <= '1'; 
        sncHorz <= '0'; 
    else 
        cntHorz <= cntHorz + 1; 
        clkLine <= '0'; 
            if (cntHorz < right2 and cntHorz > left2) then 
                 cnt1 <= cnt1 + 1; 
            else 
                 cnt1 <= 0; 
            end if; 

            if (cntHorz < (right3-X"C") and cntHorz > (left3-X"C")) then 
                cnt3 <= cnt3 + 1; 
            else 
                 cnt3 <= 0; 
            end if; 
         
            if (cntHorz < (right3-X"4C") and cntHorz > (left3-X"4C")) then 
                cnt5 <= cnt5 + 1; 
            else 
                 cnt5 <= 0; 
            end if;          
    end if; 
end if; 

end process; 

-- Generate the vertical timing. 
process (clkLine) 
begin 

if (clkLine = '1' and clkLine'Event) then 
    if (cntVert = "0000000001") then 
        cntVert <= cntVert + 1; 
        sncVert <= '1'; 
    elsif (cntVert = "0000011010") then 
        cntVert <= cntVert + 1; 
        blkVert <= '0'; 
    elsif (cntVert = "0111111010") then 
        cntVert <= cntVert + 1; 
        blkVert <= '1'; 
    elsif (cntVert = "1000001100") then 
        cntVert <= "0000000000"; 
        sncVert <= '0'; 
    else 
        cntVert <= cntVert + 1; 
    end if; 
    
    if (cntVert < lower2 and cntVert > upper2) then 
        cnt2 <= cnt2 + 1; 
    else 
        cnt2 <= 0; 
    end if; 
    
    if (cntVert < lower3 and cntVert > upper3) then 
        cnt4 <= cnt4 + 1; 
    else 
        cnt4 <= 0; 
    end if; 
    
end if;
 
end process; 

-- Divide the active portion of a scan line into 8 regions. -- This counts up to 79 and then resets. Each time it -- resets, it generates a pulse on clkColor. 
process (clkPix, blkDisp) 

begin 

if (clkPix = '1' and clkPix'Event) then 
    if (blkDisp = '1') then 
        cntImg <= "0000000"; else 
        if (cntImg = "1001111") then 
            cntImg <= "0000000"; 
            clkColor <= '1'; 
        else 
            cntImg <= cntImg + 1; 
            clkColor <= '0'; 
        end if; 
    end if; 
end if; 
end process; 



blkDisp <= blkVert or blkHorz;  
cntColor <= "111" when (cntHorz < right2 and cntHorz > left2 and cntVert < lower2 and cntVert > upper2 and node0(cnt2)(cnt1)='1') else  -- and num(cnt2)(cnt1)='1',and num2(cnt2)(cnt1)='1'; 
--"111" when (cntHorz < right3 and cntHorz > left3 and cntVert < lower3 and cntVert > upper3 and num1(cnt3)(cnt2)='1') else  
 -- working"111" when (cntHorz > right3 and cntHorz > left3 and cntVert < lower3 and cntVert > upper3 and node1(cnt4)(cnt3)='1') else "000"; 
"111" when (cntHorz < (right3-X"C") and cntHorz > (left3-X"C") and cntVert < lower3 and cntVert > upper3 and node1(cnt4)(cnt3)='1') else 
"111" when (cntHorz < (right3-X"4C") and cntHorz > (left3-X"4C") and cntVert < lower3 and cntVert > upper3 and node2(cnt4)(cnt5)='1') else "000";

vs <= sncVert; 
hs <= sncHorz; 
rgb(2) <= cntColor(0) and (not blkDisp); 
rgb(1) <= cntColor(1) and (not blkDisp); 
rgb(0) <= cntColor(2) and (not blkDisp); 
end Behavioral; 