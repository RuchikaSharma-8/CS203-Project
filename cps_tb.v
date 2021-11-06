// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module car_parking_system_tb();

  // Inputs
  reg rClk;
  reg rRst;
  reg rsensorEntrance;
  reg rsensorExit;
  reg [3:0] rpasswordEntered;
  wire wgreenLed, wredLed;
  wire [6:0] wdisplay1, wdisplay2, wdisplay3, wdisplay4; 

 car_parking_system CPS_INST(.Clk(rClk), .Rst(rRst), .sensorEntrance(rsensorEntrance), .sensorExit(rsensorExit), .passwordEntered(rpasswordEntered), .greenLed(wgreenLed), .redLed(wredLed), .display1(wdisplay1), .display2(wdisplay2), .display3(wdisplay3), .display4(wdisplay4));

 initial begin
 rClk = 0;
 forever #10 rClk = ~rClk;
 end
 	 
endmodule
