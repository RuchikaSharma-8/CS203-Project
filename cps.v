`timescale 1ns / 1ps
 
module car_parking_system (Clk, Rst,  sensorEntrance, sensorExit, passwordEntered,passwordEntered2, greenLed, redLed, display, anodeActivate,pass,pass2,senEnt,senEx);
 
    input Clk, Rst; // Clock and reset of the car parking system
    input sensorEntrance, sensorExit; // Two sensor in front and behind the gate of the car parking system
    input [3:0] passwordEntered,  passwordEntered2; // Input password
    output reg greenLed, redLed; // Signaling LEDs showing different states of system
    output reg [6:0] display; // Cathode patterns of the 7-segment LED display
    output reg [3:0] anodeActivate; // Anode signals of the 7-segment LED display
    output reg [3:0] pass; // LEDs for displaying password entered
    output reg [3:0] pass2; // LEDs for displaying the second password entered
    output reg senEnt;  // LED showing state of sensor at entrance
    output reg senEx;  // LED showing state of sensor at exit
   
    parameter idle = 3'b000, waitPass = 3'b001, rightPass = 3'b010, wrongPass = 3'b011, stop = 3'b100;  // States of car parking system, displayed on 4 digit 7 segment display    
    reg [2:0] currentState, nextState;   // Variables for storing current state and next state
    reg [31:0] counterWait; // A variable introduced to slow the clock
    reg red, green;  // Additional variables that are varying according to state of the system
    reg [3:0] correctPass = 4'b1011; // Correct password of parking system
    localparam left=2'b00, midleft=2'b01, midright=2'b10, right=2'b11; // Additional variables for the 4 digit 7-segment display
    reg [1:0] state=left; // Initialising the state variable
    reg led; // Additional variable used for red and green LEDs
    reg [12:0] segclk; // Additional variable used for using 7 segment display on fpga
 
 
    // segclk for 7 segment display
    always @(posedge Clk) begin
        segclk <= segclk+1'b1;
    end
 
    // counterWait for signalling LEDs
    always @(posedge Clk or negedge Rst) begin
        if(~Rst) begin
            counterWait <= 0;
            led <= ~led;
        end
        else if(counterWait <= 25000000)
            counterWait <= counterWait + 1;
        else begin
            counterWait <= 0;
            led <= ~led;
        end
    end
 
    // nextState
    always @(posedge Clk or negedge Rst) begin
        if(~Rst)
            currentState = idle;
        else
            currentState = nextState;
    end
   
    // change state
    always @(*) begin
        case(currentState)
 
        idle: begin
            if(sensorEntrance == 1)
                nextState = waitPass;
            else
                nextState = idle;
        end
 
        waitPass: begin
            if(passwordEntered == 4'b0000)
                nextState = waitPass;
            else begin
                if(passwordEntered == correctPass)
                    nextState = rightPass;
                else
                    nextState = wrongPass;
            end
        end
 
        wrongPass: begin
            if(passwordEntered == correctPass)
                nextState = rightPass;
            else
                nextState = wrongPass;
            end
 
        rightPass: begin
            if((sensorEntrance==1 && sensorExit == 1)&& passwordEntered2 != correctPass)
                nextState = stop;
            else if(sensorExit == 1 && passwordEntered2 != correctPass)
                nextState = idle;
            else
                nextState = rightPass;
        end
 
        stop: begin
            if(passwordEntered2 == correctPass)
                nextState = rightPass;
            else
                nextState = stop;
        end
 
        default: nextState = idle;
        endcase
 
    end
 
    // LEDs and output
    always @(posedge segclk[12]) begin
        case(currentState)
 
        idle: begin
            green = 1'b0;
            red = 1'b0;
            case(state)
            left: begin
                display <= 7'b1001111;  // I
                anodeActivate <= 4'b0111;
                state <= midleft;
            end
            midleft: begin
                display <= 7'b0100001;  // d
                anodeActivate <= 4'b1011;
                state <= midright;
            end
            midright: begin
                display <= 7'b1000111;  // L
                anodeActivate <= 4'b1101;
                state <= right;
            end
            right: begin
                display <= 7'b0000110;   // E
                anodeActivate <= 4'b1110;
                state <= left;
            end
            endcase
        end
 
        waitPass: begin
            green = 1'b0;
            red = 1'b1;
            case(state)
            left: begin
                display <= 7'b0001001; // H
                anodeActivate <= 4'b0111;
                state <= midleft;
            end
            midleft: begin
                display <=  7'b1000000; // O
                anodeActivate <= 4'b1011;
                state <= midright;    
            end
            midright: begin
                display <= 7'b1000111; // L
                anodeActivate <= 4'b1101;
                state <= right;
            end
            right: begin
                display <= 7'b0100001; // d
                anodeActivate <= 4'b1110;
                state <= left;
            end
            endcase
        end
 
        wrongPass: begin
            green <= 1'b0;
            red <= led;
            case(state)
            left: begin
                display <= 7'b0000110; // E
                anodeActivate <= 4'b0111;
                state <= midleft;
            end
            midleft: begin
                display <= 7'b0101111; // r
                anodeActivate <= 4'b1011;
                state <= midright;
            end
            midright: begin
                display <= 7'b0101111; // r
                anodeActivate <= 4'b1101;
                state <= right;
            end
            right: begin
                display <= 7'b1110111; // _
                anodeActivate <= 4'b1110;
                state <= left;
            end
            endcase
        end
 
        rightPass: begin
            green <= led;
            red <= 1'b0;
            case(state)
            left: begin
                display <= 7'b0001100; // P
                anodeActivate <= 4'b0111;
                state <= midleft;
            end
            midleft:begin
                display <= 7'b0001000; // A
                anodeActivate <= 4'b1011;
                state <= midright;
            end
            midright: begin
                display <= 7'b0010010; // S
                anodeActivate <= 4'b1101;
                state <= right;
            end
            right: begin
                display <= 7'b0010010; // S
                anodeActivate <= 4'b1110;
                state <= left;
            end
            endcase
        end
 
        stop: begin
            green <= 1'b0;
            red <= led;
            case(state)
            left: begin
                display <= 7'b0010010 ; // S
                anodeActivate <= 4'b0111;
                state <= midleft;
            end
            midleft: begin
                display <= 7'b0000111; // t
                anodeActivate <= 4'b1011;
                state <= midright;
            end
            midright: begin
                display <=  7'b1000000; // O
                anodeActivate <= 4'b1101;
                state <= right;
            end
            right: begin
            anodeActivate <= 4'b1110;
            display <= 7'b0001100; // P
            state <= left;
            end
            endcase
        end
        endcase
 
        redLed = red;
        greenLed = green;
        senEnt = sensorEntrance;
        senEx = sensorExit;
        pass = passwordEntered;
        pass2 = passwordEntered2;
    end
 
endmodule
