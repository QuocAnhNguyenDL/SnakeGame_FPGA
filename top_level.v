module top_level
(
	input CLOCK_50,
	
	output[17:0] LEDR,
	input [17:0] SW,
	input [3:0] KEY,
	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK,
	output [9:0] VGA_R,
	output [9:0] VGA_G,
	output [9:0] VGA_B
);

assign LEDR[3:0] = KEY;

game g
(
	.CLOCK_50(CLOCK_50),
	.rst_n(SW[0]),
	
	.sw_up(~KEY[3]),
	.sw_down(~KEY[2]),
	.sw_left(~KEY[1]),
	.sw_right(~KEY[0]),
	
	.r_out(VGA_R),
	.g_out(VGA_G),
	.b_out(VGA_B),
	.vga_hs(VGA_HS),
	.vga_vs(VGA_VS),
	.vga_blank(VGA_BLANK),
	.vga_clk(VGA_CLK),
	
	.clk_refresh(test)
);

endmodule

