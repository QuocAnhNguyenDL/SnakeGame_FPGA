module generate_clk
(
	input CLOCK_50,
	output vga_clk,
	output reg refresh
);

/*
generate_clk gen
(
	.CLOCK_50			(),
	.vga_clk				(),
	.refresh				()
);
*/

reg[23:0] counter = 0;

my_pll pll
(
	.inclk0(CLOCK_50),
	.c0(vga_clk)
);

always @(posedge CLOCK_50)
begin
	counter <= counter + 1;
	if(counter == 15000000)
	begin
		refresh <= ~refresh;
		counter <= 0;
	end
end 

endmodule