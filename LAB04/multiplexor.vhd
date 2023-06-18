library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplexor is
    port (
        -- Vstupní přepínače
        a           : in  std_logic;
        b           : in  std_logic;
        sel         : in  std_logic;

        -- Výstupní LED diody
        q_struct    : out std_logic;
        q_condition : out std_logic
    );
end multiplexor;


architecture Behavioral of multiplexor is
begin

    -- Proces okamžitě reaguje na změnu následujících vstupních portů:
    -- a, b (vstupní signály) a sel (výběr multiplexoru, který signál zobrazit
    -- na výstupním portu q_struct)
    process (a, b, sel)
    begin

		case sel is
            -- Když je výběr nastaven na 0, předejte signál z vstupu A
			when '0'    => q_struct <= a;

            -- Když je výběr nastaven na 1, předejte signál z vstupu B
            -- Všimněte si, jak používáme 'when others'; to je proto, že musíme
            -- zvládnout všechny možné případy v 'case', v podstatě tento podmínka
            -- znamená 'když 1 a jakýkoliv jiný', což je pro naši úlohu dostatečné
			when others => q_struct <= b;
		end case;

        -- Zobrazte vizuálně výběr jako svítící LED diodu, pokud je nastavena na 1
        q_condition <= sel;

    end process;

end Behavioral;
