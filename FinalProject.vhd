LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

-- Creating a peripheral to implement the log base 2 operation on the SCOMP
-- This peripheral provides hardware acceleration for log2 calculations
-- Uses I/O addresses in the range 0x90-0x9F
entity FinalProject IS
	Port (
		clock, reset : in std_logic;
		IO_ADDR : in std_logic_vector(10 DOWNTO 0);
		IO_DATA : inout std_logic_vector(15 DOWNTO 0);
		IO_READ : in std_logic;
		IO_WRITE: in std_logic;
		CS : out std_logic  -- Chip select signal
	);
end FinalProject;

architecture behavior of FinalProject is
	-- Internal registers
	signal input_value : std_logic_vector(15 downto 0);  -- Input value for log2
	signal log2_result : std_logic_vector(15 downto 0);  -- Calculated log2 result
	
	-- Address decoding signals
	signal addr_match_90 : std_logic;  -- Address 0x90 (input/result register)
	
	-- Chip select signal
	signal peripheral_cs : std_logic;
	
begin
	-- Address decoding: Check if address is in range 0x90-0x9F
	-- 0x90 in binary (11-bit): 010 0100 0000
	-- We check if the upper bits match 0x90-0x9F range
	peripheral_cs <= '1' when (IO_ADDR(10 downto 4) = "0100100") else '0';
	CS <= peripheral_cs;
	
	-- Specific address decoding
	addr_match_90 <= '1' when (peripheral_cs = '1' and IO_ADDR(3 downto 0) = "0000") else '0';
	
	-- Write process: Handle writes to the peripheral
	process(clock, reset)
	begin
		if reset = '1' then
			input_value <= (others => '0');
		elsif rising_edge(clock) then
			if IO_WRITE = '1' and addr_match_90 = '1' then
				-- Write to address 0x90: Store input value
				input_value <= IO_DATA;
			end if;
		end if;
	end process;
	
	-- Log2 calculation (combinational logic)
	-- This implements floor(log2(x)) by finding the position of the MSB
	process(input_value)
	begin
		-- Default case (for input = 0, which is undefined)
		log2_result <= (others => '0');
		
		-- Priority encoder to find the most significant bit position
		if input_value(15) = '1' then
			log2_result <= x"000F";  -- log2 is 15
		elsif input_value(14) = '1' then
			log2_result <= x"000E";  -- log2 is 14
		elsif input_value(13) = '1' then
			log2_result <= x"000D";  -- log2 is 13
		elsif input_value(12) = '1' then
			log2_result <= x"000C";  -- log2 is 12
		elsif input_value(11) = '1' then
			log2_result <= x"000B";  -- log2 is 11
		elsif input_value(10) = '1' then
			log2_result <= x"000A";  -- log2 is 10
		elsif input_value(9) = '1' then
			log2_result <= x"0009";  -- log2 is 9
		elsif input_value(8) = '1' then
			log2_result <= x"0008";  -- log2 is 8
		elsif input_value(7) = '1' then
			log2_result <= x"0007";  -- log2 is 7
		elsif input_value(6) = '1' then
			log2_result <= x"0006";  -- log2 is 6
		elsif input_value(5) = '1' then
			log2_result <= x"0005";  -- log2 is 5
		elsif input_value(4) = '1' then
			log2_result <= x"0004";  -- log2 is 4
		elsif input_value(3) = '1' then
			log2_result <= x"0003";  -- log2 is 3
		elsif input_value(2) = '1' then
			log2_result <= x"0002";  -- log2 is 2
		elsif input_value(1) = '1' then
			log2_result <= x"0001";  -- log2 is 1
		elsif input_value(0) = '1' then
			log2_result <= x"0000";  -- log2 is 0 (for input = 1)
		else
			log2_result <= x"FFFF";  -- Error: input is 0
		end if;
	end process;
	
	-- Read process: Handle reads from the peripheral
	process(IO_READ, addr_match_90, log2_result)
	begin
		if IO_READ = '1' and addr_match_90 = '1' then
			-- Read from address 0x90: Return log2 result
			IO_DATA <= log2_result;
		else
			IO_DATA <= (others => 'Z');  -- High impedance when not reading
		end if;
	end process;
	
end behavior;
