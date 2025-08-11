module count_day #(
    parameter STATE_COUNT       = 3,
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                    clk,
    input                                    rst_n,
    input                                    en_d,
    input                                    up, down,
    input                                    leap_year,
    input                                    TO, T, TN,
    output  reg [MAX_DISPLAY_UNIT - 1 : 0]   day_unit,
    output  reg [MAX_DISPLAY_TEN  - 1 : 0]   day_ten,
    output                                   pulse_d
);

    reg pulse_day;

    wire valid_0x = (day_ten == 2'b00) && (day_unit >= 4'd1) && (day_unit <= 4'd9);
    wire valid_1x = (day_ten == 2'b01) && (day_unit >= 4'd0) && (day_unit <= 4'd9);
    wire valid_2x = (day_ten == 2'b10) && (day_unit >= 4'd0) && (day_unit <= 4'd9);
    wire valid_3x = (day_ten == 2'b11) && (day_unit <= 4'd1);
    wire valid    = valid_0x | valid_1x | valid_2x | valid_3x;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pulse_day <= 0;
            day_unit  <= 1;
            day_ten   <= 0;
        end
        else begin
            if (en_d) begin
                if (TO)
                begin 
                    if (day_ten == 3 && day_unit == 1) begin
                        day_ten     <= 0;
                        day_unit    <= 1;
                        pulse_day   <= 0;
                    end
                    else if (day_unit == 9) begin
                        day_unit    <= 0;
                        day_ten     <= day_ten + 1;
                    end
                    else begin
                        day_unit    <= day_unit + 1;
                    end

                    if (day_ten == 3 && day_unit == 0) begin
                        pulse_day   <= 1;
                    end
                    else begin
                        pulse_day   <= 0;
                    end 
                end                
                else if (T) 
                begin
                    if (day_ten == 3 && day_unit == 0) begin
                        day_ten     <= 0;
                        day_unit    <= 1;
                        pulse_day   <= 0;
                    end
                    else if (day_unit == 9) begin
                        day_unit    <= 0;
                        day_ten     <= day_ten + 1;
                    end
                    else begin
                        day_unit    <= day_unit + 1;
                    end

                    if (day_ten == 2 && day_unit == 9) begin
                        pulse_day   <= 1;
                    end
                    else begin
                        pulse_day   <= 0;
                    end 
                end
                else if (TN)
                begin
                    if (~leap_year) 
                    begin
                        if (day_ten == 2 && day_unit == 9) begin
                            day_ten     <= 0;
                            day_unit    <= 1;
                            pulse_day   <= 0;
                        end
                        else if (day_unit == 9) begin
                            day_unit    <= 0;
                            day_ten     <= day_ten + 1;
                        end
                        else begin
                            day_unit    <= day_unit + 1;
                        end

                        if (day_ten == 2 && day_unit == 8) begin
                            pulse_day   <= 1;
                        end
                        else begin
                            pulse_day   <= 0;
                        end
                    end
                    else 
                    begin
                        if (day_ten == 2 && day_unit == 8) begin
                            day_ten     <= 0;
                            day_unit    <= 1;
                            pulse_day   <= 0;
                        end
                        else if (day_unit == 9) begin
                            day_unit    <= 0;
                            day_ten     <= day_ten + 1;
                        end
                        else begin
                            day_unit    <= day_unit + 1;
                        end

                        if (day_ten == 2 && day_unit == 7) begin
                            pulse_day   <= 1;
                        end
                        else begin
                            pulse_day   <= 0;
                        end
                    end    
                end
                else 
                begin
                    day_unit    <= 1;
                    day_ten     <= 0;
                    pulse_day   <= 0;
                end    
            end
            else begin
                pulse_day   <= 1'b0;
                if (up & ~down) begin
                    if (TO)
                    begin 
                        if (day_ten == 3 && day_unit == 1) begin
                            day_ten     <= 0;
                            day_unit    <= 1;
                        end
                        else if (day_unit == 9) begin
                            day_unit    <= 0;
                            day_ten     <= day_ten + 1;
                        end
                        else begin
                            day_unit    <= day_unit + 1;
                        end
                    end                
                    else if (T) 
                    begin
                        if (day_ten == 3 && day_unit == 0) begin
                            day_ten     <= 0;
                            day_unit    <= 1;
                        end
                        else if (day_unit == 9) begin
                            day_unit    <= 0;
                            day_ten     <= day_ten + 1;
                        end
                        else begin
                            day_unit    <= day_unit + 1;
                        end
                    end
                    else if (TN)
                    begin
                        if (~leap_year) 
                        begin
                            if (day_ten == 2 && day_unit == 9) begin
                                day_ten     <= 0;
                                day_unit    <= 1;
                            end
                            else if (day_unit == 9) begin
                                day_unit    <= 0;
                                day_ten     <= day_ten + 1;
                            end
                            else begin
                                day_unit    <= day_unit + 1;
                            end
                        end
                        else 
                        begin
                            if (day_ten == 2 && day_unit == 8) begin
                                day_ten     <= 0;
                                day_unit    <= 1;
                            end
                            else if (day_unit == 9) begin
                                day_unit    <= 0;
                                day_ten     <= day_ten + 1;
                            end
                            else begin
                                day_unit    <= day_unit + 1;
                            end
                        end    
                    end
                    else 
                    begin
                        day_unit    <= 1;
                        day_ten     <= 0;
                        pulse_day   <= 0;
                    end    
                end
                else if (down && !up) begin 
                    if (TO)
                    begin 
                        if (day_ten == 0 && day_unit == 1) begin
                            day_ten     <= 3;
                            day_unit    <= 1;
                            pulse_day   <= 0;
                        end
                        else if (day_unit == 0) begin
                            day_unit    <= 9;
                            day_ten     <= day_ten - 1;
                        end
                        else begin
                            day_unit    <= day_unit - 1;
                        end
                    end                
                    else if (T) 
                    begin
                        if (day_ten == 0 && day_unit == 1) begin
                            day_ten     <= 3;
                            day_unit    <= 0;
                        end
                        else if (day_unit == 0) begin
                            day_unit    <= 9;
                            day_ten     <= day_ten - 1;
                        end
                        else begin
                            day_unit    <= day_unit - 1;
                        end
                    end
                    else if (TN)
                    begin
                        if (~leap_year) 
                        begin
                            if (day_ten == 0 && day_unit == 1) begin
                                day_ten     <= 9;
                                day_unit    <= 2;
                            end
                            else if (day_unit == 0) begin
                                day_unit    <= 9;
                                day_ten     <= day_ten - 1;
                            end
                            else begin
                                day_unit    <= day_unit - 1;
                            end
                        end
                        else 
                        begin
                            if (day_ten == 0 && day_unit == 1) begin
                                day_ten     <= 8;
                                day_unit    <= 2;
                            end
                            else if (day_unit == 0) begin
                                day_unit    <= 9;
                                day_ten     <= day_ten - 1;
                            end
                            else begin
                                day_unit    <= day_unit - 1;
                            end
                        end    
                    end
                    else 
                    begin
                        day_unit    <= 1;
                        day_ten     <= 0;
                        pulse_day   <= 0;
                    end
                end
                else begin
                    day_unit <= day_unit;
                    day_ten  <= day_ten;
                end
            end
            
        end
    end

    assign pulse_d = pulse_day & en_d; 

endmodule
