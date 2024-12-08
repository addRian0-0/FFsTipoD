library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FFMod is
    port (
        clkin             : in  STD_LOGIC; -- Reloj interno
        countBinario      : out STD_LOGIC_VECTOR(1 downto 0); -- Salida binaria
        countDecodificado : out STD_LOGIC_VECTOR(16 downto 0) -- Salida decodificada
    );
end FFMod;

architecture funcionamiento of FFMod is
    signal counTime : STD_LOGIC_VECTOR(24 downto 0) := (others => '0'); -- Contador
    signal clkint   : STD_LOGIC := '0'; -- Reloj interno
    signal q        : STD_LOGIC_VECTOR(1 downto 0) := (others => '0'); -- Contador MOD-4
begin
    -- Generación del reloj interno
    RELOJ: process(clkin)
    begin
        if rising_edge(clkin) then -- Flanco de subida
            if counTime = "1011111010111100001000000" then -- Conteo deseado
                counTime <= (others => '0'); -- Reinicio
                clkint  <= not clkint; -- Inversión
            else
                counTime <= std_logic_vector(unsigned(counTime) + 1); -- Incremento
            end if;
        end if;
    end process;

    -- Contador MOD-4
    CONTADOR: process(clkint)
    begin
        if rising_edge(clkint) then
            q(1) <= q(1) xor q(0);
            q(0) <= not q(0);
        end if;
    end process;

    -- Decodificador
    DECODIFICADOR: process(q)
    begin
        case q is
            when "00" => countDecodificado <= "00000000111111111"; -- 0
            when "01" => countDecodificado <= "11111111101111011"; -- 1
            when "10" => countDecodificado <= "10010111111101011"; -- 2
            when others => countDecodificado <= "10000111111101111"; -- 3
        end case;
    end process;

    -- Salida binaria
    countBinario <= q;
end funcionamiento;
