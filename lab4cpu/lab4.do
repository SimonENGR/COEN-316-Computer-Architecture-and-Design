
add wave clk
add wave reset 
add wave out_a_dp
add wave out_b_dp
add wave pc_out_dp
add wave overflow_dp
add wave zero_dp


add wave pc

   
add wave  instr_address 
add wave  instruction  
    

add wave  extended_instruction 
    
add wave reg_din          
add wave out_a
add wave out_b 
add wave rsregaddr
add wave rtregaddr
add wave write_reg 
    
add wave alu_x
add wave alu_y
add wave alu_output 
add wave logic_func
add wave alu_zero
add wave alu_overflow 
    

add wave  data_address   
add wave  data_to_write  
add wave  read_data_from_mem 
    

add wave  opcode 
add wave  instrc_func 
    

add wave  reg_write 
add wave  reg_dst 
add wave  memory_to_register 
                                                                          
add wave  alusrc 
add wave  add_sub 
add wave  datacache_write 
    

add wave  logic_func 
add wave  extfunc 
add wave  branch_type 
add wave  pc_sel 
    

add wave  next_pc 
add wave target_address 


force reset 1
force clk 0
run 5 
force clk 1
run 5
force reset 0
force clk 0
run 5 
force clk 1
run 5
force reset 0
force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5
force reset 0
force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5

force clk 0
run 5 
force clk 1
run 5
