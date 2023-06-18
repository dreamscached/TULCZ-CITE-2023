library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shift_reg is

    generic (
        -- Šířka registru v bitech
        WIDTH : integer := 8
    );

    port (
        -- Hodinový signál
        clock          : in  std_logic;

        -- Vstupní přepínač, určuje zda se registru načítá z datového vstupu nebo sériově
        shift_not_load : in  std_logic;

        -- Datové vstupní a výstupní vektory, WIDTH - 1 až 0 (včetně)
        data_in        : in  std_logic_vector(WIDTH - 1 downto 0);
        data_out       : out std_logic_vector(WIDTH - 1 downto 0);

        -- Sériové vstupní a výstupní porty.
        -- Sériový výstup je poslední bit v registru.
        serial_in      : in  std_logic;
        serial_out     : out std_logic
    );

end shift_reg;


architecture Behavioral of shift_reg is

    -- Vektor registru pro uchování dat, WIDTH - 1 až 0 (včetně)
    signal reg_store : std_logic_vector(WIDTH - 1 downto 0);

begin

    -- Proveďte určitou logiku při každém tiku hodin...
    process (clock)
    begin

        -- ...Když hrana stoupá (hodinový signál se mění z 0 na 1)
        if rising_edge(clock) then

            case shift_not_load is
                -- Když je přepínač režimu nastaven na 0, načtou se hodnoty z datového vstupu
                when '0'    => reg_store <= data_in;

                -- Když je přepínač režimu nastaven na 1, načte se hodnota ze sériového vstupu
                -- a posune se registru doleva (v podstatě vezme všechno
                -- kromě nejlevějšího bitu, připojí bit dat ze sériového vstupu
                -- a nahraje to do vektoru registru)
                when others => reg_store <= reg_store(WIDTH - 2 downto 0) & serial_in;
            end case;

        end if;

    end process;

    -- Datový výstup je efektivně obsahem tohoto vektoru
    data_out   <= reg_store;

    -- Sériový výstup je nejlevější bit tohoto vektoru
    serial_out <= reg_store(WIDTH - 1);

end Behavioral;
