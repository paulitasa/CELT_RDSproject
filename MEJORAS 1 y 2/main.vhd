----------------------------------------------------------------------------------
--
-- Módulo principal, descripción estructural: cableado.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity main is
    Port ( CLK : in  STD_LOGIC;                      -- Entrada del reloj principal de 50 MHz
           LIN : in  STD_LOGIC;                      -- Entrada de datos del circuito analógico
           SEG7 : out  STD_LOGIC_VECTOR (0 to 6);    -- Salidas para los segmentos del display
           AN : out  STD_LOGIC_VECTOR (3 downto 0);  -- Salidas de activación de los displays 
			  RESET : in STD_LOGIC); 						  -- MEJORA 1: ENTRADA RESET MANUAL
end main;

architecture a_main of main is

-- COMPONENTES
--------------


component div_reloj 
    Port ( CLK : in  STD_LOGIC;           -- Entrada reloj de la FPGA 50 MHz
           CLK_1ms : out  STD_LOGIC);     -- Salida reloj a 1 KHz
end component;

component detector_bit 
    Port ( CLK_1ms : in  STD_LOGIC;   
			  LIN : in  STD_LOGIC; 
           BITS : out  STD_LOGIC);    
end component;

component aut_captura 
    Port ( CLK_1ms : in  STD_LOGIC;   
			  BITS : in  STD_LOGIC; 
           CAP : out  STD_LOGIC;
			  RESET : in STD_LOGIC;
			  RESETA : in STD_LOGIC);    
end component;

component reg_desp_9b 
    Port ( CLK_1ms : in  STD_LOGIC;   
			  DAT : in  STD_LOGIC; 
			  EN : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR(8 downto 0));    
end component;

component aut_control 
    Port ( CLK_1ms : in  STD_LOGIC;   
			  ASCII : in STD_LOGIC_VECTOR(8 downto 0); 
			  VALID_DISP : out STD_LOGIC;
			  RESET : in STD_LOGIC;
			  RESETAE : in STD_LOGIC;
			  RESETA : out STD_LOGIC);
			    
end component;

component visualizacion 
    Port ( CLK_1ms : in  STD_LOGIC;   
			  E0 : in  STD_LOGIC_VECTOR(7 downto 0); 
			  EN : in  STD_LOGIC;
           SEG7 : out  STD_LOGIC_VECTOR(0 to 6);
			  AN : out  STD_LOGIC_VECTOR(3 downto 0));    
end component;

-- SEÑALES
----------

signal AUX1 : STD_LOGIC;
signal AUX2 : STD_LOGIC;
signal AUX3 : STD_LOGIC;
signal AUX4 : STD_LOGIC_VECTOR(8 downto 0);
signal AUX5 : STD_LOGIC;
signal AUX_RESETA : STD_LOGIC;


begin

-- INTERCONEXIÓN DE MÓDULOS
---------------------------

U1 : div_reloj     
		port map (
					CLK=> CLK,
					CLK_1ms=> AUX1
					);
					
U2: detector_bit     
		port map (
					CLK_1ms=> AUX1,
					LIN=> LIN,
					BITS=> AUX2
					);					
U3: aut_captura     
		port map (
					CLK_1ms=> AUX1,
					BITS=> AUX2,
					CAP=> AUX3,
					RESET=> RESET,
					RESETA=> AUX_RESETA
					);				
										
U4: reg_desp_9b     
		port map (
					CLK_1ms=> AUX1,
					DAT=> AUX2,
					EN=> AUX3,
					Q => AUX4
					);	

U5: aut_control     
		port map (
					CLK_1ms=> AUX1,
					ASCII=> AUX4,
					VALID_DISP => AUX5,
					RESET=> RESET,
					RESETA=> AUX_RESETA,
					RESETAE=> AUX_RESETA
					);	

U6: visualizacion     
		port map (
					CLK_1ms=> AUX1,
					E0=> AUX4(7 downto 0),
					EN=> AUX5,
					SEG7=> SEG7,
					AN=> AN
					);	

end a_main;

