module count_second #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 4
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_s,     
    input                                   up, down,
    output reg  [MAX_DISPLAY_UNIT - 1 : 0]  sec_unit,         
    output reg  [MAX_DISPLAY_TEN  - 1 : 0]  sec_ten,
    output                                  pulse_s          
);

    reg pulse_second_ten;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sec_ten        <= 0;
            sec_unit       <= 0;
            pulse_second_ten  <= 0;
        end else begin
            if (en_s) begin
                if (sec_ten == 5 && sec_unit == 9) begin
                    sec_ten        <= 0;
                    sec_unit       <= 0;
                    pulse_second_ten  <= 0;
                end
                else if (sec_unit == 9) begin
                    sec_unit   <= 0;
                    sec_ten    <= sec_ten + 1;
                end
                else begin
                    sec_unit   <= sec_unit + 1;
                end

                if (sec_ten == 5 && sec_unit == 8) begin
                    pulse_second_ten  <= 1;
                end
                else begin
                    pulse_second_ten  <= 0;
                end
            end
            else begin
                if (up && !down) begin
                    if (sec_ten == 5 && sec_unit == 9) begin
                        sec_ten  <= 0;
                        sec_unit <= 0;
                    end
                    else if (sec_unit == 9) begin
                        sec_unit <= 0;
                        sec_ten  <= sec_ten + 1;
                    end
                    else begin
                        sec_unit <= sec_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (sec_ten == 0 && sec_unit == 0) begin
                        sec_ten  <= 5;
                        sec_unit <= 9;
                    end
                    else if (sec_unit == 0) begin
                        sec_unit <= 9;
                        sec_ten  <= sec_ten - 1;
                    end
                    else begin
                        sec_unit <= sec_unit - 1;
                    end
                end
                else begin
                    sec_ten  <= sec_ten;
                    sec_unit <= sec_unit;
                end
            end
            
        end
    end

    assign pulse_s = pulse_second_ten & en_s;

endmodule
