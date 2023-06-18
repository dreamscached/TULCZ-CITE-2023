library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    port (
		-- Vstupní vektor bitů, mapovaný na přepínače
        d : in std_logic_vector(1 downto 0);

		-- Výstupní vektor bitů, mapovaný na LED diody
        q : out std_logic_vector(3 downto 0)
    );
end decoder;


architecture Behavioral of decoder is
begin

	-- Okamžitě reagujte na změnu vstupního signálu d
	process (d)
	begin

		-- Dekódujte signál d (binární číslo 0 až 3 včetně), který vybírá, která
		-- LED dioda bude svítit (3., 2., 1. nebo 0.) v závislosti na tomto čísle
		case d is
			-- Když je číslo binární 00 (dekadické 0), rozsviťte první LED diodu
	        when "00"   => q <= "1000";

			-- Když je číslo binární 01 (dekadické 1), rozsviťte druhou LED diodu
	        when "01"   => q <= "0100";

			-- Když je číslo binární 10 (dekadické 2), rozsviťte třetí LED diodu
	        when "10"   => q <= "0010";

			-- Když je číslo binární 11 (dekadické 3), rozsviťte čtvrtou LED diodu
			-- Všimněte si použití 'when others', efektivně zde zpracováváme '11'
	        when others => q <= "0001";
	    end case;

	end process;

end Behavioral;
