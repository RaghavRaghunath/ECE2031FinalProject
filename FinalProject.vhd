LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE  IEEE.NUMERIC_STD.all;

-- Creating a peripheral to implement the log base 2 operation on the SCOMP
-- This peripheral provides hardware acceleration for log2 calculations
-- Uses I/O addresses in the range 0x90-0x9F
entity Log2Peripheral IS
	Port (
		clock, reset : in std_logic;
		IO_ADDR : in std_logic_vector(10 DOWNTO 0);
		IO_DATA : inout std_logic_vector(15 DOWNTO 0);
		IO_READ : in std_logic;
		IO_WRITE: in std_logic
	);
end Log2Peripheral;

architecture behavior of Log2Peripheral is
	-- Internal registers
	signal LOG_WRITE : unsigned(15 downto 0);
	signal LOG_READ : unsigned(15 downto 0);
	
begin
	-- Write process, storing the input 
	process(clock, reset)
	begin
		-- reset on High
		if reset = '1' then
			LOG_WRITE <= (others => '0');
		elsif rising_edge(clock) then
			-- write to LOG_WRITE register
			if IO_WRITE = '1' and IO_ADDR = x"90" then
				LOG_WRITE <= unsigned(IO_DATA);
			end if;
		end if;
	end process;

	-- This implements floor(log2(x)) by finding the position of the MSB using a priority encoder
	process(LOG_WRITE)
	begin
		-- Default case (for input = 0, which is undefined)
		LOG_READ <= (others => '0');
		
		-- Priority encoder to find the most significant bit position
		if LOG_WRITE(15) = '1' then
			LOG_READ <= to_unsigned(15, 16);  -- log2 is 15
		elsif LOG_WRITE(14) = '1' then
			LOG_READ <= to_unsigned(14, 16);  -- log2 is 14
		elsif LOG_WRITE(13) = '1' then
			LOG_READ <= to_unsigned(13, 16);  -- log2 is 13
		elsif LOG_WRITE(12) = '1' then
			LOG_READ <= to_unsigned(12, 16);  -- log2 is 12
		elsif LOG_WRITE(11) = '1' then
			LOG_READ <= to_unsigned(11, 16);  -- log2 is 11
		elsif LOG_WRITE(10) = '1' then
			LOG_READ <= to_unsigned(10, 16);  -- log2 is 10
		elsif LOG_WRITE(9) = '1' then
			LOG_READ <= to_unsigned(9, 16);  -- log2 is 9
		elsif LOG_WRITE(8) = '1' then
			LOG_READ <= to_unsigned(8, 16);  -- log2 is 8
		elsif LOG_WRITE(7) = '1' then
			LOG_READ <= to_unsigned(7, 16);  -- log2 is 7
		elsif LOG_WRITE(6) = '1' then
			LOG_READ <= to_unsigned(6, 16);  -- log2 is 6
		elsif LOG_WRITE(5) = '1' then
			LOG_READ <= to_unsigned(5, 16);  -- log2 is 5
		elsif LOG_WRITE(4) = '1' then
			LOG_READ <= to_unsigned(4, 16);  -- log2 is 4
		elsif LOG_WRITE(3) = '1' then
			LOG_READ <= to_unsigned(3, 16);  -- log2 is 3
		elsif LOG_WRITE(2) = '1' then
			LOG_READ <= to_unsigned(2, 16);  -- log2 is 2
		elsif LOG_WRITE(1) = '1' then
			LOG_READ <= to_unsigned(1, 16);  -- log2 is 1
		else
			LOG_READ <= to_unsigned(0, 16);  -- log2 is 0
		end if;
	end process;
	
	-- Read process: Handle reads from the peripheral
	process(IO_READ, IO_ADDR, LOG_READ)
	begin
		if IO_READ = '1' and IO_ADDR = x"91" then
			-- Read from address 0x91: Return log2 result
			IO_DATA <= std_logic_vector(LOG_READ);
		else
			IO_DATA <= (others => 'Z');  -- High impedance when not reading
		end if;
	end process;
	
end behavior;
