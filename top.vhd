----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:05:04 09/12/2018 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.records.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity top is
    Port ( clk : in  STD_LOGIC;
			  key1 : IN STD_LOGIC;
			  key2 : IN STD_LOGIC;
			  key4 : IN STD_LOGIC;
			  key3 : IN STD_LOGIC;
           vsync : out  STD_LOGIC;
			  hsync : out STD_LOGIC;
			  vblue : out STD_LOGIC;
			  vgreen :out STD_LOGIC;
			  vred : out STD_LOGIC);
end top;

architecture Behavioral of top is	
	component clk_pll
		port ( CLK_IN1 : in std_logic;
				CLK_OUT1 : out std_logic;
				RESET : in std_logic);
	end component;
	
	component vga
		 Port ( clk : in  STD_LOGIC;
				  color_sel : in STD_LOGIC_VECTOR(2 downto 0);
				  vxpos : out integer;
				  vypos : out integer;
				  vsync : out  STD_LOGIC;
				  hsync : out  STD_LOGIC;
				  vblue : out  STD_LOGIC;
				  vgreen : out  STD_LOGIC;
				  vred : out  STD_LOGIC);
	end component;
	
	component debouncer
		 Port ( clk : in  STD_LOGIC;
				  btn_in : in  STD_LOGIC;
				  btn_out : out  STD_LOGIC);
	end component;
	
	-- other signals
	signal s_key1 : std_logic;
	signal s_key2 : std_logic;
	signal s_key3 : std_logic;
	signal s_key4 : std_logic;
	signal s_keys : std_logic_vector(3 downto 0);

	signal s_clk40 : std_logic;
	signal s_vsync : std_logic;
	signal s_hsync : std_logic;
	signal s_blue : std_logic;
	signal s_green : std_logic;
	signal s_red : std_logic;
	signal s_count : std_logic_vector(23 downto 0) := (others => '0');
	signal s_color : std_logic_vector(2 downto 0);
	
	signal s_xpos : integer range 0 to 800;
	signal s_ypos : integer range 0 to 600;
	signal s_speedx : integer range -10 to 10 := 1;
	signal s_speedy : integer range -10 to 10 := 1;
	signal s_speedcountx : integer range 0 to 100;
	signal s_speedcounty : integer range 0 to 100;
	

	signal s_p1pos : integer range 0 to 600;
	signal s_p2pos : integer range 0 to 600;
	signal p1 : player_t := c_PLAYER_INIT;
	signal p2 : player_t := C_PLAYER_INIT;
	signal ball : ball_t := c_BALL_INIT;
	signal ball_dir : bit;
	signal y_dir : bit := '0';
	signal s_start : bit := '0';
	
