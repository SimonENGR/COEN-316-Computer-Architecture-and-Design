add wave clk
add wave reset 
add wave out_a_dp
add wave out_b_dp
add wave pc_out_dp
add wave overflow_dp
add wave zero_dp
force reset 0
force clk 0
run 5 
force clk 1
run 5
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
