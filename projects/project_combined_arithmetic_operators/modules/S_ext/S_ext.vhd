LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY S_ext IS
    PORT (
        S : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado de 4 bits
        C : IN STD_LOGIC; -- Carry (no se utiliza para la extensión)
        OP : IN STD_LOGIC; -- 0 = Suma, 1 = Resta
        R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) -- Salida extendida a 10 bits
    );
END S_ext;

ARCHITECTURE S_ext_Arch OF S_ext IS
    CONSTANT ZERO6 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
    CONSTANT ONE6 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111111";
    SIGNAL aux : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL GT1 : STD_LOGIC;
    SIGNAL ext_val : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
    -- Extiende S a 10 bits (6 bits de relleno + 4 bits S)
    aux <= ZERO6 & S WHEN S(3) = '0' ELSE
        ONE6 & S;

    -- Compara aux con 10 bits de cero (para determinar el signo)
    Comp1 : ENTITY WORK.N_bit_greater
        PORT MAP(
            A => aux,
            B => (OTHERS => '0'), -- 10 bits de ceros
            GT => GT1
        );

    -- Si aux es mayor o igual que 0 (positivo) extiende con ceros,
    -- de lo contrario (negativo) extiende con unos.
    ext_val <= ZERO6 & S WHEN GT1 = '1' ELSE
        ONE6 & S;

    -- Selecciona la salida según OP.
    -- En ambos casos, para la extensión del resultado se ignora el carry,
    -- ya que lo que se quiere es conservar el valor de S extendido.
    R <= ext_val;
END S_ext_Arch;