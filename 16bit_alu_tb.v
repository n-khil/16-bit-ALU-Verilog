`timescale 1ns/1ps

module alu_tb;
	//Inputs for DUT
	reg [15:0] A, B;
	reg [3:0] Sel;

	//Outputs from DUT
	wire [15:0] Y;
	wire cout;
	wire zero;

	//Instantiate the ALU module
	alu dut (
		.A(A), .B(B), .Sel(Sel), .Y(Y), .cout(cout), .zero(zero)
	);

	//Test sequence
	initial begin
		$monitor("Time=%0t ns\t Sel=%b A=%h B=%h\t => Y=%h, cout=%b, zero=%b", $time, Sel, A, B, Y, cout, zero);
		//Test cases
		A = 16'h0005; B = 16'h0003; Sel = 4'b0000; #10;		//Add: 5+3=8
		A = 16'h000A; B = 16'h0004; Sel = 4'b0001; #10; 	//Sub: 10-4=6
		A = 16'hFFFF; B = 16'hxxxx; Sel = 4'b0010; #10; 	//Inc: FFFF+1=0, cout=1
		A = 16'h0000; B = 16'hxxxx; Sel = 4'b0011; #10; 	//Dec: 0-1=FFFF, cout=1
		A = 16'hF0F0; B = 16'hAAAA; Sel = 4'b0100; #10; 	//AND: A0A0
		A = 16'hF0F0; B = 16'hAAAA; Sel = 4'b0101; #10; 	//OR: FAFA
		A = 16'hF0F0; B = 16'hAAAA; Sel = 4'b0110; #10; 	//XOR: 5A5A
		A = 16'hAAAA; B = 16'hxxxx; Sel = 4'b0111; #10; 	//NOT: 5555
		A = 16'h8001; B = 16'hxxxx; Sel = 4'b1000; #10; 	//Shift Left: 0002
		A = 16'h8001; B = 16'hxxxx; Sel = 4'b1001; #10; 	//Logical Shift Right: 4000
		A = 16'hC001; B = 16'hxxxx; Sel = 4'b1010; #10; 	//Arithmetic Shift Right: E000 (sign preserved)
		A = 16'h8001; B = 16'hxxxx; Sel = 4'b1011; #10; 	//Rotate Left: 0003
		A = 16'h8001; B = 16'hxxxx; Sel = 4'b1100; #10; 	//Rotate Right: C000
		A = 16'h1234; B = 16'h5678; Sel = 4'b1101; #10; 	//Less Than: Y=1
		A = 16'hABCD; B = 16'hABCD; Sel = 4'b1110; #10; 	//Equal: Y=1
		A = 16'h1234; B = 16'h5678; Sel = 4'b1111; #10; 	//Clear Y: Y=0, zero=1
	
		$finish;
	end
endmodule
