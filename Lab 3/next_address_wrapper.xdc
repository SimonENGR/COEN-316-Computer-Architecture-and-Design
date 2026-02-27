set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [ get_ports { rs[0] } ];
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [ get_ports { rs[1] } ];
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [ get_ports { rt[0] } ];
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [ get_ports { rt[1] } ];

set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [ get_ports { pc[0] } ];
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [ get_ports { pc[1] } ];
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [ get_ports { pc[2] } ];

set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [ get_ports { target_address[0] } ];
set_property -dict { PACKAGE_PIN T8 IOSTANDARD LVCMOS33  } [ get_ports { target_address[1] } ];
set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS33  } [ get_ports { target_address[2] } ];

set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [ get_ports { branch_type[0] } ];
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [ get_ports { branch_type[1] } ];
set_property -dict { PACKAGE_PIN H6 IOSTANDARD LVCMOS33  } [ get_ports { pc_sel[0] } ];
set_property -dict { PACKAGE_PIN H6 IOSTANDARD LVCMOS33  } [ get_ports { pc_sel[1] } ];

set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [ get_ports { next_pc[0] } ];
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [ get_ports { next_pc[1] } ];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [ get_ports { next_pc[2] } ];
