module RAM 
#( parameter MEM_Depth = 256,
   parameter ADDR_SIZE = 8)

( input clk,
  input rst,
  input [9:0] din,
  input rx_valid,
  output reg [7:0] dout,
  output reg tx_valid   
  );

reg [ADDR_SIZE-1:0] MEM [0:MEM_Depth-1];
reg [7:0] temp_Address;

always @(posedge clk or posedge rst) 
begin
      if (!rst || !rx_valid) 
      begin
            tx_valid <= 0;
            dout <= 8'b00000000;
      end else 
      begin
           case (din[9:8])
            2'b00 : temp_Address = din[7:0];
            2'b01 : MEM[temp_Address] = din[7:0];
            2'b10 : temp_Address = din[7:0];
            2'b11 : 
            begin
                   dout = MEM[temp_Address];
                    tx_valid = 1;    
            end
            default: temp_Address = din[7:0];
           endcase 
      end
end  
endmodule