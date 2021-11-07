`timescale 1ns / 1ps

module car_parking_system_tb();

    reg rClk;
    reg rRst;
    reg rsensorEntrance;
    reg rsensorExit;
    reg [3:0] rpasswordEntered;
    wire wgreenLed, wredLed;
    wire [6:0] wdisplay;
    wire [3:0] wanodeActivate;
 

    car_parking_system CPS_INST(.Clk(rClk), .Rst(rRst), .sensorEntrance(rsensorEntrance), .sensorExit(rsensorExit), .passwordEntered(rpasswordEntered), .greenLed(wgreenLed), .redLed(wredLed), .display(wdisplay), .anodeActivate(wanodeActivate));

    initial begin
    rClk = 0;
    forever #10 rClk = ~rClk;
    end
 	 
endmodule
