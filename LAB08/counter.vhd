library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter is

    generic(
        -- Šířka registru čítače v bitech
        COUNTER_WIDTH : integer := 4
    );

    port(
        -- Hodinový signál
        clock        : in  std_logic;

        -- Číselná hodnota čítače
        cnt          : out std_logic_vector(COUNTER_WIDTH - 1 downto 0);

        -- Resetovací přepínač
        reset        : in  std_logic;

        -- Přepínač zapnutí/vypnutí hodin
        clock_enable : in  std_logic;

        -- Maximální hodnota, do které se počítá
        limit        : in  std_logic_vector(COUNTER_WIDTH - 1 downto 0);

        -- Přepínač cyklu čítače zapnuto/vypnuto
        repeat       : in  std_logic;

        -- Signál označující, že čítač dokončil počítání a dosáhl limitu
        done         : out std_logic
    );

end counter;


architecture Behavioral of counter is

    -- Signál pro uchování hodnoty čítače
    signal counter_reg : unsigned(COUNTER_WIDTH - 1 downto 0);

begin

    -- Proveďte určitou logiku při každém tiku hodin...
    process (clock)
    begin

        -- ...Pokud je ten tik náběžnou hranou (z 0 na 1)
        if rising_edge(clock) then

            -- Když je zapnutý resetovací přepínač, nastavte čítač na nuly
            if reset = '1' then
                counter_reg <= (others => '0');
            end if;

            -- Když je čítač povolen, počítejte nahoru
            if clock_enable = '1' then

                -- Když čítač dosáhne limitu...
                if counter_reg = unsigned(limit) then

                    -- Označte, že čítač dokončil počítání, předejte 1 na port
                    done <= '1';

                    -- Když je zapnutý přepínač opakování, resetujte čítač, když dosáhne
                    -- nastavené limitní hodnoty
                    if repeat = '1' then
                        counter_reg <= (others => '0');
                    end if;

                -- Dokud čítač nedosáhne limitu, jednoduše pokračujte v počítání (také nastavte
                -- výstupní signál done na 0, protože stále počítá nahoru)
                else
                    counter_reg <= counter_reg + 1;
                    done <= '0';

                end if;

            end if;

        end if;

    end process;

    -- Předání hodnoty čítače jako logického vektoru na port cnt
    cnt <= std_logic_vector(counter_reg);

end Behavioral;