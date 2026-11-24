# ======================= Set IO Standard 3V3  ======================= #
set_property IOSTANDARD LVCMOS33 [get_ports {f_crystal}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]

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

# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[5]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[4]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {ring_counter[0]}]


# ======================= Assign IO Pin  ======================= #
# Clock anring_counter Reset
set_property PACKAGE_PIN W5 [get_ports {f_crystal}]
set_property PACKAGE_PIN R2 [get_ports {rst_n}]

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

# DIP switches
# set_property PACKAGE_PIN W17 [get_ports {i[3]}]
# set_property PACKAGE_PIN W16 [get_ports {i[2]}]
# set_property PACKAGE_PIN V16 [get_ports {i[1]}]
# set_property PACKAGE_PIN V17 [get_ports {i[0]}]

# SSD_order
# set_property PACKAGE_PIN V14 [get_ports {ring_counter[7]}]
# set_property PACKAGE_PIN U14 [get_ports {ring_counter[6]}]
# set_property PACKAGE_PIN U15 [get_ports {ring_counter[5]}]
# set_property PACKAGE_PIN W18 [get_ports {ring_counter[4]}]
# set_property PACKAGE_PIN V19 [get_ports {ring_counter[3]}]
# set_property PACKAGE_PIN U19 [get_ports {ring_counter[2]}]
# set_property PACKAGE_PIN E19 [get_ports {ring_counter[1]}]
# set_property PACKAGE_PIN U16 [get_ports {ring_counter[0]}]





