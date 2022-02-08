--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
--Date        : Tue Feb  8 14:24:14 2022
--Host        : CHACKO-LAPTOP01 running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    cat : out STD_LOGIC;
    clk : in STD_LOGIC;
    led : out STD_LOGIC_VECTOR ( 7 downto 0 );
    player1 : in STD_LOGIC;
    player2 : in STD_LOGIC;
    reset : in STD_LOGIC;
    seg : out STD_LOGIC_VECTOR ( 6 downto 0 );
    sw : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=3,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_leds_0_0 is
  port (
    led_array : in STD_LOGIC_VECTOR ( 2 downto 0 );
    led : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1_leds_0_0;
  component design_1_ssd_0_0 is
  port (
    clk : in STD_LOGIC;
    digit1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    digit2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cat : out STD_LOGIC;
    seg : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );
  end component design_1_ssd_0_0;
  component design_1_pong_controller_0_0 is
  port (
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    player1 : in STD_LOGIC;
    player2 : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR ( 3 downto 0 );
    state : out STD_LOGIC_VECTOR ( 3 downto 0 );
    p1Score : out STD_LOGIC_VECTOR ( 31 downto 0 );
    p2Score : out STD_LOGIC_VECTOR ( 31 downto 0 );
    led : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component design_1_pong_controller_0_0;
  signal Net : STD_LOGIC;
  signal leds_0_led : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal player1_1 : STD_LOGIC;
  signal player2_1 : STD_LOGIC;
  signal pong_controller_0_led : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal pong_controller_0_p1Score : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal pong_controller_0_p2Score : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal reset_1 : STD_LOGIC;
  signal ssd_0_cat : STD_LOGIC;
  signal ssd_0_seg : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal sw_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_pong_controller_0_state_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET reset, CLK_DOMAIN design_1_clk, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of reset : signal is "xilinx.com:signal:reset:1.0 RST.RESET RST";
  attribute X_INTERFACE_PARAMETER of reset : signal is "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH";
begin
  Net <= clk;
  cat <= ssd_0_cat;
  led(7 downto 0) <= leds_0_led(7 downto 0);
  player1_1 <= player1;
  player2_1 <= player2;
  reset_1 <= reset;
  seg(6 downto 0) <= ssd_0_seg(6 downto 0);
  sw_1(3 downto 0) <= sw(3 downto 0);
leds_0: component design_1_leds_0_0
     port map (
      led(7 downto 0) => leds_0_led(7 downto 0),
      led_array(2 downto 0) => pong_controller_0_led(2 downto 0)
    );
pong_controller_0: component design_1_pong_controller_0_0
     port map (
      clk => Net,
      led(2 downto 0) => pong_controller_0_led(2 downto 0),
      p1Score(31 downto 0) => pong_controller_0_p1Score(31 downto 0),
      p2Score(31 downto 0) => pong_controller_0_p2Score(31 downto 0),
      player1 => player1_1,
      player2 => player2_1,
      reset => reset_1,
      state(3 downto 0) => NLW_pong_controller_0_state_UNCONNECTED(3 downto 0),
      sw(3 downto 0) => sw_1(3 downto 0)
    );
ssd_0: component design_1_ssd_0_0
     port map (
      cat => ssd_0_cat,
      clk => Net,
      digit1(31 downto 0) => pong_controller_0_p1Score(31 downto 0),
      digit2(31 downto 0) => pong_controller_0_p2Score(31 downto 0),
      seg(6 downto 0) => ssd_0_seg(6 downto 0)
    );
end STRUCTURE;
