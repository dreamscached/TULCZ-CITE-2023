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

    -- Konečný stavový stroj Moore pro nalezení sekvence 0101 má 5 stavů
    type fsm_type is (S0, S1, S2, S3, S4);

    -- Signály aktuálního a následujícího stavu
    signal current_state, next_state : fsm_type;

begin

    -- Paměť konečného stavového stroje
    mem : process(clk)
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
    transfer : process(current_state, seq)
    begin

        -- Původně nastavte následující stav na aktuální stav
        next_state <= current_state;

        -- Počáteční stav signálu nalezeno
        found      <= '0';

        -- V závislosti na aktuálním stavu přejděte do jiného stavu
        case current_state is

            -- Stav 0, očekávání 0
            -- Toto je počáteční stav
            when S0 =>

                found <= '0'; -- Sekvence ještě nebyla nalezena

                case seq is

                    -- Když je přijato 0, přejděte do stavu S1
                    when '0'    => next_state <= S1;

                    -- Když je přijato 1, zůstaňte ve stavu S0
                    when others => next_state <= S0;

                end case;

            -- Stav 1, očekávání 1
            when S1 =>

                found <= '0'; -- Sekvence ještě nebyla nalezena

                case seq is

                    -- Když je přijato 0, zůstaňte ve stavu S1, protože jsme už našli
                    -- 0 a další bit musí být 1
                    when '0'    => next_state <= S1;

                    -- Když je přijato 1, přejděte do stavu S2
                    when others => next_state <= S2;

                end case;

            -- Stav 2, očekávání 0
            when S2 =>

                found <= '0'; -- Sekvence ještě nebyla nalezena

                case seq is

                    -- Když je přijato 0, přejděte do stavu S3
                    when '0'    => next_state <= S3;

                    -- Když je přijato 1, přejděte do stavu S0
                    when others => next_state <= S0;

                end case;

            -- Stav 3, očekávání 1
            when S3 =>

                found <= '0'; -- Sekvence ještě nebyla nalezena

                case seq is

                    -- Když je přijato 0, přejděte do stavu S1
                    when '0'    => next_state <= S1;

                    -- Když je přijato 1, přejděte do stavu S4
                    when others => next_state <= S4;

                end case;

            -- Stav 4, vrácení zpět do S0 nebo do S1, v závislosti na vstupu
            when S4 =>

                found <= '1'; -- Sekvence nalezena

                case seq is

                    -- Když je přijato 0, přejděte do stavu S1
                    when '0'    => next_state <= S1;

                    -- Když je přijato 1, přejděte do stavu S0
                    when others => next_state <= S0;

                end case;

            -- Když není splněna žádná podmínka, vrátí se do počátečního stavu
            when others => next_state <= S0;

        end case;

    end process;

end Behavioral;
