`timescale 1ns / 1ps

module clockDivider(
    output reg OUT_CLK,
    input CLOCK,
    input RESET
    );
    //Will go up to a 32 bit number, so x is the parameter that will count up
    parameter x = 31; 
    reg[x:0] counter;
    //The Hz is 1/5. 
    always@(posedge CLOCK) begin
        if(counter == 25000000) begin
            OUT_CLK <= 1;
            counter <= 0;
        end
        else begin
            OUT_CLK <= 0;
            counter <= counter + 1;
        end
        end
    
endmodule
