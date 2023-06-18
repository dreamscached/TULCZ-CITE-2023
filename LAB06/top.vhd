library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    port (
		-- Vstupní přepínače (15 je nejvíce vlevo, 0 je nejvíce vpravo)
        SW  : in std_logic_vector(15 downto 0);

		-- Výstupní LED diody (15 je nejvíce vlevo, 0 je nejvíce vpravo)
        LED : out std_logic_vector(15 downto 0)
    );
end top;


architecture Behavioral of top is

	-- Mezipaměť pro uchování hodnot vybraných multiplexorem
	signal mux_out : std_logic_vector(1 downto 0);

begin

	-- Použijeme multiplexor (nazveme jej MUX1) pro výběr následujících hodnot:
	MUX1 : entity work.multiplexor port map (
		-- Vstupní data jsou přepínače od 5 do 2 (včetně)
		d => SW(5 downto 2),

		-- Vybráno přepínači od 1 do 0 (včetně)
		s => SW(1 downto 0),

		-- Vybraný signál je předán do mux_out(1)
		q => mux_out(1)
	);

	-- Použijeme multiplexor (nazveme jej MUX2) pro výběr následujících hodnot:
	MUX2 : entity work.multiplexor port map (
		-- Vstupní data jsou přepínače od 11 do 8 (včetně)
		d => SW(11 downto 8),

		-- Vybráno přepínači od 7 do 6 (včetně)
		s => SW(7 downto 6),

		-- Vybraný signál je předán do mux_out(0)
		q => mux_out(0)
	);

	-- Použijeme dekodér pro dekódování následujících hodnot:
    DEC : entity work.decoder port map (
		-- Vstupní data k dekódování je výstup dvou multiplexovaných hodnot vybraných
        -- MUX1 (mux_out(1)) a MUX2 (mux_out(0))
		d => mux_out,

		-- Výstupní data jsou mapována na LED diody od 15 do 12 (včetně)
		q => LED(15 downto 12)
	);

	-- Rozsviťte LED diody 8 a 2, aby ukázaly hodnoty signálů vybraných multiplexory
	LED(8) <= mux_out(1);
	LED(2) <= mux_out(0);

end Behavioral;
