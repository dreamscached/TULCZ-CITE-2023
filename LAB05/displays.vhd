library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity displays is
    port (
        -- Vstupní vektory, výběr displeje a čísla k zobrazení
        disp_sel : in  std_logic_vector(2 downto 0);
        char_sel : in  std_logic_vector(3 downto 0);

        -- Výstupní vektory, vybraný displej a vybrané segmenty
        displays : out std_logic_vector(7 downto 0);
        segments : out std_logic_vector(6 downto 0)
    );
end displays;


architecture Behavioral of displays is
begin

    -- Okamžitě reagujte na změnu vstupního signálu disp_sel
    process (disp_sel)
    begin

        -- Dekódujte 3bitový výběr (číslo 0 až 7), který vybere, který displej
        -- (označený nulou v přiřazeném vektoru bitů) bude zapnut
        case disp_sel is
            when "000"  => displays <= "11111110";
            when "001"  => displays <= "11111101";
            when "010"  => displays <= "11111011";
            when "011"  => displays <= "11110111";
            when "100"  => displays <= "11101111";
            when "101"  => displays <= "11011111";
            when "110"  => displays <= "10111111";
            when others => displays <= "01111111";
        end case;

    end process;

    process (char_sel)
    begin

        -- Dekódujte 4bitové číslo (0 až F, hexadecimálně), které se zobrazí na
        -- vybraném displeji. Jedničky reprezentují vypnuté segmenty, nuly
        -- reprezentují zapnuté a svítící segmenty
        case char_sel is
            when "0000" => segments <= "1000000"; -- 0
            when "0001" => segments <= "1111001"; -- 1
            when "0010" => segments <= "0100100"; -- 2
            when "0011" => segments <= "0110000"; -- 3
            when "0100" => segments <= "0011001"; -- 4
            when "0101" => segments <= "0010010"; -- 5
            when "0110" => segments <= "0000010"; -- 6
            when "0111" => segments <= "1111000"; -- 7
            when "1000" => segments <= "0000000"; -- 8
            when "1001" => segments <= "0010000"; -- 9
            when "1010" => segments <= "0001000"; -- A
            when "1011" => segments <= "0000011"; -- B
            when "1100" => segments <= "1000110"; -- C
            when "1101" => segments <= "0100001"; -- D
            when "1110" => segments <= "0000110"; -- E
            when others => segments <= "0001110"; -- F
        end case;

    end process;

end Behavioral;
