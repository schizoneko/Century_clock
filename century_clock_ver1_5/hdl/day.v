module count_day #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                    clk,
    input                                    rst_n,
    input                                    en_d,
    input                                    preset,
    input                                    up, down,
    output reg  [MAX_DISPLAY_UNIT - 1 : 0]   day_unit,
    output reg  [MAX_DISPLAY_TEN  - 1 : 0]   day_ten,
    output                                   day_31,
    output                                   day_30,
    output                                   day_29,
    output                                   day_28
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            day_unit  <= 1;
            day_ten   <= 0;
        end
        else if (preset) begin
            day_unit  <= 1;
            day_ten   <= 0;
        end
        else begin
            if (en_d) begin
                if (day_ten == 3 && day_unit == 1) begin
                    day_ten             <= 0;
                    day_unit            <= 1;
                end
                else if (day_unit == 9) begin
                    day_unit   <= 0;
                    day_ten    <= day_ten + 1;
                end
                else begin
                    day_unit   <= day_unit + 1;
                end
            end
            else begin
                if (up && !down) begin
                    if (day_ten == 3 && day_unit == 1) begin
                        day_ten  <= 0;
                        day_unit <= 1;
                    end
                    else if (day_unit == 9) begin
                        day_unit <= 0;
                        day_ten  <= day_ten + 1;
                    end
                    else begin
                        day_unit <= day_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (day_ten == 0 && day_unit == 1) begin
                        day_ten  <= 3;
                        day_unit <= 1;
                    end
                    else if (day_unit == 0) begin
                        day_unit <= 9;
                        day_ten  <= day_ten - 1;
                    end
                    else begin
                        day_unit <= day_unit - 1;
                    end
                end
                else begin
                    day_ten  <= day_ten;
                    day_unit <= day_unit;
                end
            end
        end
    end

    assign day_31 =  day_unit[0] &   day_ten[0] & day_ten[1];
    assign day_30 = ~day_unit[0] &   day_ten[0] & day_ten[1];
    assign day_28 =  day_unit[3] & ~day_unit[0] & day_ten[1];
    assign day_29 =  day_unit[3] &  day_unit[0] & day_ten[1];

endmodule
