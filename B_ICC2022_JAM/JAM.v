module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );


// parameters
parameter IDLE = 2'b00;
parameter COST_ASK = 2'b01;
parameter COST_COUNT = 2'b10;
parameter OUTPUT = 2'b11;

integer i;
reg [1:0]current_state;
reg [1:0]next_state;

reg [2:0]number_sort[0:7];
reg [2:0]number_pointer;
reg [3:0]counter;

reg [9:0]min_cost_acc;

reg [2:0]replace_number;
reg [2:0]replace_to;




// FSM
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always@(*)begin
    case(current_state)
        IDLE: begin
            next_state <= COST_ASK;
        end

        COST_ASK:begin
            if(counter == 'd8)begin
                next_state <= COST_ASK;
            end
            else begin
                next_state <= COST_ASK;
            end
        end

        COST_COUNT:begin
            if((number_sort[7] == 'd0) && (number_sort[6] == 'd1) && (number_sort[5] == 'd2) && (number_sort[4] == 'd3) && (number_sort[3] == 'd4) && (number_sort[2] == 'd5) && (number_sort[1] == 'd6))begin
                next_state <= OUTPUT;
            end
            else begin
                next_state <= COST_ASK;
            end
        end

        OUTPUT:begin
            next_state <= OUTPUT;
        end
    endcase
end




// W
always@(negedge CLK, posedge RST)begin
    if(RST)begin
        W <= 0;
    end
    
    else begin
        if(current_state == COST_ASK)begin
            W <= W+ 'd1;
        end
        
        else begin
        end
    end
end

// J
always@(negedge CLK, posedge RST)begin
    if(RST)begin
        J <= 'd0;
    end

    else begin
        if(current_state == COST_ASK)begin
            J <= number_sort[number_pointer]; 
        end
        
        else begin
        
        end
    end
end

// number_pointer
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        number_pointer <= 'd7;
    end
    else begin
        number_pointer <= number_pointer - 'd1;
    end
end

// counter      // 0~15
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        counter <= 'd0;
    end
    else begin
        if(counter == 'd9)begin
            counter <= 'd0;
        end

        else if((current_state == COST_ASK) || (current_state == COST_COUNT))begin
            counter <= counter +'d1;
        end
        
        else begin
            counter <= 'd0;
        end
    end
end

// replace_number   (position)
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        replace_number <= 0;
    end
    else begin
        if( counter < 'd7)begin             // while 0 ~ 6
            if(number_sort[counter+1] > number_sort[counter])begin
                replace_number <= counter;
            end

            else begin
                replace_number <= replace_number;
            end
        end
        else begin
            replace_number <= replace_number;
        end
    end
end

// replace_to   (position)
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        replace_to <= 'd0;
    end
    else begin
        if(counter < 'd8)begin              // while 0 ~ 7  total : 8 cycles
            if(number_sort[counter] > number_sort[replace_number])begin
                replace_to <= counter;
            end

            else begin
                replace_to <= replace_to;
            end
        end
        else begin
            replace_to <= replace_to;
        end
    end
end



//number_sort
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        number_sort[7] <= 'd7;
        number_sort[6] <= 'd6;
        number_sort[5] <= 'd5;
        number_sort[4] <= 'd4;
        number_sort[3] <= 'd3;
        number_sort[2] <= 'd2;
        number_sort[1] <= 'd1;
        number_sort[0] <= 'd0;
    end
    
    else begin
        if(counter == 'd8)begin
            number_sort[replace_number] <= number_sort[replace_to];
            number_sort[replace_to] <= number_sort[replace_number];
        end

        else begin
        
        end
    end
end


// min_cost_acc
always@(posedge CLK, posedge RST)begin
    if(RST)begin
        min_cost_acc <= 'd0;
    end
    
    else begin
        case(counter)
            4'd0: min_cost_acc <= min_cost_acc + Cost;
            4'd1: min_cost_acc <= min_cost_acc + Cost;
            4'd2: min_cost_acc <= min_cost_acc + Cost;
            4'd3: min_cost_acc <= min_cost_acc + Cost;
            4'd4: min_cost_acc <= min_cost_acc + Cost;
            4'd5: min_cost_acc <= min_cost_acc + Cost;
            4'd6: min_cost_acc <= min_cost_acc + Cost;
            4'd7: min_cost_acc <= min_cost_acc + Cost;      // 8th cycle
            4'd8: min_cost_acc <= min_cost_acc;             // 9th cycle
            default: min_cost_acc <= min_cost_acc;
        endcase
    end
end







always @(posedge CLK, posedge RST) begin
    
end



endmodule


