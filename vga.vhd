----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:21:58 09/12/2018 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk : in  STD_LOGIC;
			  color_sel : in STD_LOGIC_VECTOR(2 downto 0);
			  vxpos : out integer;
			  vypos : out integer;
           vsync : out  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vblue : out  STD_LOGIC_VECTOR (4 downto 0);
           vgreen : out  STD_LOGIC_VECTOR (5 downto 0);
           vred : out  STD_LOGIC_VECTOR (4 downto 0));
end vga;

architecture Behavioral of vga is

	signal s_vsync : std_logic;
	signal s_vcount : std_logic_vector(19 downto 0);
	
	signal s_hsync : std_logic;
	signal s_hcount : std_logic_vector(10 downto 0);
	
	signal s_blue : std_logic_vector(4 downto 0);
	signal s_green : std_logic_vector(5 downto 0);
	signal s_red : std_logic_vector(4 downto 0);
	signal s_color : std_logic_vector(15 downto 0);
	
	signal s_enable : std_logic;
	signal x_pos : integer range 0 to 800;
	signal y_pos : integer range 0 to 600;
	
begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			s_hcount <= s_hcount + 1;
			
			if s_hcount >= x"58" and s_hcount < x"378" then
				s_enable <= '1';
				x_pos <= x_pos + 1;
			else
				s_enable <= '0';
			end if;
			
			if s_hcount >= x"3a0" then
				s_hsync <= '1';
			end if;
			
			if s_hcount >= x"41f" then
				s_hsync <= '0';
				s_hcount <= (others => '0');
				x_pos <= 0;
			end if;
		
			if s_enable = '1' and y_pos < x"258" and x_pos < x"320" then
				case color_sel is
					when "000" => s_color <= x"ffff"; --white
					when "001" => s_color <= x"041f"; -- blue
					when "010" => s_color <= x"07e0"; -- green
					when "011" => s_color <= x"ffe0"; -- yellow
					when "100" => s_color <= x"fc00"; -- orange
					when "101" => s_color <= x"f800"; -- red
					when "110" => s_color <= x"fc1f"; -- pink
					when "111" => s_color <= x"0000"; --black
					when others => s_color <= x"0000";
				end case;
			else
				s_color <= x"0000";
			end if;
				
			s_red <= s_color(15 downto 11);
			s_green <= s_color(10 downto 5);
			s_blue <= s_color(4 downto 0);			
		end if;
	end process;
	
	process(s_hsync)
	begin
		if s_hsync'event and s_hsync = '1' then
			s_vcount <= s_vcount + 1;
			
			if s_vcount >= x"17" and s_vcount < x"26f" then
				y_pos <= y_pos + 1;
			end if;
			
			if s_vcount >= x"26f" then
				s_vsync <= '1';
			end if;
			if s_vcount >= x"273" then
				s_vsync <= '0';
				s_vcount <= (others => '0');
				y_pos <= 0;
			end if;
			
		end if;
	end process;

	vsync <= s_vsync;
	hsync <= s_hsync;
	vblue <= s_blue;
	vgreen <= s_green;
	vred <= s_red;
	vxpos <= x_pos;
	vypos <= y_pos;
	
end Behavioral;

