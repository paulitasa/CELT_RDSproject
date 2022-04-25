----------------------------------------------------------------------------------
--
-- Autómata de captura de bits
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aut_captura is
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           BITS : in  STD_LOGIC;     -- Bits de entrada
           CAP : out  STD_LOGIC);    -- Señal para el registro de captura
end aut_captura;

architecture a_aut_captura of aut_captura is
type STATE_TYPE is (ESP0,ESP1,DESP25,CAPT,DESP100);

signal ST : STATE_TYPE := ESP0;
signal cont : STD_LOGIC_VECTOR (7 downto 0):="00000000";

begin
  process (CLK_1ms)
    begin
      if CLK_1ms'event and CLK_1ms='1' then
        case ST is
          when ESP0 =>				-- El automata esta en el estado ESP0
            if BITS='1' then     -- Espera a que llegue un 0 para pasar a ESP1
              ST<=ESP0;
            else
              ST<=ESP1;
            end if;

          when ESP1 =>				-- El automata esta en el estado ESP1
				if BITS='0' then     -- Espera al primer flanco de subida para pasar a DESP25
              ST<=ESP1;
            else
              ST<=DESP25;
            end if;				

          when DESP25 =>			-- El automata esta en el estado DESP25
            cont<=cont+1;  
            if cont>=25 then     -- Espera 25ms para pillar el bit en una posicion estable
					ST<=CAPT;         -- El automata pasa a CAPT
				else
              ST<=DESP25;
            end if;
				
			 when CAPT =>  		   -- El automata esta en el estado CAPT
            cont<="00000000";		-- Pone el contador a 0
            ST<=DESP100;			-- El automata pasa a DESP100
				
			 when DESP100 =>			-- El automata esta en el estado DESP100
            cont<=cont+1;
            if cont>=98 then		-- Espera 98 ms para pillar el siguiente bit
					ST<=CAPT;			-- El automata vuelve a CAPT
				else
              ST<=DESP100;
            end if;
          
 
         end case;		
       end if;
    end process;
	 
  CAP<='1' when ST=CAPT else '0';		-- La señal CAP se activa en el estado CAPT

end a_aut_captura;

