add wave rs
add wave rt
add wave pc
add wave target_address
add wave branch_type
add wave pc_sel

add wave pc_plus_one 
add wave pc_plus_one_plus_branch_offset 

add wave rs_eq_rt 
add wave rs_ne_rt 
add wave rs_ltz 

add wave pc_beq 
add wave pc_bne 
add wave pc_blz 

add wave address_cond 
add wave target_address_fullbits 
add wave target_address_branch_offset 

add wave next_pc

force rs 00
force rt 01
force pc 000
force target_address 011
force branch_type 00
force pc_sel 00
run 5

force rs 00
force rt 00
force pc 000
force target_address 011
force branch_type 01
force pc_sel 00
run 5

force rs 00
force rt 01
force pc 000
force target_address 011
force branch_type 01
force pc_sel 00
run 5

force rs 00
force rt 01
force pc 000
force target_address 011
force branch_type 10
force pc_sel 00
run 5

force rs 00
force rt 01
force pc 000
force target_address 011
force branch_type 10
force pc_sel 00
run 5

force rs 00
force rt 01
force pc 000
force target_address 011
force branch_type 11
force pc_sel 00
run 5

force rs 10
force rt 01
force pc 000
force target_address 011
force branch_type 11
force pc_sel 00
run 5

force rs 10
force rt 01
force pc 000
force target_address 011
force branch_type 00
force pc_sel 01
run 5

force rs 10
force rt 01
force pc 000
force target_address 011
force branch_type 00
force pc_sel 10
run 5