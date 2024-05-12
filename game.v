module game
(
	//---------CLOCK----------//
	input CLOCK_50,
	input rst_n,
	
	//---------Player input----//
	input sw_up,
	input sw_down,
	input sw_left,
	input sw_right,
	
	//---------VGA signals-----//
	output [9:0] r_out,
	output [9:0] g_out,
	output [9:0] b_out,
	output vga_hs,
	output vga_vs,
	output vga_blank,
	output vga_clk	
);

wire refresh;
wire [9:0] Xpos;
wire [9:0] Ypos;

wire [9:0] R;
wire [9:0] G;
wire [9:0] B;
 
generate_clk gen
(
	.CLOCK_50			(CLOCK_50),
	.vga_clk				(vga_clk),
	.refresh				(refresh)
);

snake_controller snake
(
	.refresh				(refresh),
	.vga_clk				(vga_clk),
	.rst_n				(rst_n),
	
	.Xpos					(Xpos),
	.Ypos					(Ypos),
	.R						(R),
	.G						(G),
	.B						(B),
	
	.up_in				(sw_in),
	.down_in				(sw_down),
	.left_in				(sw_left),
	.right_in			(sw_right)
);

vga_controller vga
(
	.clk					(clk_vga), 
	.rst_n				(rst_n),
	.r_in					(R),
	.g_in					(G),
	.b_in					(B),
	.vga_hs				(vga_hs), 
	.vga_vs				(vga_vs), 
	.video_on			(vga_blank),
	.r_out				(r_out),
	.g_out				(g_out),
	.b_out				(b_out),
	
	.h_count				(Xpos),
	.v_count				(Ypos)
);	

endmodule








