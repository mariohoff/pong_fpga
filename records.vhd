--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package records is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

	type player_t is record
		x : integer range 0 to 800;
		y : integer range 0 to 800;
		height : integer range 0 to 200;
		width : integer range 0 to 100;
		score : integer range 0 to 9;
	end record player_t;
	
	type ball_t is record
		x : integer range 0 to 800;
		y : integer range 0 to 600;
		width : integer range 0 to 100;
	end record ball_t;
	
	constant c_PLAYER_INIT : player_t := (x => 30,
														y => 250,
														height => 100,
														width => 10,
														score => 0);
	constant c_BALL_INIT : ball_t := (x => 399,
												y => 299,
												width => 15);
	
	type number_t is array(0 to 7) of std_logic_vector(0 to 5);
	type numbers_array is array(0 to 9) of number_t;
	constant c_NUMBERS : numbers_array := (("000000", "001100", "010010", "010010", "010010", "010010", "001100", "000000"), -- 0
														("000000", "000100", "001100", "010100", "000100", "000100", "000100", "000000"), -- 1
														("000000", "001100", "010010", "000010", "000100", "001000", "011110", "000000"), -- 2
														("000000", "001100", "010010", "000100", "000010", "010010", "001100", "000000"), -- 3
														("000000", "000100", "001100", "010100", "011110", "000100", "000100", "000000"), -- 4
														("000000", "011110", "010000", "011100", "000010", "010010", "001100", "000000"), -- 5
														("000000", "000110", "001000", "011100", "010010", "010010", "001100", "000000"), -- 6
														("000000", "011110", "000010", "000100", "001000", "001000", "001000", "000000"), -- 7
														("000000", "001100", "010010", "001100", "010010", "010010", "001100", "000000"), -- 8
														("000000", "001100", "010010", "001110", "000010", "010010", "001100", "000000")); -- 9
														
	type ball_graphic_t is array(0 to 14) of std_logic_vector(0 to 14);
	constant c_BALL : ball_graphic_t := (  "000000000000000",
														"000011111110000",
														"000111111111000",
														"001111111111100",
														"011111111111110",
														"011111111111110",
														"011111111111110",
														"011111111111110",
														"011111111111110",
														"011111111111110",
														"011111111111110",
														"001111111111100",
														"000111111111000",
														"000011111110000",
														"000000000000000");
														
	procedure SPEED_CALC
		(diff_in : in integer range -100 to 100;
		speedx : out integer range -5 to 5;
		speedy : out integer range -5 to 5;
		y_dir : out bit);
	
end records;

package body records is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
	procedure SPEED_CALC
		(diff_in : in integer range -100 to 100;
		speedx : out integer range -5 to 5;
		speedy : out integer range -5 to 5;
		y_dir : out bit) is
	begin
		case diff_in is
		when 0 to 9 => 
			speedx := 5;
			speedy := 5;
			y_dir := '1';
		when 10 to 19 =>
			speedx := 4;
			speedy := 4;
			y_dir := '1';
		when 20 to 29 =>
			speedx := 3;
			speedy := 3;
			y_dir := '1';
		when 30 to 39 =>
			speedx := 2;
			speedy := 2;
			y_dir := '1';
		when 40 to 59 =>
			speedx := 1;
			speedy := 0;
		when 60 to 69 =>
			speedx := 2;
			speedy := 2;
			y_dir := '0';
		when 70 to 79 =>
			speedx := 3;
			speedy := 3;
			y_dir := '0';
		when 80 to 89 =>
			speedx := 4;
			speedy := 4;
			y_dir := '0';
		when 90 to 99 =>
			speedx := 5;
			speedy := 5;
			y_dir := '0';
		when others =>
			speedx := 2;
			speedy := 2;
		end case;	
	end SPEED_CALC;
end records;
