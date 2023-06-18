library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity johnson_count is
    port (
        -- Hodinový signál
        clock     : in  std_logic;

        -- Přepínač resetu
        reset     : in  std_logic;

        -- Výstupní hodnoty Johnsonova čítače a dekódované binární hodnoty
        q_johnson : out std_logic_vector(3 downto 0);
        q_binary  : out std_logic_vector(2 downto 0)
    );
end johnson_count;


architecture Behavioral of johnson_count is

    -- Mezisignál pro řízení resetu
    signal shift_not_load : std_logic;

    -- Signál pro řízení sériového vstupu
    signal serial_in      : std_logic;

    -- Signál pro řízení sériového výstupu, invertovaný, pro zpětné předání do registru
    -- (princip Johnsonova čítače)
    signal serial_in_inv  : std_logic;

    -- Obsah registru Johnsonova čítače
    signal johnson        : std_logic_vector(3 downto 0);

begin

    -- Pokud je přepínač resetu vypnutý, vezměte vstup ze sériového vstupu, pokud je zapnutý,
    -- naplňte registr nulami, resetujte ho
    shift_not_load <= not reset;

    -- Připojte instanci posuvného registru, pojmenujte ji REG
    REG : entity work.shift_reg
        -- Tento registr bude mít šířku čtyř bitů
        generic map (WIDTH => 4)
        port map (
            -- Mapujte hodinový signál na hodinový signál registru
            clock          => clock,

            -- Mapujte přepínač režimu na tento registr
            shift_not_load => shift_not_load,

            -- Mapujte konstantní datový vstup, použitý, když je přepínač resetu zapnutý
            data_in        => "0000",

            -- Mapujte obsah registru na signál, abychom k němu mohli přistupovat
            data_out       => johnson,

            -- Mapujte sériový vstup na invertovaný sériový výstup, základní princip Johnsonova
            -- čítače
            serial_in      => serial_in_inv,

            -- Mapujte sériový výstup na sériový vstup (který je invertovaný, viz výše)
            serial_out     => serial_in
        );


    -- Invertujte sériový vstup, aby Johnsonův čítač fungoval
    serial_in_inv <= not serial_in;

    -- Mapujte obsah registru na výstupní signál
    q_johnson     <= johnson;

    -- Okamžitě reagujte na změny výstupního signálu, aby jste ho dekódovali
    process (johnson)
    begin

        case johnson is
            when "0000" => q_binary <= "000";
            when "1000" => q_binary <= "001";
            when "1100" => q_binary <= "010";
            when "1110" => q_binary <= "011";
            when "1111" => q_binary <= "100";
            when "0111" => q_binary <= "101";
            when "0011" => q_binary <= "110";

            -- Zde "others" znamená "0001"
            when others => q_binary <= "111";
        end case;

    end process;

end Behavioral;
