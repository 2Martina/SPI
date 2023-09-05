module FSM
#(parameter s0="IDLE",s1="READ_DATA",s2="READ_ADD",s3="CHK_CMD",s4="WRITE",Read_PARAM="Add")
(
    input clk,rst,
    MOSI,SS_n,tx_valid,
    input [7:0] tx_data,

    output reg MISO,rx_valid,
    output reg [9:0] rx_data
);
    
    reg state,nextstate,Read,enable_ser_to_par;
    reg [7:0] StoP_out;

    initial begin
        enable_ser_to_par <= 0;
    end





//State memory always block
    always@(posedge clk or posedge rst)
    begin
    if (rst)
    state<= s0;
    else begin
    state<= nextstate;
    end
    end



//Next state logic always block
    always@(*)
    begin
        case(state)
            "IDLE": if(SS_n)
                    nextstate = "IDLE" ;
                    else
                    nextstate = "CHK_CMD";


            "CHK_CMD" : if(SS_n)
                        nextstate = "IDLE";
                        else if (SS_n==0 && MOSI==0)
                        nextstate = "  WRITE";
                        else if (SS_n==0 && MOSI==1 && Read=="Add")   
                        nextstate = "READ_ADD";
                        else 
                        nextstate = "READ_DATA";
                        

            "WRITE" : if(SS_n)
                      nextstate = "IDLE";
                      else 
                      nextstate = "WRITE";
            

          //  "READ_DATA" : 




            //********when back to IDLE let Read=Data and later change it to Add????????/
            "READ_ADD" : if(SS_n) 
                         nextstate = "IDLE";
                         else
                         nextstate = "READ_ADD";
        

        endcase
    end


    StoP serial_to_par (clk,MOSI,enable_ser_to_par,StoP_out,finish);

    //output logic always block
    always@(posedge clk)
     begin
        case(state)
            //"IDLE": 


           //"CHK_CMD" : 
           
                        

            "WRITE" : begin
            enable_ser_to_par = 1;  //bas lazem nb3at MOSI 3l negedge 3shan b3daha Serial to parallel yshta9al
            rx_data = StoP_out;
            rx_valid = finish;   
            //SS_n = 1;  //should be changed from the Master???
            end

            

            "READ_DATA" : begin
            Read ="DATA";   /////?????????????
            end


            "READ_ADD" : begin
            rx_data = StoP_out;
            rx_valid = finish;   
           // SS_n = 1;  //should be changed from the Master??
            Read ="DATA";   /////?????????????
            end

        endcase
     end


endmodule