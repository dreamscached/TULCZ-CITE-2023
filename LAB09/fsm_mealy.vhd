library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fsm_mealy is
    port(
        -- Hodinový signál
        clk   : in  std_logic;

        -- Signál tlačítka reset
        rst   : in  std_logic;

        -- Prvek vstupní sekvence
        seq   : in  std_logic;

        -- Signál k vyslání, když je nalezen
        found : out std_logic
    );
end fsm_mealy;


architecture Behavioral of fsm_mealy is

    -- Konečný stavový stroj Mealy pro nalezení sekvence 0101 má 4 stavy
    type fsm_type is (S0, S1, S2, S3);

    -- Signály aktuálního a následujícího stavu
    signal current_state, next_state : fsm_type;

begin

    -- Paměť konečného stavového stroje
    mem : process (clk)
    begin

        -- Provede logiku pouze na náběžné hraně
        if rising_edge(clk) then

            -- Resetovat stav, pokud je resetovací signál nahoru
            case rst is
                when '1'    => current_state <= S0;
                when others => current_state <= next_state;
            end case;

        end if;

    end process;

    -- Přesun mezi stavy stroje
    transfer : process (current_state, seq)
    begin

        -- Původně nastavte následující stav na aktuální stav
        next_state <= current_state;

        -- V závislosti na aktuálním stavu přejděte do jiného stavu
        case current_state is

            -- Stav 0, očekávání 0
            -- Toto je počáteční stav
            when S0 => case seq is

                -- Když je přijato 0, přejděte na S1
                when '0' =>
                    found      <= '0';
                    next_state <= S1;

                -- Když je přijato 1, nic nedělejte
                when others =>
                    found      <= '0';
                    next_state <= S0;

            end case;

            -- Stav 1, očekávání 1
            when S1 => case seq is

                -- Když je přijato 0, přejděte na S1
                -- To je proto, že jsme již přijali nulu, potřebujeme se dívat
                -- dál na 1
                when '0' =>
                    found      <= '0';
                    next_state <= S1;

                -- Když je přijato 1, přejděte na S2
                when others =>
                    found      <= '0';
                    next_state <= S2;

            end case;

            -- Stav 2, očekávání 0
            when S2 => case seq is

                -- Když je přijato 0, přejděte na S3
                when '0' =>
                    found      <= '0';
                    next_state <= S3;

                -- Když je přijato 1, přejděte na S0
                when others =>
                    found      <= '0';
                    next_state <= S0;

            end case;

            -- Stav 3, očekávání 1
            when S3 => case seq is

                -- Když je přijato 0, přejděte na S1 a hledejte dále 1
                when '0' =>
                    found      <= '0';
                    next_state <= S1;

                -- Když je přijato 1, sekvence je kompletní, nastavte found na 1
                -- a vraťte se do počátečního stavu
                when others =>
                    found      <= '1';
                    next_state <= S0;

            end case;

            -- Když není splněna žádná podmínka, vrátí se do počátečního stavu
            when others => next_state <= S0;

        end case;

    end process;

end Behavioral;
