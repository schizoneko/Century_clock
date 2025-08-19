module count_minute #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 4
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_m,  
    input                                   up, down,
    output reg  [MAX_DISPLAY_UNIT - 1 : 0]  min_unit,         
    output reg  [MAX_DISPLAY_TEN  - 1 : 0]  min_ten,
    output                                  pulse_m          
);

    reg pulse_minute_ten;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            min_unit        <= 0;
            min_ten       <= 0;
            pulse_minute_ten  <= 0;
        end else begin
            if (en_m) begin
                if (min_unit == 9 && min_ten == 5) begin
                    min_unit        <= 0;
                    min_ten         <= 0;
                    pulse_minute_ten  <= 0;
                end
                else if (min_unit == 9) begin
                    min_unit     <= 0;
                    min_ten      <= min_ten + 1;
                end
                else begin
                    min_unit   <= min_unit + 1;
                end

                if (min_unit == 8 && min_ten == 5) begin
                    pulse_minute_ten  <= 1;
                end
                else begin
                    pulse_minute_ten  <= 0;
                end
            end
            else begin
                if (up && !down) begin
                    if (min_unit == 9 && min_ten == 5) begin
                        min_unit  <= 0;
                        min_ten   <= 0;
                    end
                    else if (min_unit == 9) begin
                        min_unit <= 0;
                        min_ten  <= min_ten + 1;
                    end
                    else begin
                        min_unit <= min_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (min_ten == 0 && min_ten == 0) begin
                        min_ten   <= 5;
                        min_unit  <= 9;
                    end
                    else if (min_ten == 0) begin
                        min_unit <= 9;
                        min_ten  <= min_ten - 1;
                    end
                    else begin
                        min_unit <= min_unit - 1;
                    end
                end
                else begin
                    min_unit  <= min_unit;
                    min_ten   <= min_ten;
                end
            end
            
        end
    end

    assign pulse_m = pulse_minute_ten & en_m;

endmodule
