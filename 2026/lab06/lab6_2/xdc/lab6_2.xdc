# ======================= Set IO Standard 3V3  ======================= #
set_property IOSTANDARD LVCMOS33 [get_ports {f_crystal}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]

set_property IOSTANDARD LVCMOS33 [get_ports {input_buttom_L_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_buttom_R_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_buttom_U_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_buttom_B_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_buttom_C_raw}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSD[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSD_order[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD_order[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD_order[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSD_order[0]}]

# set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]

# Upper Right PMOD (Lower Row)
set_property IOSTANDARD LVCMOS33 [get_ports {audio_mclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {audio_lrck}]
set_property IOSTANDARD LVCMOS33 [get_ports {audio_sck}]
set_property IOSTANDARD LVCMOS33 [get_ports {audio_sdin}]


# ======================= Assign IO Pin  ======================= #
# Clock and Reset
set_property PACKAGE_PIN W5 [get_ports {f_crystal}]
set_property PACKAGE_PIN R2 [get_ports {rst_n}]

#Buttom
set_property PACKAGE_PIN W19 [get_ports {input_buttom_L_raw}]
set_property PACKAGE_PIN T17 [get_ports {input_buttom_R_raw}]
set_property PACKAGE_PIN T18 [get_ports {input_buttom_U_raw}]
set_property PACKAGE_PIN U17 [get_ports {input_buttom_B_raw}]
set_property PACKAGE_PIN U18 [get_ports {input_buttom_C_raw}]

# SSD Pattern
set_property PACKAGE_PIN V7 [get_ports {SSD[0]}]
set_property PACKAGE_PIN U7 [get_ports {SSD[1]}]
set_property PACKAGE_PIN V5 [get_ports {SSD[2]}]
set_property PACKAGE_PIN U5 [get_ports {SSD[3]}]
set_property PACKAGE_PIN V8 [get_ports {SSD[4]}]
set_property PACKAGE_PIN U8 [get_ports {SSD[5]}]
set_property PACKAGE_PIN W6 [get_ports {SSD[6]}]
set_property PACKAGE_PIN W7 [get_ports {SSD[7]}]

# SSD Order
set_property PACKAGE_PIN W4 [get_ports {SSD_order[3]}]
set_property PACKAGE_PIN V4 [get_ports {SSD_order[2]}]
set_property PACKAGE_PIN U4 [get_ports {SSD_order[1]}]
set_property PACKAGE_PIN U2 [get_ports {SSD_order[0]}]

# # DIP switches
# set_property PACKAGE_PIN W17 [get_ports {i[3]}]
# set_property PACKAGE_PIN W16 [get_ports {i[2]}]
# set_property PACKAGE_PIN V16 [get_ports {i[1]}]
# set_property PACKAGE_PIN V17 [get_ports {en}]

# # LED
# set_property PACKAGE_PIN U16 [get_ports LED[0]]
# set_property PACKAGE_PIN E19 [get_ports LED[1]]
# set_property PACKAGE_PIN U19 [get_ports LED[2]]
# set_property PACKAGE_PIN V19 [get_ports LED[3]]

# set_property PACKAGE_PIN W18 [get_ports LED[4]]
# set_property PACKAGE_PIN U15 [get_ports LED[5]]
# set_property PACKAGE_PIN U14 [get_ports LED[6]]
# set_property PACKAGE_PIN V14 [get_ports LED[7]]

# set_property PACKAGE_PIN V13 [get_ports LED[8]]
# set_property PACKAGE_PIN V3  [get_ports LED[9]]
# set_property PACKAGE_PIN W3  [get_ports LED[10]]
# set_property PACKAGE_PIN U3  [get_ports LED[11]]

# set_property PACKAGE_PIN L1  [get_ports LED[12]]
# set_property PACKAGE_PIN P3  [get_ports LED[13]]
# set_property PACKAGE_PIN N3  [get_ports LED[14]]
# set_property PACKAGE_PIN P1  [get_ports LED[15]]

# Upper Right PMOD (Lower Row)
set_property PACKAGE_PIN A15 [get_ports {audio_mclk}]
set_property PACKAGE_PIN A17 [get_ports {audio_lrck}]
set_property PACKAGE_PIN C15 [get_ports {audio_sck}]
set_property PACKAGE_PIN C16 [get_ports {audio_sdin}]





