## Clock signal
set_property PACKAGE_PIN W5 [get_ports reloj]							
	set_property IOSTANDARD LVCMOS33 [get_ports reloj]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports reloj]
 
## Switches
set_property PACKAGE_PIN V17 [get_ports {switch0}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {switch0}]
set_property PACKAGE_PIN V16 [get_ports {switch1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch1}]
 
## Leds
set_property PACKAGE_PIN U16 [get_ports {salida[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[0]}]
set_property PACKAGE_PIN E19 [get_ports {salida[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[1]}]
set_property PACKAGE_PIN U19 [get_ports {salida[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[2]}]
set_property PACKAGE_PIN V19 [get_ports {salida[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[3]}]
set_property PACKAGE_PIN W18 [get_ports {salida[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[4]}]
set_property PACKAGE_PIN U15 [get_ports {salida[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[5]}]
set_property PACKAGE_PIN U14 [get_ports {salida[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[6]}]
set_property PACKAGE_PIN V14 [get_ports {salida[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[7]}]
set_property PACKAGE_PIN V13 [get_ports {salida[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[8]}]
set_property PACKAGE_PIN V3 [get_ports {salida[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[9]}]
set_property PACKAGE_PIN W3 [get_ports {salida[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[10]}]
set_property PACKAGE_PIN U3 [get_ports {salida[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[11]}]
set_property PACKAGE_PIN P3 [get_ports {salida[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[12]}]
set_property PACKAGE_PIN N3 [get_ports {salida[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[13]}]
set_property PACKAGE_PIN P1 [get_ports {salida[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[14]}]
set_property PACKAGE_PIN L1 [get_ports {salida[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {salida[15]}]
	

## Buttons
set_property PACKAGE_PIN U18 [get_ports kpUp]						
	set_property IOSTANDARD LVCMOS33 [get_ports kpUp]
set_property PACKAGE_PIN T18 [get_ports kdUP]						
	set_property IOSTANDARD LVCMOS33 [get_ports kdUP]
set_property PACKAGE_PIN W19 [get_ports kiUP]						
	set_property IOSTANDARD LVCMOS33 [get_ports kiUP]
 


##Pmod Header JA
#Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {l298n_ena}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_ena}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {l298n_in1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in1}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {l298n_in2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in2}]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {l298n_in3}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in3}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {l298n_in4}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in4}]
#Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {l298n_enb}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_enb}]


##Pmod Header JXADC
#Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {sda}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {sda}]
#Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {scl}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {scl}]
