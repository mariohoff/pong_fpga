----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:20:49 09/16/2018 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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

entity debouncer is
    Port ( clk : in  STD_LOGIC;
           btn_in : in  STD_LOGIC;
           btn_out : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal s_enable : std_logic; -- sample clock pulse
signal s_wrapping : std_logic_vector(15 downto 0) := (others => '0'); -- wrapping counter
signal s_sync : std_logic_vector(1 downto 0) := (others => '0'); -- sync signal
signal s_saturation : std_logic_vector(15 downto 0) := (others => '0');

begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			s_wrapping <= s_wrapping + 1;
			if s_wrapping >= x"1388" then
				s_enable <= '1';
				s_wrapping <= (others => '0');
			end if;
			
			if s_enable = '1' then
				s_enable <= '0';
				
				s_sync <= s_sync(0) & btn_in; -- shift sync signal
				
				if s_sync = "11" then -- if sync is good count up saturation
					if s_saturation < x"3e8" then
						s_saturation <= s_saturation + 1;
					else
						btn_out <= '1';
					end if;
				else
					s_saturation <= (others => '0');
					btn_out <= '0';
				end if;
			end if;
		end if; -- clk'event
	end process;

end Behavioral;

