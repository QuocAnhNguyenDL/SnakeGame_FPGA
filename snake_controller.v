module snake_controller
(
	//-------------CLOCK----------------//
	input	 				refresh,
	input 				vga_clk,
	input 				rst_n,
	input 				restart,
	
	//-------------VGA signals----------//
	input 	[9:0] 	Xpos,
	input 	[9:0] 	Ypos,
	output 			 	R,
	output 			 	G,
	output 				B,
	
	//------------Player signals----------//
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
	.left_in				(),
	.right_in			()
);
*/

parameter UP = 2'b00;
parameter DOWN = 2'b01;
parameter LEFT = 2'b10;
parameter RIGHT = 2'b11;

parameter width = 30;
parameter height = 22;

parameter snake_color = 3'b100;
parameter food_color  = 3'b010;
parameter blank_color = 3'b111;
parameter border_color = 3'b001;

//`include "game_para.txt"

reg[5:0] snake[0 : height - 1][0 : width - 1];
reg[3:0] pixel;

reg [1:0] direction;
reg [9:0] length = 10'b1;

reg[4:0] headX = 5'b10;
reg[4:0] headY = 5'b10; 

reg[9:0] food_coordinates = 0;
reg[4:0] foodX = 5, foodY = 5;

reg [4:0] i,j;
reg lose = 1'b0;


assign R = pixel[2];
assign G = pixel[1];
assign B = pixel[0];

//------reset game-------------//

//------Update direction-------//
always @(*)
begin
	if(up_in == 1'b1 && direction != DOWN) direction <= UP;
	else if(down_in == 1'b1 && direction != UP) direction <= DOWN;
	else if(right_in == 1'b1 && direction != LEFT) direction <= RIGHT;
	else if(left_in == 1'b1 && direction != RIGHT) direction <= LEFT;
end


//------Lose game------------//
always @(posedge refresh)
begin
	if( headX > 29 || headX < 0 || headY > 21 || headY < 0) lose <= 1;
	
	if(direction == UP && snake[headY - 1][headX] > 0) lose <= 1;
	if(direction == DOWN && snake[headY + 1][headX] > 0) lose <= 1;
	if(direction == LEFT && snake[headY][headX-1] > 0) lose <= 1;
	if(direction == UP && snake[headY][headX+1] > 0) lose <= 1;
end


//---------Move snake--------//
always @(posedge refresh)
begin
	//direction <= temp_direction;
	case(direction)
		UP 	: begin snake[headY - 1][headX] <= length; headY = headY - 1; end
		DOWN 	: begin snake[headY + 1][headX] <= length; headY = headY + 1; end
		LEFT 	: begin snake[headY][headX - 1] <= length; headX = headX - 1; end
		RIGHT : begin snake[headY][headX + 1] <= length; headX = headX + 1; end
		default : begin end
	endcase
	
	for(i = 0 ; i < height ; i = i + 1)
	begin
		for(j = 0 ; j < width ; j = j + 1)
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


//----------Draw Snake and Food-----------//
always @(posedge vga_clk)
begin

	if(lose == 1'b1)
	begin
		pixel = border_color;
	end
	else
		begin
		if(Xpos >= 144 + 20 && Xpos < 784 - 20 && Ypos >= 35 + 20 && Ypos < 515 - 20)
		begin
			if(snake[(Ypos - 55)/20][(Xpos - 164)/20] > 0) pixel <=  snake_color;
			else if((Xpos-164)/20 == foodX  &  (Ypos-55)/20 == foodY) pixel <= food_color;
			else pixel <= blank_color;
		end
		else pixel <= border_color;
	end
end

//--------Generate food-------//
always @(posedge vga_clk)
begin
	food_coordinates <= food_coordinates + 1;
	if(food_coordinates == 30*22 - 1) food_coordinates <= 0;
end


endmodule







