//edit
module StoP(
input clk,in,
output [7:0] out,
output reg finish
);

reg [7:0] temp;
reg [3:0] i; 

initial begin
    temp=0;
    i=0;
    //out = 0;
    finish=0;
end

always@(negedge clk)//(posedge clk)
begin
   if(i<4'b1000)
    temp <= {in,temp[7:1]}; //out >> 1;   //
    i<=i+1;
end
assign out=temp;

/*always@(negedge clk)
begin
    if(enable && i<4'b1001)
       out <= {in,temp[6:0]};
    else if (i==4'b1001)
        finish <= 1;
end*/
/* add wave -position insertpoint sim:/StoP/*
force -freeze sim:/StoP/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/StoP/in 0 0
run
force -freeze sim:/StoP/in 1 0
run*/




endmodule