begin
	clk40_pll : clk_pll port map ( clk_in1 => clk,
											clk_out1 => s_clk40,
											reset => '0');
	
	display : vga port map (clk => s_clk40,
									color_sel => s_color,
									vxpos => s_xpos,
									vypos => s_ypos,
									vsync => s_vsync,
									hsync => s_hsync,
									vblue => s_blue,
									vgreen => s_green,
									vred => s_red);
	-- player 1 keys
	btn2 : debouncer port map (clk => s_clk40,
										 btn_in =>  key2,
										 btn_out => s_key2);
	btn3 : debouncer port map (clk => s_clk40,
										 btn_in =>  key3,
										 btn_out => s_key3);

	-- player 2 keys
	btn1 : debouncer port map (clk => s_clk40,
										 btn_in =>  key1,
										 btn_out => s_key1);
	btn4 : debouncer port map (clk => s_clk40,
									 btn_in =>  key4,
									 btn_out => s_key4);



	process(s_clk40)
		variable diff : integer range -100 to 100;
		variable speedx : integer range -5 to 5;
		variable speedy : integer range -5 to 5;
		variable dir : bit;
	begin
		if s_clk40'event and s_clk40 = '1' then
			s_count <= s_count + 1;
			s_color <= "000"; -- standard black
			-- ball.y <= 299;
			if p1.y < 20 or p1.y > 679 then
				p1.y <= 20;
			end if;			
			if p2.y < 20 or p2.y > 679 then
				p2.y <= 20;
			end if;
			
			if s_xpos < 10 or s_xpos >= 789 or (s_xpos > 397 and s_xpos < 403) then
				s_color <= "111";
			end if;
			if s_ypos < 10 or s_ypos >= 589 then
				s_color <= "111";
			end if;
			
			-- show p1 score
			if s_xpos >= 360 and s_xpos <= 389 and s_ypos >= 30 and s_ypos <= 69 then
				if c_NUMBERS(p1.score)((s_ypos-30)/5)((s_xpos-360)/5) = '1' then
					s_color <= "011"; -- cyan
				end if;
			end if;
			-- show p2 score
			if s_xpos >= 410 and s_xpos <= 439 and s_ypos >= 30 and s_ypos <= 69 then
				if c_NUMBERS(p2.score)((s_ypos-30)/5)((s_xpos-410)/5) = '1' then
					s_color <= "101"; -- pink
				end if;
			end if;
			
			if s_xpos >= p1.x and s_xpos <= (p1.x+p1.width)  and s_ypos >= p1.y and s_ypos <= (p1.y+p1.height) then
					s_color <= "100"; -- red
			end if;
			if s_xpos >= p2.x and s_xpos <= (p2.x+p2.width) and s_ypos >= p2.y and s_ypos <= (p2.y+p2.height) then
					s_color <= "001"; -- blue
			end if;
			if s_xpos >= ball.x and s_xpos <= (ball.x+ball.width) and s_ypos >= ball.y and s_ypos <= (ball.y+ball.width) then
				if c_BALL(ball.y-s_ypos)(ball.x-s_xpos) = '1' then
					s_color <= "010"; -- green
				end if;
			end if;
			
			if s_count >= x"1025A" then
				s_count <= (others => '0');
				-- move ball
				if s_start = '1' then
					if ball.x <= 10 then
						p2.score <= p2.score + 1;
						p1.y <= 250;
						p2.y <= 250;
						s_start <= '0';
						ball_dir <= not ball_dir;
						ball.x <= 60;
						ball.y <= 299;
						if p2.score = 9 then
							p2.score <= 0;
						end if;
					elsif ball.x >= 789 then
						p1.score <= p1.score + 1;
						p1.y <= 250;
						p2.y <= 250;
						s_start <= '0';
						ball_dir <= not ball_dir;
						ball.x <= 740;
						ball.y <= 299;
						if p1.score = 9 then
							p1.score <= 0;
						end if;
					else
						s_speedcountx <= s_speedcountx + 1;
						s_speedcounty <= s_speedcounty + 1;
						if s_speedcountx >= s_speedx then
							if ball_dir = '0' then
								ball.x <= ball.x - 1;
							else
								ball.x <= ball.x + 1;
							end if;
							s_speedcountx <= 0;
						end if;
						if s_speedcounty >= s_speedy*3 then
							if y_dir = '1' then
								ball.y <= ball.y - s_speedy;
							else
								ball.y <= ball.y + s_speedy;
							end if;
							s_speedcounty <= 0;
						end if;
						if ball.y <= 10 then
							y_dir <= '0';
						elsif ball.y >= 574 then
							y_dir <= '1';
						end if;		
					end if;	
					
					if (ball.x = (p1.x+p1.width-1) and (ball.y >= (p1.y-ball.width) and ball.y <= (p1.y+p1.height))) then
						ball_dir <= '1';
						diff := ball.y-p1.y;
						SPEED_CALC(diff, speedx, speedy, dir);
						s_speedx <= speedx;
						s_speedy <= speedy;
						y_dir <= dir;
					end if;
					if ((ball.x+ball.width+1) = p2.x and (ball.y >= (p2.y-ball.width) and ball.y <= (p2.y+p2.height))) then
						ball_dir <= '0';
						diff := ball.y-p2.y;
						SPEED_CALC(diff, speedx, speedy, dir);
						s_speedx <= speedx;
						s_speedy <= speedy;
						y_dir <= dir;
						end if;
				end if;
				-- move players if a key is pressed
				if  s_keys /= "0000" then
					s_start <= '1';
					if s_key2 = '1' and p1.y > 10 then
						p1.y <= p1.y - 1;
					end if;
					if s_key3 = '1' and p1.y < 559 then
						p1.y <= p1.y + 1;
					end if;
					if s_key4 = '1' and p2.y > 10 then
						p2.y <= p2.y - 1;
					end if;
					if s_key1 = '1' and p2.y < 559 then
						p2.y <= p2.y + 1;
					end if;
				end if;			

			end if;
		end if;
	end process;
	
	p1.x <= 30;
	p2.x <= 770;
	s_keys <= s_key4 & s_key3 & s_key2 & s_key1;
	vsync <= s_vsync;
	hsync <= s_hsync;
	vgreen <= s_green;
	vred <= s_red;
	vblue <= s_blue;

end Behavioral;
