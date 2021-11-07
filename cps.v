// `timescale 1ns / 1ps

// module car_parking_system (Clk, Rst,  sensorEntrance, sensorExit, passwordEntered, greenLed, redLed, display1, display2, display3, display4);

//   input Clk, Rst; //clock and reset of the car parking system
//   input sensorEntrance, sensorExit; //two sensor in front and behind the gate of the car parking system
//   input [3:0] passwordEntered; //input password
//   output wire greenLed, redLed; //signaling LEDs
//   output reg [6:0] display1, display2, display3, display4; //7-segment Display

//   parameter idle = 3'b000, waitPass = 3'b001, rightPass = 3'b010, wrongPass = 3'b011, stop = 3'b100;
//  reg [2:0] currentState, nextState;
//  reg [31:0] counterWait;
//  reg red, green;
//  reg [3:0] correctPass = 4'b1011;

// endmodule

`timescale 1ns / 1ps

module car_parking_system (Clk, Rst,  sensorEntrance, sensorExit, passwordEntered, greenLed, redLed, display, anodeActivate);

  input Clk, Rst; //clock and reset of the car parking system
  input sensorEntrance, sensorExit; //two sensor in front and behind the gate of the car parking system
  input [3:0] passwordEntered; //input password
  output wire greenLed, redLed; //signaling LEDs
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

endmodule

