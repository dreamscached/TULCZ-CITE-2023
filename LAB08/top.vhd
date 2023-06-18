library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top is
    port(
        -- Hodinový signál
        clock                                            : in  std_logic;

        -- Porty tlačítek
        btn_up, btn_right, btn_down, bt_left, btn_center : in  std_logic;

        -- Vstupní spínače
        SW                                               : in  std_logic_vector(15 downto 0);

        -- Výstupní LED diody
        LED                                              : out std_logic_vector(15 downto 0);

        -- Jedna modrá LED
        LED_BLUE                                         : out std_logic;

        -- Segmenty displeje pro osvětlení
        segments                                         : out std_logic_vector(7 downto 0);

        -- Vektor rozsvícených displejů
        displays                                         : out std_logic_vector(7 downto 0)
    );
end top;


architecture Behavioral of top is

    -- Frekvenční konstanty pro poskytnutí správného zpoždění
    constant DIV100HZ_WIDTH : integer := 20;
    constant DIV100HZ_LIMIT : integer := 1000000;

    -- Signál vstupních dat, přijatý od spínačů a doplněný nulami
    signal din : std_logic_vector(31 downto 0);

begin

    -- Nechť vstupní data jsou hodnoty 16 spínačů plus 16 nulových bitů
    din <= SW & "0000000000000000";

    -- Použijte ovladač displeje pro zobrazení vybraného čísla
    display : entity work.display_driver port map (
        -- Předejte hodinový signál
        clock    => clock,

        -- Neobnovujte displej
        reset    => '0',

        -- Předejte vstupní data (číslo vybrané spínači)
        din      => din,

        -- Mapujte port segmentů
        segments => segments,

        -- Mapujte port displejů
        displays => displays
    );

end Behavioral;
