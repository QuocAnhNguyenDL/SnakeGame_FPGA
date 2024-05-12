module vga_controller (
	input 				clk, rst_n,
	input 	[9:0] 	r_in,
	input 	[9:0] 	g_in,
	input 	[9:0] 	b_in,
	output 			vga_hs, vga_vs, video_on,
	output 	[9:0] 	r_out,
	output 	[9:0] 	g_out,
	output 	[9:0] 	b_out,
	
	output reg [9 : 0] h_count,
	output reg [9 : 0] v_count
);	

/*
vga_controller vga
(
	.clk, rst_n			(),
	.r_in					(),
	.g_in					(),
	.b_in					(),
	.vga_hs				(), 
	.vga_vs				(), 
	.video_on			(),
	.r_out				(),
	.g_out				(),
	.b_out				(),
	
	.h_count				(),
	.v_count				()
);	
*/
	
	parameter H_SYNC = 96;		parameter V_SYNC = 2;
   parameter H_BACK = 48;		parameter V_BACK = 33;
	parameter H_ACTIVE = 640;	parameter V_ACTIVE = 480;
	parameter H_FRONT = 16;		parameter V_FRONT = 10;
	parameter H_TOTAL = 800;	parameter V_TOTAL = 525;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			h_count <= 10'b0;
			v_count <= 10'b0;
		end
		else begin
			if (h_count == H_TOTAL - 1) begin
				h_count <= 10'b0;
				v_count <= (v_count == V_TOTAL - 1) ? 10'b0 : v_count + 1'b1;
			end
			else begin
				h_count <= h_count + 1'b1;
			end
		end
	end
	
	assign vga_hs = ~(h_count < H_SYNC);
	assign vga_vs = ~(v_count < V_SYNC);
	assign video_on = (h_count >= (H_SYNC + H_BACK) && h_count < (H_SYNC + H_BACK + H_ACTIVE)) &&
							(v_count >= (V_SYNC + V_BACK) && v_count < (V_SYNC + V_BACK + V_ACTIVE));
	assign r_out = r_in;
	assign g_out = g_in;
	assign b_out = b_in;

endmodule
