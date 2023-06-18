library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lab03 is
    port (
		-- Vstupní přepínače
		a      : in  std_logic;
		b      : in  std_logic;
		c      : in  std_logic;
		d      : in  std_logic;

		-- Výstupní LED diody
        q_inv  : out std_logic;
		q_log0 : out std_logic;
		q_log1 : out std_logic;
		q_and  : out std_logic;
		q_or   : out std_logic;
		q_xor  : out std_logic;
		q_xnor : out std_logic;
		q_nand : out std_logic;
		q_nor  : out std_logic;

		-- Výstup výsledku hlasování
		q_vote : out std_logic
    );
end lab03;


architecture structural of lab03 is

	-- Invertní signál pro vstupní port a (viz dále)
    signal invertor : std_logic;

begin

	-- Invertovat vstupní port a
    invertor <= not a;

	-- Předat zpracované signály na výstupní porty
    q_inv    <= invertor; -- Inverze
	q_log0   <= '0'; -- Logická nula
	q_log1   <= '1'; -- Logická jednička
	q_and    <= a and b and c and d; -- AND
	q_or     <= a or b or c or d; -- OR
	q_xor    <= a xor b xor c xor d; -- XOR
	q_xnor   <= a xnor b xnor c xnor d; -- XNOR
	q_nand   <= not (a and b and c and d); -- NAND
	q_nor    <= not (a or b or c or d); -- NOR

	-- Zjednodušené zpracování hlasování; protože předseda má váhu dvou
	-- hlasů, hlasování prochází, pokud je to buď hlas předsedy a jednoho člena
	-- nebo hlas všech členů najednou.
	q_vote   <= (a and b) or (a and c) or (a and d) or (b and c and d);

end structural;
