library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vectors is
    port (
        -- Vektor vstupních přepínačů (15 je nejvíce vlevo, 0 je nejvíce vpravo)
        switches : in std_logic_vector(15 downto 0);

        -- Výstupní LED diody (15 je nejvíce vlevo, 0 je nejvíce vpravo)
        LEDs     : out std_logic_vector(15 downto 0)
    );
end vectors;


architecture Behavioral of vectors is
begin

    -- Ve vektoru LEDs nastavte všechny LED diody od 15 do 14 (včetně) na 0,
    -- efektivně je vypněte
    LEDs(15 downto 14) <= (others => '0');

    -- Ve vektoru LEDs nastavte všechny LED diody od 13 do 12 (včetně) na 1,
    -- efektivně je zapněte
    LEDs(13 downto 12) <= (others => '1');

    -- Předejte signály z přepínačů 3 do 0 (včetně) na LED diody 11 do 8
    -- (včetně), abyste je mohli zapínat a vypínat pomocí přepínačů
    LEDs(11 downto 8) <= switches(3 downto 0);

    -- Rozsviťte LED diody 7 do 0 (včetně) tak, že jeden přepínač
    -- zapne dvě sousední LED diody
    LEDs(7 downto 0) <= (switches(7) & switches(7)) & (switches(6) & switches(6)) &
                        (switches(5) & switches(5)) & (switches(4) & switches(4));

end Behavioral;
