library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    port (
        -- Vstupní data
        d : in  std_logic_vector(1 downto 0);

        -- Výstupní data, dekódovaná
        q : out std_logic_vector(3 downto 0)
    );
end decoder;


architecture Behavioral of decoder is
begin

    -- Okamžitě reagovat na změnu vstupních dat
    process (d)
    begin

        -- V závislosti na hodnotě vstupních dat předejte signál na výstup Q
        case d is
            when "00"   => q <= "0001";
            when "01"   => q <= "0010";
            when "10"   => q <= "0100";
            when others => q <= "1000";
        end case;

    end process;

end Behavioral;