

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_exponencial is
    PORT ( reloj     : in    STD_LOGIC;

           L298N_ENA : inout STD_LOGIC;
           L298N_IN1 : out   STD_LOGIC;
           L298N_IN2 : out   STD_LOGIC;
           L298N_IN3 : out   STD_LOGIC;
           L298N_IN4 : out   STD_LOGIC;
           L298N_ENB : out   STD_LOGIC );
end test_exponencial;

architecture Behavioral of test_exponencial is
    component controlador is
        GENERIC  ( N_bits_datos : INTEGER := 16);
        PORT     ( reloj     : in  STD_LOGIC;
                   pos_x     : in  STD_LOGIC_VECTOR(N_bits_datos-1 downto 0);
        
                   L298N_ENA : out STD_LOGIC;
                   L298N_IN1 : out STD_LOGIC;
                   L298N_IN2 : out STD_LOGIC;
                   L298N_IN3 : out STD_LOGIC;
                   L298N_IN4 : out STD_LOGIC;
                   L298N_ENB : out STD_LOGIC );
    end component;

    signal pos_x : signed (8 downto 0) := (others => '0');
begin

    i_controlador : controlador
        generic map ( N_bits_datos => pos_x'length )
        port map (
           reloj     => reloj,
           pos_x     => STD_LOGIC_VECTOR (pos_x),

           L298N_ENA => L298N_ENA,
           L298N_IN1 => L298N_IN1,
           L298N_IN2 => L298N_IN2,
           L298N_IN3 => L298N_IN3,
           L298N_IN4 => L298N_IN4,
           L298N_ENB => L298N_ENB
    );
    
    process
    begin
            wait until rising_edge(reloj);
            pos_x <= pos_x + 1 after 100 ms;
    end process;
end Behavioral;
