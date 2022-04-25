----------------------------------------------------------------------------------
-- 
-- Módulo de visualización, descripción estructural: cableado.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity visualizacion is
    
  Port ( E0   : in  STD_LOGIC_VECTOR (7 downto 0);   -- Entrada siguiente carácter
         EN   : in  STD_LOGIC;                       -- Activación para desplazamiento
         CLK_1ms  : in  STD_LOGIC;                   -- Entrada de reloj de refresco       
         SEG7 : out  STD_LOGIC_VECTOR (0 to 6);      -- Salida para los displays 
         AN   : out  STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end visualizacion;


architecture a_visualizacion of visualizacion is

-- COMPONENTES
--------------

component MUX4x8
  Port (   E0 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 0
           E1 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 1
           E2 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 2
           E3 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 3
           S : in  STD_LOGIC_VECTOR (1 downto 0);  -- Señal de control
           Y : out  STD_LOGIC_VECTOR (7 downto 0)); -- Salida
end component;

component decodASCIIa7s
  Port (   CODIGO : in  STD_LOGIC_VECTOR (7 downto 0); -- Código ASCII
           SEGMENTOS : out  STD_LOGIC_VECTOR (0 to 6)); -- Salidas al display
end component;

component refresco
  Port (   CLK_1ms : in  STD_LOGIC;                -- Reloj refresco
           S : out  STD_LOGIC_VECTOR (1 downto 0); -- Control para el mux
           AN : out  STD_LOGIC_VECTOR (3 downto 0)); -- Control displays
end component;

component rdesp_disp
  Port (   CLK_1ms : in  STD_LOGIC; -- Entrada de reloj
           EN : in  STD_LOGIC; -- Enable
           E : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos
           Q0 : out  STD_LOGIC_VECTOR (7 downto 0); -- Salida Q0
			  Q1 : out  STD_LOGIC_VECTOR (7 downto 0); -- Salida Q1
			  Q2 : out  STD_LOGIC_VECTOR (7 downto 0); -- Salida Q2
			  Q3 : out  STD_LOGIC_VECTOR (7 downto 0)); -- Salida Q3
end component;

signal N_E0 : STD_LOGIC_VECTOR (7 downto 0);
signal N_E1 : STD_LOGIC_VECTOR (7 downto 0);
signal N_E2 : STD_LOGIC_VECTOR (7 downto 0);
signal N_E3 : STD_LOGIC_VECTOR (7 downto 0);
signal N_ES : STD_LOGIC_VECTOR (1 downto 0);
signal N_EY : STD_LOGIC_VECTOR (7 downto 0);

begin

U1: MUX4x8
		port map(
			E0=>N_E0,
         E1=>N_E1,
         E2=>N_E2,
         E3=>N_E3,
         S=>N_ES,
         Y=>N_EY
			);
			
U2: decodASCIIa7s
		port map(
			CODIGO=>N_EY,
         SEGMENTOS=>SEG7
			);
			
U3: refresco
		port map(
			CLK_1ms=>CLK_1ms,
         S=>N_ES,
			AN=>AN
			);
			
U4: rdesp_disp
		port map(
			CLK_1ms=>CLK_1ms,
         EN=>EN,
			E=>E0,
			Q0=>N_E0,
			Q1=>N_E1,
			Q2=>N_E2,
			Q3=>N_E3
			);

end a_visualizacion;


