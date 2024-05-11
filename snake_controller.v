module snake_controller
(
	//-------------CLOCK----------------
	input	 				refresh,
	input 				clk_vga,
	input 				reset,
	
	//-------------VGA signals----------
	input 	[9:0] 	Xpos,
	input 	[9:0] 	Ypos,
	output 	[9:0] 	R,
	output 	[9:0] 	G,
	output 	[9:0] 	B,
	
	//------------SNES signals----------
	input 				up_in,
	input 				down_in,
	input 				left_in,
	input 				right_in
);

localparam UP = 2'b00;
localparam DOWN = 2'b01;
localparam LEFT = 2'b10;
localparam RIGHT = 2'b11;

localparam width = 30;
localparam height = 22;

reg[5:0] snake[0 : width - 1][0 : height - 1];

reg [1:0] direction = RIGHT;
reg [9:0] length = 10'b1;

reg[4:0] headX = 10'b10;
reg[4:0] headY = 10'b10; 

reg [4:0] i,j;

//------Update direction-------//
always @(posedge refresh)
begin
	if(reset == 1'b1)	direction <= RIGHT; 
	else
	begin
		if(up_in == 1'b1) direction <= UP;
		else if(down_in == 1'b1) direction <= DOWN;
		else if(right_in == 1'b1) direction <= RIGHT;
		else if(left_in == 1'b1) direction <= LEFT;
		else direction <= direction;
	end
end

//---------Move snake--------//
always @(posedge refresh)
begin

	case(direction)
		UP 	: begin snake[headY - 1][headX] <= length; headY = headY - 1; end
		DOWN 	: begin snake[headY + 1][headX] <= length; headY = headY + 1; end
		LEFT 	: begin snake[headY][headX - 1] <= length; headX = headX - 1; end
		RIGHT : begin snake[headY][headX - 1] <= length; headX = headX + 1; end
		default : begin end
	endcase
	
	for(i = 0 ; i < width ; i = i + 1)
	begin
		for(j = 0 ; j < height ; j = j + 1)
		begin
			if(snake[i][j] > 0) snake[i][j] <= snake[i][j] - 1;
		end
	end
	
end

endmodule







