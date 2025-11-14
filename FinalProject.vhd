LIBRARY IEEE;
LIBRARY LPM;

USE  IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE  IEEE.NUMERIC_STD.all;
USE LPM.LPM_COMPONENTS.ALL;

-- Creating a peripheral to implement the log base 2 operation on the SCOMP
-- This peripheral provides hardware acceleration for log2 calculations
-- Uses I/O addresses in the range 0x90-0x9F
entity FinalProject IS
	Port (
		IO_ADDR : in std_logic_vector(10 DOWNTO 0);
		IO_DATA : inout std_logic_vector(15 DOWNTO 0);
		IO_READ : in std_logic;
		IO_WRITE: in std_logic
	);
end FinalProject;

architecture behavior of FinalProject is
	-- Internal registers
	signal inputA : std_logic_vector(15 downto 0);
	signal inputB : std_logic_vector(15 downto 0);
	signal output : std_logic_vector(15 downto 0);
	signal IO_EN  : std_logic;
	
begin
	IO_BUS: lpm_bustri
	GENERIC MAP (
		lpm_width => 16
	)
	PORT MAP (
		data     => output,
		enabledt => IO_EN,
		tridata  => IO_DATA
	);

	-- This implements floor(log2(x)) by finding the position of the MSB using a priority encoder
	process(IO_READ, IO_ADDR, IO_WRITE)
	begin
		if IO_WRITE = '1' and (IO_ADDR = "00010010000" or IO_ADDR = "00010000000" or IO_ADDR = "00001110000") then
			inputA <= (IO_DATA);
			inputB <= inputB;
		elsif IO_WRITE = '1' and (IO_ADDR = "00010000001" or IO_ADDR = "00001110001") then
			inputB <= IO_DATA;
			inputA <= inputA;
		elsif IO_READ = '1' and IO_ADDR = "00010010001" then 
			-- Priority encoder to find the most significant bit position
			if inputA(15) = '1' then
				output <= std_logic_vector(to_unsigned(15, 16));  -- log2 is 15
			elsif inputA(14) = '1' then
				output <= std_logic_vector(to_unsigned(14, 16));  -- log2 is 14
			elsif inputA(13) = '1' then
				output <= std_logic_vector(to_unsigned(13, 16));  -- log2 is 13
			elsif inputA(12) = '1' then
				output <= std_logic_vector(to_unsigned(12, 16));  -- log2 is 12
			elsif inputA(11) = '1' then
				output <= std_logic_vector(to_unsigned(11, 16));  -- log2 is 11
			elsif inputA(10) = '1' then
				output <= std_logic_vector(to_unsigned(10, 16));  -- log2 is 10
			elsif inputA(9) = '1' then
				output <= std_logic_vector(to_unsigned(9, 16));  -- log2 is 9
			elsif inputA(8) = '1' then
				output <= std_logic_vector(to_unsigned(8, 16));  -- log2 is 8
			elsif inputA(7) = '1' then
				output <= std_logic_vector(to_unsigned(7, 16));  -- log2 is 7
			elsif inputA(6) = '1' then
				output <= std_logic_vector(to_unsigned(6, 16));  -- log2 is 6
			elsif inputA(5) = '1' then
				output <= std_logic_vector(to_unsigned(5, 16));  -- log2 is 5
			elsif inputA(4) = '1' then
				output <= std_logic_vector(to_unsigned(4, 16));  -- log2 is 4
			elsif inputA(3) = '1' then
				output <= std_logic_vector(to_unsigned(3, 16));  -- log2 is 3
			elsif inputA(2) = '1' then
				output <= std_logic_vector(to_unsigned(2, 16));  -- log2 is 2
			elsif inputA(1) = '1' then
				output <= std_logic_vector(to_unsigned(1, 16));  -- log2 is 1
			else
				output <= std_logic_vector(to_unsigned(0, 16));  -- log2 is 0
			end if;
		elsif IO_READ = '1' and IO_ADDR = "00010000010" then
			-- Calculate the product of both inputA signal and inputB signal
			output <= std_logic_vector(resize(unsigned(inputA) * unsigned(inputB), 16));
			if unsigned(output) > 65535 then
				output <= "1111111111111111";
			end if;
		elsif IO_READ = '1' and IO_ADDR = "00001110010" then
			-- Calculate the quotient of both inputA signal and inputB signal
			output <= std_logic_vector(resize(unsigned(inputA) / unsigned(inputB), 16));
		end if;
	end process;
	-- Drive IO_DATA when requested.
	IO_EN <=
		'1' WHEN (IO_ADDR = "00010010001" or IO_ADDR = "00010000010" or IO_ADDR = "00001110010") AND (IO_READ = '1')
		ELSE '0';
	
end behavior;