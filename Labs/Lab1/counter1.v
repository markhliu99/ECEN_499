`timescale 1ns / 1ps

module counter1(
    output [3:0] LEDS,
    input [0:1] BUTTON,
    input RESET,
    input CLOCK
    );
    //stuff
    wire new_clock;
    reg [3:0] count;
    
    clockDivider newclock(new_clock,CLOCK,RESET);
    //loop thingy
    always@(posedge new_clock) begin
        if(RESET) begin
            count <= 0;
        end
        else begin
            if(BUTTON[0])
                count <= count + 1;
            if(BUTTON[1])
                count <= count - 1;
        end
    end
    //This makes the count --> LED values
    assign LEDS[3:0] = count[3:0];
endmodule
