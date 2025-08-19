module control_unit (
    input               clk,
    input               rst_n,
    input               en,                 // = ~en_s

    input               select,             // Button
    input               up,
    input               down,

    output reg          up_s,   down_s,     // second
    output reg          up_m,   down_m,     // minute
    output reg          up_h,   down_h,     // hour
    output reg          up_d,   down_d,     // day
    output reg          up_mo,  down_mo,    // month
    output reg          up_y,   down_y,     // year

    output reg          tick_blink,
    output reg  [2:0]   blink                 
);

    localparam SET_SEC   = 3'd0,
               SET_MIN   = 3'd1,
               SET_HOUR  = 3'd2,
               SET_DAY   = 3'd3,
               SET_MONTH = 3'd4,
               SET_YEAR  = 3'd5;

    reg [2:0] state, next_state;

    //------     Blink tick       ------

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            tick_blink  <= 0;
        end
        else begin
            tick_blink  <= ~tick_blink;
        end
    end

    always @(posedge clk or negedge rst_n) begin : State_Transitions
        if (!rst_n) begin
            state <= SET_SEC; 
        end else begin
            state <= next_state;
        end
    end

    always @(state or select or en or up or down) 
        begin : Control_Logic
            up_s=0; down_s=0;
            up_m=0;  down_m=0;
            up_h=0;  down_h=0;
            up_d=0;  down_d=0;
            up_mo=0; down_mo=0;
            up_y=0;  down_y=0;

            blink = 3'b000;

            next_state = state;

            if (en) begin
                blink = 3'b000;
                next_state = state;
            end 
            else begin 
                case (state)
                    SET_SEC:   
                    begin
                        if (select) begin
                            up_s       = up;  
                            down_s     = down;  
                            blink      = 3'b001;  
                            next_state = SET_SEC;
                        end
                        else begin 
                            next_state = SET_MIN;
                        end
                    end

                    SET_MIN:   
                    begin 
                        if (select) begin
                            up_m  = up;  
                            down_m  = down;  
                            blink = 3'b010;
                            next_state = SET_MIN;
                        end 
                        else begin      
                            next_state = SET_HOUR;
                        end 
                    end

                    SET_HOUR:  
                    begin 
                        if (select) begin
                            up_h  = up;  
                            down_h  = down;  
                            next_state = SET_HOUR;
                            blink = 3'b011; 
                        end
                        else begin 
                            next_state = SET_DAY;
                        end 
                    end

                    SET_DAY:   
                    begin 
                        if (select) begin
                            up_d  = up;  
                            down_d  = down;  
                            next_state = SET_DAY;
                            blink = 3'b100;
                        end
                        else begin 
                            next_state = SET_MONTH;
                        end 
                    end

                    SET_MONTH: 
                    begin 
                        if (select) begin
                            up_mo = up;  
                            down_mo = down;  
                            next_state = SET_MONTH;
                            blink = 3'b101; 
                        end 
                        else begin 
                            next_state = SET_YEAR;
                        end
                    end

                    SET_YEAR:  
                    begin
                        if (select) begin 
                            up_y  = up;  
                            down_y  = down;  
                            next_state = SET_YEAR;
                            blink = 3'b110; 
                        end
                        else begin 
                            next_state = SET_SEC;
                        end
                    end
                    default: next_state = SET_SEC; 
                endcase
            end
        end

endmodule