library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity debounce is
    port(
        -- Signál hodin
        clock        : in  std_logic;

        -- Tlačítko (nebo jakýkoli jiný signál), na který se aplikuje logika odrušení
        button       : in  std_logic;

        -- Informace o tom, zda je toto tlačítko stisknuto nebo ne
        pressed      : out std_logic
    );
end debounce;


architecture Behavioral of debounce is

    -- Konstanty frekvence pro poskytnutí správného zpoždění
    constant DIV100HZ_WIDTH : integer := 20;
    constant DIV100HZ_LIMIT : integer := 1000000;

    -- Mezisignál pro indikaci, že čítač je hotov
    signal div100Hz_done : std_logic;

    -- Předchozí hodnota signálu tlačítka
    signal last_button_value : std_logic;

    -- Aktuální hodnota signálu tlačítka
    signal actual_button_value : std_logic;

begin

    -- Připojit instanci čítače a pojmenovat ji clock_div
    clock_div : entity work.counter
        -- Nastavit šířku čítače na konstantní hodnotu
        generic map (COUNTER_WIDTH => DIV100HZ_WIDTH)
        port map (
            -- Předat signál hodin
            clock        => clock,

            -- Zrušit hodnotu čítače, zajímá nás pouze signál done
            cnt          => open,

            -- Čítač nikdy nebude ručně resetován
            reset        => '0',

            -- Čítač bude vždy aktivní
            clock_enable => '1',

            -- Limit bude nastaven na vektor DIV100HZ_WIDTH logických jedniček
            limit        => std_logic_vector(to_unsigned(DIV100HZ_LIMIT, DIV100HZ_WIDTH)),

            -- Tento čítač musí opakovat, když dosáhne limitu
            repeat       => '1',

            -- Po dokončení počítání vydá signál do div100Hz_done
            done         => div100Hz_done
        );


    -- Zpracování signálu hodin a provedení logiky...
    process (clock)
    begin

        -- ... tak, abychom provedli nějaké zpracování s frekvencí 100 Hz
        if rising_edge(clock) then
            if div100Hz_done = '1' then

                -- Udržet aktuální a poslední stavy signálu tlačítka
                actual_button_value <= button;
                last_button_value <= actual_button_value;

            end if;
        end if;

    end process;

    -- Zpracování signálu hodin a provedení logiky...
    process (clock)
    begin

        -- ... tak, abychom provedli logiku s frekvencí 100 Hz
        if rising_edge(clock) then
            pressed <= '0';
            if div100Hz_done = '1' then

                -- Detekovat stoupající nebo klesající hranu signálu tlačítka (zde stoupající)
                if actual_button_value = '1' and last_button_value = '0' then
                    -- Při vzestupu vydá signál pressed
                    pressed <= '1';
                end if;

            end if;
        end if;

    end process;

end Behavioral;
