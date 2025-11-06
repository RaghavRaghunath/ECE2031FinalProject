LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

-- Creating a peripheral to implement the log base 2 operation on the SCOMP
entity FinalProject IS
	Port (
		clock, reset : in std_logic;
		IO_ADDR : in std_logic_vector(10 DOWNTO 0);
		IO_DATA : inout std_logic_vector(15 DOWNTO 0);
		IO_READ : in std_logic;
		IO_WRITE: in std_logic;
	);
end FinalProject;