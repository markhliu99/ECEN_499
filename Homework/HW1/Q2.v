//Design 1 (Part A)
module LFSR(input clk, output reg [3:0] a);
  initial begin
    a=4'b1111;
  end
  
  always @(posedge clk) begin
    a[0]<=a[3];
    a[1]<=a[0]^a[3];
    a[2]<=a[1];
    a[3]<=a[2]^a[3];
  end
endmodule

//Design 2 (Part B)
module LFSR(input clk, output reg [3:0] a);
  initial begin
    a=4'b0000;
  end
  
  always @(posedge clk) begin
    a[0]<=a[3];
    a[1]<=a[0]^a[3];
    a[2]<=a[1];
    a[3]<=a[2]^a[3];
  end
endmodule

//TestBench
module LFSR_tb();
  reg [3:0] a, clk;
  int i;
  
  LFSR UUT (clk, a);
  
  initial begin
    clk=0;
    for(i=0;i<36;i=i+1) begin
      if(~clk) $display("%b",a);
      clk=~clk;
      #1;
    end
  end
endmodule
