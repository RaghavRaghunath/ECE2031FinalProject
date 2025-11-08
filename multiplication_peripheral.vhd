LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE  IEEE.NUMERIC_STD.all;

-- Creating a peripheral capable of implementing multiplication between two binary inputs.
entity MultiplicationPeripheral IS
	Port (
		clock, reset : in std_logic;
		IO_ADDR : in std_logic_vector(7 DOWNTO 0);
		IO_DATA : inout std_logic_vector(15 DOWNTO 0);
		IO_READ : in std_logic;
		IO_WRITE: in std_logic;
	);
end MultiplicationPeripheral;

-- takes in two 16-bit inputs and outputs a 32-bit product.
architecture Behavioral of MultiplicationPeripheral is
    signal A : std_logic_vector(15 DOWNTO 0); -- first input
    signal B : std_logic_vector(15 DOWNTO 0); -- second input
    signal product : std_logic_vector(31 DOWNTO 0); -- product of A and B

begin

    process(clock, reset)
    begin
        -- reset on High
        if reset = '1' then
            A <= (others => '0');
            B <= (others => '0');
            product <= (others => '0');
        elsif rising_edge(clock) then
            -- write to A (which is stored in address 0x80)
            if (IO_WRITE = '1' and IO_ADDR = x"80") then
                A <= unsigned(IO_DATA);
            end if;

            -- write to B (which is stored in address 0x81) and calculate the product 
            if (IO_WRITE = '1' and IO_ADDR = x"81") then
                B <= unsigned(IO_DATA);
                product <= A * B;
            end if;

            -- read the product (store in address 0x82)
            if (IO_READ = '1' and IO_ADDR = x"82) then
                IO_DATA <= product(31 DOWNTO 16)
            end if;
        end if;
    end process;

end Behavioral;

