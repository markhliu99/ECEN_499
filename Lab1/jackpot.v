`timescale 1ns / 1ps

module jackpot(
    input [3:0] SWITCHES,
    input CLOCK,
    input RESET,
    output [3:0] LEDS
    );
    
    wire new_clock;
    reg [3:0] lights = 4'b1000;
    reg cheating = 0;
    //clock divider thing from the internet 
    clockDivider newclock(new_clock,CLOCK,RESET);
    always@(posedge new_clock) begin
        if(RESET) begin
            lights <= 4'b1000;
            cheating = 0;
        end
        else begin
		// finds the next state of the LEDS based on their current state 
            if (lights == 4'b1000 & ~SWITCHES[3]) begin
                if (SWITCHES[2]==1) begin
                    cheating = 1;
                end
                lights = 4'b0100;
            end
            else if (lights == 4'b0100 & ~SWITCHES[2]) begin
                if (SWITCHES[1]==1) begin
                    cheating = 1;
                end
                lights = 4'b0010;
            end
            else if (lights == 4'b0010 & ~SWITCHES[1]) begin
                if (SWITCHES[0]==1) begin
                    cheating = 1;
                end
                lights = 4'b0001;
            end
            else if (lights == 4'b0001 & ~SWITCHES[0]) begin
                if (SWITCHES[3]==1) begin
                    cheating = 1;
                end
                lights = 4'b1000;
                cheating = 0;
            end
            else begin 
			//The most bootleg cheat detection but hey it works.
			    if(cheating == 0) begin
                    lights = 4'b1111;
                end
                else if (cheating == 1) begin
                    lights = 4'b1010;
                end
            end 
        end
           
    end
    

	//continuous assignment for LEDS to lights
    assign LEDS[3:0] = lights[3:0];
endmodule
