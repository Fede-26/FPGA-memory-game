library ieee;
use ieee.std_logic_1164.all;

entity Memory_Game_Top is
    port (
        i_Clk : in std_logic;
        -- Input switches to enter the pattern
        i_Switch_1 : in std_logic;
        i_Switch_2 : in std_logic;
        i_Switch_3 : in std_logic;
        i_Switch_4 : in std_logic;
        -- Output LEDs to display the pattern
        o_LED_1 : out std_logic;
        o_LED_2 : out std_logic;
        o_LED_3 : out std_logic;
        o_LED_4 : out std_logic;
        -- 7-segment to display the game status
        o_Segment2_A : out std_logic;
        o_Segment2_B : out std_logic;
        o_Segment2_C : out std_logic;
        o_Segment2_D : out std_logic;
        o_Segment2_E : out std_logic;
        o_Segment2_F : out std_logic;
        o_Segment2_G : out std_logic
    );
end Memory_Game_Top;

architecture rtl of Memory_Game_Top is
    constant GAME_LIMIT : integer := 7; -- Increase to make game harder
    constant CLKS_PER_SEC : integer := 27_000_000; -- 27 MHz
    constant DEBOUNCE_LIMIT : integer := 250_000; -- 10 ms debounce filter
    signal w_Switch_1, w_Switch_2, w_Switch_3, w_Switch_4 : std_logic;
    signal w_Score : std_logic_vector(3 downto 0);
    signal w_Segment2_A, w_Segment2_B, w_Segment2_C, w_Segment2_D, w_Segment2_E, w_Segment2_F, w_Segment2_G : std_logic;
    signal w_LED_1, w_LED_2, w_LED_3, w_LED_4 : std_logic;
begin

    -- Debounce the switches
    Debounce_SW1 : entity work.Debounce_Filter
        generic map(
            DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
        )
        port map(
            i_Clk => i_Clk,
            i_Bouncy => not i_Switch_1,
            o_Debounced => w_Switch_1
        );
    Debounce_SW2 : entity work.Debounce_Filter
        generic map(
            DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
        )
        port map(
            i_Clk => i_Clk,
            i_Bouncy => not i_Switch_2,
            o_Debounced => w_Switch_2
        );
    Debounce_SW3 : entity work.Debounce_Filter
        generic map(
            DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
        )
        port map(
            i_Clk => i_Clk,
            i_Bouncy => not i_Switch_3,
            o_Debounced => w_Switch_3
        );
    Debounce_SW4 : entity work.Debounce_Filter
        generic map(
            DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
        )
        port map(
            i_Clk => i_Clk,
            i_Bouncy => not i_Switch_4,
            o_Debounced => w_Switch_4
        );

    -- Game logic
    Game_Inst : entity work.State_Machine_Game
        generic map(
            CLKS_PER_SEC => CLKS_PER_SEC,
            GAME_LIMIT => GAME_LIMIT
        )
        port map(
            i_Clk => i_Clk,
            i_Switch_1 => w_Switch_1,
            i_Switch_2 => w_Switch_2,
            i_Switch_3 => w_Switch_3,
            i_Switch_4 => w_Switch_4,
            o_LED_1 => w_LED_1,
            o_LED_2 => w_LED_2,
            o_LED_3 => w_LED_3,
            o_LED_4 => w_LED_4,
            o_Score => w_Score
        );

    Scoreboard : entity work.Binary_To_7Segment
        port map(
            i_Clk => i_Clk,
            i_Binary_Num => w_Score,
            o_Segment_A => w_Segment2_A,
            o_Segment_B => w_Segment2_B,
            o_Segment_C => w_Segment2_C,
            o_Segment_D => w_Segment2_D,
            o_Segment_E => w_Segment2_E,
            o_Segment_F => w_Segment2_F,
            o_Segment_G => w_Segment2_G
        );

    o_Segment2_A <= w_Segment2_A;
    o_Segment2_B <= w_Segment2_B;
    o_Segment2_C <= w_Segment2_C;
    o_Segment2_D <= w_Segment2_D;
    o_Segment2_E <= w_Segment2_E;
    o_Segment2_F <= w_Segment2_F;
    o_Segment2_G <= w_Segment2_G;
    o_LED_1 <= not w_LED_1;
    o_LED_2 <= not w_LED_2;
    o_LED_3 <= not w_LED_3;
    o_LED_4 <= not w_LED_4;
end rtl;