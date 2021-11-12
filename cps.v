// `timescale 1ns / 1ps

// module car_parking_system (Clk, Rst,  sensorEntrance, sensorExit, passwordEntered, greenLed, redLed, display, anodeActivate);

//     input Clk, Rst; //clock and reset of the car parking system
//     input sensorEntrance, sensorExit; //two sensor in front and behind the gate of the car parking system
//     input [3:0] passwordEntered; //input password
//     output wire greenLed, redLed; //signaling LEDs
//     output reg [6:0] display; //Cathode patterns of the 7-segment LED display
//     output reg [3:0] anodeActivate; //Anode signals of the 7-segment LED display

//     wire [3:0] pass;
//     wire senEnt;
//     wire senEx;
//     assign senEnt = sensorEntrance;
//     assign senEx = sensorExit;
//     assign pass = passwordEntered;

//     parameter idle = 3'b000, waitPass = 3'b001, rightPass = 3'b010, wrongPass = 3'b011, stop = 3'b100;
//      reg [2:0] currentState, nextState;
//      reg [31:0] counterWait;
//      reg red, green;
//      reg [3:0] correctPass = 4'b1011;

// endmodule

`timescale 1ns / 1ps

module car_parking_system (Clk, Rst,  sensorEntrance, sensorExit, passwordEntered, greenLed, redLed, display, anodeActivate);

    input Clk, Rst; //clock and reset of the car parking system
    input sensorEntrance, sensorExit; //two sensor in front and behind the gate of the car parking system
    input [3:0] passwordEntered; //input password
    output reg greenLed, redLed; //signaling LEDs
    output reg [6:0] display; //Cathode patterns of the 7-segment LED display
    output reg [3:0] anodeActivate; //Anode signals of the 7-segment LED display

    wire [3:0] pass;
    wire senEnt;
    wire senEx;
    assign senEnt = sensorEntrance;
    assign senEx = sensorExit;
    assign pass = passwordEntered;
    
    parameter idle = 3'b000, waitPass = 3'b001, rightPass = 3'b010, wrongPass = 3'b011, stop = 3'b100;
    reg [2:0] currentState, nextState;
    reg [31:0] counterWait;
    reg red, green;
    reg [3:0] correctPass = 4'b1011;

    // nextState
    always @(posedge Clk or negedge Rst)
    begin
    if(~Rst)
    currentState = idle;
    else
    currentState = nextState;
    end

    // counterWait
    always @(posedge Clk or negedge Rst)
    begin
    if(~Rst)
    counterWait <= 0;
    else if(currentState==waitPass)
    counterWait <= counterWait + 1;
    else
    counterWait <= 0;
    end

    // change state
    always @(*)
    begin
    case(currentState)
    idle: begin
    if(sensorEntrance == 1)
    nextState = waitPass;
    else
    nextState = idle;
    end
    waitPass: begin
    if(counterWait <= 3)
    nextState = waitPass;
    else
    begin
    if(passwordEntered == correctPass)
    nextState =rightPass;
    else
    nextState =wrongPass;
    end
    end
    wrongPass: begin
    if(passwordEntered == correctPass)
    nextState = rightPass;
    else
    nextState = wrongPass;
    end
    rightPass: begin
    if(sensorEntrance==1 && sensorExit == 1)
    nextState = stop;
    else if(sensorExit == 1)
    nextState = idle;
    else
    nextState = rightPass;
    end
    stop: begin
    if(passwordEntered == correctPass)
    nextState = rightPass;
    else
    nextState = stop;
    end
    default: nextState = idle;
    endcase
    end

    // LEDs and output
    always @(posedge Clk) begin 
    case(currentState)
    idle: begin
    green = 1'b0;
    red = 1'b0;
    anodeActivate = 4'b0111;
    display = 7'b1111001;  // I
    anodeActivate = 4'b1011;
    display = 7'b1000010;  // D
    anodeActivate = 4'b1101;
    display = 7'b1110001;  // L
    anodeActivate = 4'b1110;
    display = 7'b0110000;   // E
    end
    waitPass: begin
    green = 1'b0;
    red = 1'b1;
    anodeActivate = 4'b0111;
    display = 7'b1001000; // H
    anodeActivate = 4'b1011;
    display =  7'b0000001; // O
    anodeActivate = 4'b1101;
    display = 7'b1110001; // L
    anodeActivate = 4'b1110;
    display = 7'b1000010; // D
    end
    wrongPass: begin
    green = 1'b0;
    red = ~red;
    anodeActivate = 4'b0111;
    display = 7'b0110000; // E
    anodeActivate = 4'b1011;
    display = 7'b1111010; // R
    anodeActivate = 4'b1101;
    display = 7'b1111010; // R
    anodeActivate = 4'b1110;
    display = 7'b1110111; // _
    end
    rightPass: begin
    green = ~green;
    red = 1'b0;
    anodeActivate = 4'b0111;
    display = 7'b0011000; // P
    anodeActivate = 4'b1011;
    display = 7'b0001000; // A
    anodeActivate = 4'b1101;
    display = 7'b0100100; // S
    anodeActivate = 4'b1110;
    display = 7'b0100100; // S
    end
    stop: begin
    green = 1'b0;
    red = ~red;
    anodeActivate = 4'b0111;
    display = 7'b0100100 ; // S
    anodeActivate = 4'b1011;
    display = 7'b1110000; // t
    anodeActivate = 4'b1101;
    display = 7'b0000001; // O
    anodeActivate = 4'b1110;
    display = 7'b0011000; // P
    end
    endcase
    redLed = red;
    greenLed = green;
    end

endmodule

