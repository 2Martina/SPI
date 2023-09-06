module ParallelToSerial (
  input wire clk,        
  input wire tx_valid,         
  input wire [7:0] parallel_data,  
  output reg serial_out  
);

  reg [2:0] counter;
  assign counter = 7;
  reg tx_validtemp;
  assign tx_validtemp = tx_valid;

  always @(posedge clk or posedge tx_valid) 
  begin
    if (!tx_valid) 
    begin  
          serial_out <= 1'b0;  
    end else 
    begin
         if (counter >= 0 && tx_validtemp) 
         begin
              serial_out <= parallel_data[counter];
              counter <= counter - 1;
              if (counter == 0) begin
                 tx_validtemp <= 0;
              end  
         end
    end
  end

endmodule