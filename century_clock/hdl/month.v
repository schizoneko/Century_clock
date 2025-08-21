module count_month #(
    parameter STATE_COUNT       = 3,
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                    clk,
    input                                    rst_n,
    input                                    en_mo,
    input                                    up,down,
    output reg  [MAX_DISPLAY_UNIT - 1 : 0]   month_unit,
    output reg  [MAX_DISPLAY_TEN  - 1 : 0]   month_ten,
    output                                   TO, T, TN,
    output                                   pulse_mo
);

    reg pulse_month;

    always @(posedge clk or negedge rst_n)
    begin 
        if (~rst_n) begin
            pulse_month <= 0;
            month_unit  <= 4'd1;
            month_ten   <= 0;
        end
        else begin 
            if (en_mo) begin
                if (month_ten == 1 && month_unit == 2) begin
                    month_ten     <= 0;
                    month_unit    <= 1;
                    pulse_month   <= 0;
                end
                else if (month_unit == 9) begin
                    month_unit    <= 0;
                    month_ten     <= month_ten + 1;
                end                    
                else begin
                    month_unit    <= month_unit + 1;
                end

                if (month_ten == 1 && month_unit == 1) begin
                    pulse_month   <= 1;
                end
            end
            else begin
                if (up && !down) begin
                    if (month_ten == 1 && month_unit == 2) begin
                        month_ten  <= 0;
                        month_unit <= 1;
                    end
                    else if (month_unit == 9) begin
                        month_unit <= 0;
                        month_ten  <= month_ten + 1;
                    end
                    else begin
                        month_unit <= month_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (month_ten == 0 && month_unit == 0) begin
                        month_ten  <= 1;
                        month_unit <= 2;
                    end
                    else if (month_unit == 0) begin
                        month_unit <= 9;
                        month_ten  <= month_ten - 1;
                    end
                    else begin
                        month_unit <= month_unit - 1;
                    end
                end
                else begin
                    month_ten  <= month_ten;
                    month_unit <= month_unit;
                end
            end
            
        end
    end 

    assign pulse_mo = pulse_month & en_mo;

    assign TO  = month_unit[0] ^ month_unit[3] ^ month_ten[0];
    assign TN = ~(month_unit[0] | month_unit[2] | month_unit[3] | month_ten[0]);
    assign T = ~(TO | TN); 

endmodule
