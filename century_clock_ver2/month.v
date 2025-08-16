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

    wire valid_0x = (month_ten == 2'b00) && (month_unit >= 4'd1) && (month_unit <= 4'd9);
    wire valid_1x = (month_ten == 2'b01) && (month_unit <= 4'd2);
    wire valid    = valid_0x | valid_1x;

    always @(posedge clk or negedge rst_n)
    begin 
        if (~rst_n) begin
            pulse_month <= 0;
            month_unit  <= 4'd1;
            month_ten   <= 4'd0;
        end
        else begin 
            if (valid) begin
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
                    
                end
            end
            else begin
                pulse_month <= 0;
                month_unit  <= 4'd1;
                month_ten   <= 4'd0;     
            end
        end
    end 

    assign pulse_mo = pulse_month & en_mo;

    assign T  = month_unit[0] ^ month_unit[3] ^ month_ten[0];
    assign TN = ~(month_unit[0] | month_unit[2] | month_unit[3] | month_ten[0]);
    assign TO = ~(T | TN); 

endmodule