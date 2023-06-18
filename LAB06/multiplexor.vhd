library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplexor is
    port (
        -- Vstupní datový vektor a výběr
        d : in std_logic_vector(3 downto 0);
        s : in std_logic_vector(1 downto 0);

        -- Výstupní data vybraná z vstupu
        q : out std_logic
    );
end multiplexor;


architecture Behavioral of multiplexor is
begin

    -- Okamžitě reagovat na změnu datového signálu nebo výběru
    process (d, s)
    begin

        -- Vyberte vstupní datový bit v závislosti na hodnotě výběru
        case s is
            when "00"   => q <= d(0);
            when "01"   => q <= d(1);
            when "10"   => q <= d(2);
            when others => q <= d(3);
        end case;

    end process;

end Behavioral;