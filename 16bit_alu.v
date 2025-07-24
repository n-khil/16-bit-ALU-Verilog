module alu(
	input [15:0] A, B,	//16-bit inputs
	input [3:0] Sel,	//4-bit operation select
	output reg [15:0] Y,	//16-bit output
	output reg cout,	//1-bit Carry out flag
	output reg zero		//1-bit zero flag
	);

	reg [16:0] temp_Y;	//temparory 17-bit wire for Carry of arithmetic add/sub

	always @(*) begin	//executes on input change
	
		temp_Y = 17'b0;		//set to zero
		Y = 16'b0;		//set to zero

		case(Sel)
			4'b0000: temp_Y = A + B;	//Addition
			4'b0001: temp_Y = A - B;	//Subtraction
			4'b0010: temp_Y = A + 1;	//Increment A
			4'b0011: temp_Y = A - 1;	//Decrement A
			4'b0100: Y = A & B;		//Bitwise AND
			4'b0101: Y = A | B;		//Bitwise OR
			4'b0110: Y = A ^ B;		//Bitwise XOR
			4'b0111: Y = ~A;		//Bitwise NOT A
			4'b1000: Y = A << 1;		//Logical Shift Left
			4'b1001: Y = A >> 1;		//Logical Shift Right
			4'b1010: Y = $signed(A) >>> 1;	//Arithmetic Shift Right
			4'b1011: Y = {A[14:0], A[15]};	//Rotate Left
			4'b1100: Y = {A[0], A[15:1]}; 	//Rotate Right
			4'b1101: Y = (A < B) ? 16'd1 : 16'd0;	//Set if Less Than (Unsigned)
			4'b1110: Y = (A == B) ? 16'd1 : 16'd0;	//Set if equal
			4'b1111: Y = 16'h0000;		//Clear Y
			default: Y = 16'b0;		//Default case
		endcase

		if (Sel <= 4'b0011) begin	//Assign Carry-out and Y for arithmetic operations
			cout = temp_Y[16];
			Y = temp_Y[15:0];
		end else begin
			cout = 1'b0; 		//No Carry-out for non-arithmetic operations
		end

		if (Y == 16'b0) begin		//Zero flag
			zero = 1'b1;
		end else begin
			zero = 1'b0;
		end
	end
endmodule