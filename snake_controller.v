module snake_controller
(
	//-------------CLOCK----------------
	input	 				refresh,
	input 				vga_clk,
	input 				rst_n,
	
	//-------------VGA signals----------
	input 	[9:0] 	Xpos,
	input 	[9:0] 	Ypos,
	output 			 	R,
	output 			 	G,
	output 				B,
	
	//------------Player signals----------
	input 				up_in,
	input 				down_in,
	input 				left_in,
	input 				right_in
);

/*
snake_controller snake
(
	.refresh				(),
	.vga_clk				(),
	.rst_n				(),
	
	.Xpos					(),
	.Ypos					(),
	.R						(),
	.G						(),
	.B						(),
	
	.up_in				(),
	.down_in				(),
	.eft_in				(),
	.right_in			()
);
*/

`include "game_para.txt"

reg[5:0] snake[0 : width - 1][0 : height - 1];
reg[3:0] pixel;

reg [1:0] direction = RIGHT;
reg [9:0] length = 10'b1;

reg[4:0] headX = 10'b10;
reg[4:0] headY = 10'b10; 

reg[9:0] food_coordinates = 0;
reg[4:0] foodX = 10, foodY = 10;

reg [4:0] i,j;


assign R = pixel[2];
assign G = pixel[1];
assign B = pixel[0];

//------Update direction-------//
always @(posedge refresh)
begin
	if(rst_n == 1'b0)	direction <= RIGHT; 
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

//----------Eat food-----------//
always @(posedge refresh)
begin
	if(headX == foodX & headY == foodY)
	begin
		length <= length + 1;
		foodX <= food_coordinates / 30;
		foodY <= food_coordinates % 20;
	end
end

//----------Draw Snake-----------//
/*always @(posedge vga_clk)
begin
	if(Xpos > 20 && Xpos < 619 && Ypos > 20 && Ypos < 459)
	begin
		if(snake[(Xpos - 20)/20][(Ypos-20)/20] > 0) pixel <=  snake_color;
		else if(Xpos == foodX  &  Ypos == foodY) pixel <= food_color;
		else pixel <= blank_color;
	end
end*/

//--------Generate food-------//
always @(posedge vga_clk)
begin
	food_coordinates <= food_coordinates + 1;
	if(food_coordinates == 30*22 - 1) food_coordinates <= 0;
end

endmodule







