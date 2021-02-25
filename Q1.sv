// Code your testbench here
// or browse Examples

//is is removed for syntax + numbers cannot be in module names
//removed %$ before over_flow
//defined data_in and data_out as input/output for net
module eightbitregister (clk, reset, input reg[7:0] data_in, output reg[7:0] data_out, carry_in, carry_out, reg over_flow);
  //The following commented code is redundant/wrong
  input clk;
  input reset;
  //input carry_in;
  //input data_in;
  //output reg data_out;
  //output reg carry_out;
  //output over_flow;
  //reg[7:0] data_out;
  //reg[1:0] carry_out;
  //reg over_flow;
  
  initial begin
    data_out = 0;
    carry_out = 0;
  end
  
  // Syntax | must be changed into or for syntax reasons along with 
  always @(posedge clk or posedge reset) begin
	//Changed the syntax to fit if else statements 
    if (reset) begin
      data_out = 0;
  	  carry_out = 0;
    end
  	else begin
      data_out = (data_in*2)+carry_in;
  	  carry_out = &data_in[7|6];
  	end 
 end
   //Removed syntax errors 
   assign over_flow = data_out;
  
endmodule 
