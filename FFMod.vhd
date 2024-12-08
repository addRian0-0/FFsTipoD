library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FFMod is
    port (
        clkin             : in  STD_LOGIC; -- Reloj interno
        countBinario      : out STD_LOGIC_VECTOR(2 downto 0); -- Salida binaria
        salida : out STD_LOGIC_VECTOR(16 downto 0) -- Salida decodificada
    );
end FFMod;

architecture funcionamiento of FFMod is
    signal counTime : STD_LOGIC_VECTOR(24 downto 0) := (others => '0'); -- Contador
    signal clkint   : STD_LOGIC := '0'; -- Reloj interno
    signal q        : STD_LOGIC_VECTOR(2 downto 0) := "101"; -- Inicialización en 5
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

    -- Contador MOD-6
    CONTADOR: process(clkint)
    begin
        if rising_edge(clkint) then
		  
				--q(2) <= (not q(2) and not q(1) and not q(0)) or (q(2) and not q(1) and q(0));  -- D2
            --q(1) <= (not q(2) and q(1) and not q(0)) or (q(2) and not q(1) and not q(0));  -- D1
            --q(0) <= (not q(1) and not q(0)) or (not q(2) and q(1) and q(0));
		  
				case q is
                when "101" => q <= "100";  -- Estado 5 → 4
                when "100" => q <= "011";  -- Estado 4 → 3
                when "011" => q <= "010";  -- Estado 3 → 1
					 when "010" => q <= "001";  -- Estado 2 → 1
                when "001" => q <= "000";  -- Estado 1 → 0
                when "000" => q <= "101";  -- Estado 0 → 5 (Reinicia el ciclo)
                when others => q <= "101";  -- Si por alguna razón llegamos a un estado inesperado, volvemos al estado 5
            end case; 
        end if;
		  
    end process;

    -- Decodificador
    DECODIFICADOR: process(q)
    begin
        case q is
		  
				when "101" =>  salida <= "10100111101101111"; -- 5
				when "100" => salida <= "11001111101101111"; -- 4 
				when "011" => salida <= "10000111111101111"; -- 3
				when "010" => salida <= "10010111111101011"; -- 2
				when "001" => salida <= "11111111101111011"; -- 1
				when "000" => salida <= "00000000111111111"; -- 1
            when others => salida <= "00000000111111111"; -- 0
        end case;
    end process;

    -- Salida binaria
    countBinario <= q;
end funcionamiento;
