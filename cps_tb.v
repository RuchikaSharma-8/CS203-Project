`timescale 1ns / 1ps
module car_parking_system_tb();

      // Inputs
      reg rClk;
      reg rRst;
      reg rsensorEntrance;
      reg rsensorExit;
      reg [3:0] rpasswordEntered;
      wire wgreenLed, wredLed;
      wire [6:0] wdisplay;
      wire [3:0] wanodeActivate;
    wire [3:0] wpass, wpass2;
    wire wsenEnt, wsenEx;

     car_parking_system CPS_INST(.Clk(rClk), .Rst(rRst), .sensorEntrance(rsensorEntrance), .sensorExit(rsensorExit), .passwordEntered(rpasswordEntered), .greenLed(wgreenLed), .redLed(wredLed), .display(wdisplay), .anodeActivate(wanodeActivate), .pass(wpass), .pass2(wpass2), .senEnt(wsenEnt), .senEx(wsenEx));

     initial begin
     rClk = 0;
     forever #10 rClk = ~rClk;
     end
    initial begin
     // Initialize Inputs
     rRst = 0;
     rsensorEntrance = 0;
     rsensorExit = 0;
     rpasswordEntered = 0;
     // Wait 100 ns for global reset to finish
     #100;
          rRst = 1;
     #20;
     rsensorEntrance = 1;
     #1000;
     rsensorEntrance = 0;
     rpasswordEntered = 1;
     #2000;
     rsensorExit =1;
     end
endmodule

