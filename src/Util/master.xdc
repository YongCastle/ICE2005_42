#System
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33}  [get_ports {host_CLK}]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33}  [get_ports {rst_n}]

#------------------------------------MODE Switch ------------------
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS15}  [get_ports {MODE1_START_I}]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS15}  [get_ports {MODE2_START_I}] 
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {START_I}] 

#------------------------------------LED ------------------
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}  [get_ports {LED1_ON_o}]    
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports {LED2_ON_o}]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {LED_IDLE_O}]

#------------------------------------PIXEL ------------------
#------------------------------------Segment ------------------
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[0]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[1]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[2]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[3]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[4]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[5]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {seg_data_o[6]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {digit_o[2]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {digit_o[1]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {digit_o[0]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {digit_o[3]}]


#-------------------------------------BUZZER ------------------
set_property -dict {PACKAGE_PIN  K3  IOSTANDARD LVCMOS15} [get_ports {BUZZER_MODE_I}]
set_property -dict {PACKAGE_PIN  P20 IOSTANDARD LVCMOS33} [get_ports {buzzer_out_o}]

#---------------------------------------- VGA ------------------

set_property -dict {PACKAGE_PIN D17  IOSTANDARD LVCMOS33} [get_ports {vga_hs_o}]
set_property -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS33} [get_ports {vga_vs_o}]

set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {vga_r_o[3]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {vga_r_o[2]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {vga_r_o[1]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {vga_r_o[0]}]

set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {vga_g_o[3]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {vga_g_o[2]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {vga_g_o[1]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {vga_g_o[0]}]

set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {vga_b_o[3]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {vga_b_o[2]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {vga_b_o[1]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {vga_b_o[0]}]
