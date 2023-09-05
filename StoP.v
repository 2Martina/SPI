module StoP
#(parameter width=10)
(
input clk,in,enable,
output [width-1 :0] out,
output reg finish
);

reg [width-1 :0] temp;
reg [3:0] i; 

initial begin
    temp=0;
    i=width-1;
    finish=0;
end

always@(posedge clk)
begin
   if(enable && i>0)//width)//4'b1000)
   // temp <= {temp[width-2 : 0],in}; //in,temp[7:1]//out >> 1;   //
    //i<=i+1;
    begin
    temp[i] <= in;
    i<=i-1;
    end
    else
    finish<=1;
end
assign out=temp;

/* add wave -position insertpoint sim:/StoP/*
force -freeze sim:/StoP/clk 0 0, 1 {50 ps} -r 10
force -freeze sim:/StoP/enable 1 0
force -freeze sim:/StoP/in 0 0
run
force -freeze sim:/StoP/in 1 0
run
run
run
run
force -freeze sim:/StoP/in 0 0
run*/




endmodule
