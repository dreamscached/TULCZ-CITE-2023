library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity display_driver is
    port(
        -- Signál hodin
        clock    : in  std_logic;

        -- Signál tlačítka pro resetování
        reset    : in  std_logic;

        -- Vstupní vektor dat (32bitové číslo)
        din      : in  std_logic_vector(31 downto 0);

        -- Vektor pro rozsvícení segmentů
        segments : out std_logic_vector(7 downto 0);

        -- Vektor pro aktivní displeje
        displays : out std_logic_vector(7 downto 0)
    );
end display_driver;


architecture Behavioral of display_driver is

    -- Konstanty frekvence pro poskytnutí správného zpoždění
    constant DIV100HZ_WIDTH : integer := 20;
    constant DIV100HZ_LIMIT : integer := 1000000;

    -- Signál k použití pro indikaci, když je čítač hotov
    signal   div100Hz_done  : std_logic;

    -- Nastavte základní šířku čítače na 3 bity
    constant CYCLECNT_WIDTH : integer := 3;

    -- Signál pro uchování hodnoty čítače
    signal   cnt            : std_logic_vector(CYCLECNT_WIDTH - 1 downto 0);

    -- Signál pro výběr aktuálně zobrazené číslice
    signal   digit          : std_logic_vector(3 downto 0);

begin

    -- Použijte čítač pro vysílání signálu s frekvencí 100 Hz
    clock_div : entity work.counter
        -- Nastavit šířku čítače na šířku čítače 100 Hz
        generic map (COUNTER_WIDTH => DIV100HZ_WIDTH)
        port map (
            -- Předat signál hodin
            clock        => clock,

            -- Zrušit hodnotu čítače
            cnt          => open,

            -- Nikdy nerestartovat tento čítač
            reset        => '0',

            -- Vždy počítejte nahoru
            clock_enable => '1',

            -- Omezit čítač, aby dosáhl indikace signálu done při 100 Hz
            limit        => std_logic_vector(to_unsigned(DIV100HZ_LIMIT, DIV100HZ_WIDTH)),

            -- Vždy opakujte počítání
            repeat       => '1',

            -- Vysílejte signál, když je hotovo
            done         => div100Hz_done
        );

    -- Použijte čítač pro cyklické procházení zobrazované číslice při 100 Hz
    cycle_cnt : entity work.counter
        -- Nastavit šířku čítače na šířku čítače 100 Hz
        generic map(COUNTER_WIDTH => CYCLECNT_WIDTH)
        port map (
            -- Předat signál hodin
            clock        => clock,

            -- Přijměte hodnotu čítače jako signál
            cnt          => cnt,

            -- Nikdy nerestartujte čítač
            reset        => '0',

            -- Povolte čítač pouze každých 100 Hz, aby se počítalo jednou
            clock_enable => div100Hz_done,

            -- Omezte tento čítač na maximální hodnotu bitu CYCLECNT_WIDTH
            limit        => (others => '1'),

            -- Vždy opakujte počítání
            repeat       => '1',

            -- Zrušte signál done
            done         => open
        );

    -- Zpracovat počet, změnit aktivní displej v závislosti na něm a číslici, kterou
    -- displej ukazuje, to jsou ve skutečnosti dva multiplexory
    process (cnt)
    begin

        -- Na základě čítače, prochází aktivní displej
        case cnt is
            when "000"  => displays <= "11111110";
            when "001"  => displays <= "11111101";
            when "010"  => displays <= "11111011";
            when "011"  => displays <= "11110111";
            when "100"  => displays <= "11101111";
            when "101"  => displays <= "11011111";
            when "110"  => displays <= "10111111";

            -- Others zde znamená "111"
            when others => displays <= "01111111";
        end case;

        -- Na základě čítače, prochází aktuálně zobrazenou číslici (vybírá
        -- 4 bity na různých pozicích)
        case cnt is
            when "000"  => digit <= din(3 downto 0);
            when "001"  => digit <= din(7 downto 4);
            when "010"  => digit <= din(11 downto 8);
            when "011"  => digit <= din(15 downto 12);
            when "100"  => digit <= din(19 downto 16);
            when "101"  => digit <= din(23 downto 20);
            when "110"  => digit <= din(27 downto 24);
            when others => digit <= din(31 downto 28);
        end case;

    end process;

    -- Zpracovat hodnotu číslice, která je vybrána multiplexorem výše (rozsvítí
    -- odpovídající segmenty na 7-segmentovém displeji, první bit je dioda desetinné
    -- tečky, která musí zůstat vypnuta)
    process (digit)
    begin

        case digit is
            when "0000" => segments <= "11000000"; -- 0
            when "0001" => segments <= "11111001"; -- 1
            when "0010" => segments <= "10100100"; -- 2
            when "0011" => segments <= "10110000"; -- 3
            when "0100" => segments <= "10011001"; -- 4
            when "0101" => segments <= "10010010"; -- 5
            when "0110" => segments <= "10000010"; -- 6
            when "0111" => segments <= "11111000"; -- 7
            when "1000" => segments <= "10000000"; -- 8
            when "1001" => segments <= "10010000"; -- 9
            when "1010" => segments <= "10001000"; -- A
            when "1011" => segments <= "10000011"; -- B
            when "1100" => segments <= "11000110"; -- C
            when "1101" => segments <= "10100001"; -- D
            when "1110" => segments <= "10000110"; -- E
            when others => segments <= "10001110"; -- F
        end case;

    end process;

end Behavioral;
