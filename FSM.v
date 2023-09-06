module FSM
#(parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100)
(
    input clk,rst,
    MOSI,SS_n,tx_valid,
    input [7:0] tx_data,

    output reg rx_valid,
    output wire MISO,
    output reg [9:0] rx_data
);
    
    reg [2:0] state,nextstate;
    reg Read,enable_ser_to_par;
    wire [9:0] StoP_out;

    reg [7:0] temp_txData; 
    wire [7:0] ttx_data; 

    initial begin
        enable_ser_to_par <= 0;
        Read <= 0; // Read Address
    end





//State memory always block
    always@(posedge clk or posedge rst)
    begin
    if (!rst)
    state<= s0;
    else begin
    state<= nextstate;
    end
    end



//000: IDLE
//001: CHK_CMD
//010: WRITE
//011: 
//100: 

//Next state logic always block
    always@(*)
    begin
        case(state)
            3'b000: if(SS_n)
                    nextstate = 3'b000 ;
                    else
                    nextstate = 3'b001;


            3'b001 : if(SS_n)
                        nextstate = 3'b000;
                        else if (SS_n==0 && MOSI==0)
                        nextstate = 3'b010;
                        else if (SS_n==0 && MOSI==1 && Read==0)   
                        nextstate = 3'b100;
                        else 
                        nextstate = 3'b011;
                        

            3'b010 : if(SS_n)
                      nextstate = 3'b000;
                      else 
                      nextstate =3'b010;
            

        3'b011 : if(SS_n)
                      nextstate = 3'b000;
                      else 
                      nextstate = 3'b011;

            //********when back to IDLE let Read=Data and later change it to Add????????/
            3'b100 : if(SS_n) 
                         nextstate = 3'b000;
                         else
                         nextstate = 3'b100;
        

        endcase
    end


    StoP #(10) serial_to_par (clk,MOSI,enable_ser_to_par,StoP_out,finish);

  /*  MEM #(256,8) RAM (
                      .clk         (clk),
                      .rst         (rst),
                      .din         (rx_data),
                      .rx_valid    (rx_valid),
                      .dout        (temp_txData),   
                      .tx_valid    (tx_valid)

    );*/

    

    //output logic always block
    always@(posedge clk)
     begin
        case(state)
            //"IDLE": 


           3'b001 : enable_ser_to_par = 1; 
           
                        

            3'b010 : begin
              //bas lazem nb3at MOSI 3l negedge 3shan b3daha Serial to parallel yshta9al
            rx_data = StoP_out;
            rx_valid = finish;   
            //SS_n = 1;  //should be changed from the Master???
            end

            

            3'b011 : begin
               if (tx_valid && Read)
                begin
                    temp_txData <= tx_data;
               end
            end


            3'b100 : begin
            enable_ser_to_par = 1;
            rx_data = StoP_out;
            rx_valid = finish;   
           // SS_n = 1;  //should be changed from the Master??
            Read = 1;   /////?????????????
            end

        endcase
     end

assign ttx_data = temp_txData;
ParallelToSerial PtoS (
                      .clk             (clk),
                      .tx_valid        (tx_valid),
                      .parallel_data   (ttx_data),
                      .serial_out      (MISO)
);

endmodule