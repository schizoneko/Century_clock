module count_month #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                    clk,
    input                                    rst_n,
    input                                    en_mo,
    input                                    preset,
    input                                    up, down,
    output reg  [MAX_DISPLAY_UNIT - 1 : 0]   month_unit,
    output reg  [MAX_DISPLAY_TEN  - 1 : 0]   month_ten,
    output                                   mon_31, mon_30, mon_29,
    output                                   mon_12
);

    always @(posedge clk or negedge rst_n)
    begin 
        if (~rst_n) begin
            month_unit  <= 1;
            month_ten   <= 0;
        end
        else if (preset) begin
            month_unit  <= 1;
            month_ten   <= 0;
        end
        else begin
            if (en_mo) begin
                if (month_ten == 1 && month_unit == 2) begin
                    month_ten             <= 0;
                    month_unit            <= 1;
                end
                else if (month_unit == 9) begin
                    month_unit   <= 0;
                    month_ten    <= month_ten + 1;
                end
                else begin
                    month_unit   <= month_unit + 1;
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
                    if (month_ten == 0 && month_unit == 1) begin
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

    assign mon_30  = month_unit[0] ^ month_unit[3] ^ month_ten[0];
    assign mon_29 = ~(month_unit[0] | month_unit[2] | month_unit[3] | month_ten[0]);
    assign mon_31 = ~(mon_30 | mon_29); 

    assign mon_12 = (~month_unit[0]& month_unit[1] & ~month_unit[2]) & month_ten[0];
    
endmodule
