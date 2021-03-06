----------------------------------------------------------------------------------
--
-- Registro de desplazamiento de 9 bits SERIE/PARALELO con enable
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_desp_9b is
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           DAT : in  STD_LOGIC;      -- Entrada de datos
           EN : in  STD_LOGIC;       -- Entrada de ENABLE     
           Q : out  STD_LOGIC_VECTOR (8 downto 0)); --Salida paralelo
end reg_desp_9b;

architecture a_reg_desp_9b of reg_desp_9b is

signal s_Q : STD_LOGIC_VECTOR (8 downto 0):="000000000";

begin

  process (CLK_1ms)
    begin
		if(CLK_1ms'event and CLK_1ms='1') then		-- Cada flanco de subida
		 if(EN='1') then								-- Cuando el enable esta activo
				s_Q <= s_Q (7 downto 0) & DAT;	-- Desplaza los datos hacia la izquierda  e introduce 			
			end if;										-- el dato entrante
		end if;

    end process;
	 
Q<=s_Q;   -- La se?al s_Q se cablea con la salida

end a_reg_desp_9b;

