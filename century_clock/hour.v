module count_hour #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_h,
    input                                   up, down,             
    output  reg [MAX_DISPLAY_UNIT - 1 : 0]  hour_unit,        
    output  reg [MAX_DISPLAY_TEN  - 1 : 0]  hour_ten,         
    output  reg                             pulse_h       
);

    reg pulse_hour_ten;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hour_ten        <= 0;
            hour_unit       <= 0;
            pulse_hour_ten  <= 0;
        end else begin
            if (en_h) begin
                if (hour_ten == 2 && hour_unit == 3) begin
                    hour_ten        <= 0;
                    hour_unit       <= 0;
                    pulse_hour_ten  <= 0;
                end
                else if (hour_unit == 9) begin
                    hour_unit   <= 0;
                    hour_ten    <= hour_ten + 1;
                end
                else begin
                    hour_unit   <= hour_unit + 1;
                end

                if (hour_ten == 2 && hour_unit == 2) begin
                    pulse_hour_ten  <= 1;
                end
                else begin
                    pulse_hour_ten  <= 0;
                end
            end
            else begin
                pulse_hour_ten <= 1'b0; 
                if (up && !down) begin
                    if (hour_ten == 2 && hour_unit == 3) begin
                        hour_ten  <= 0;
                        hour_unit <= 0;
                    end
                    else if (hour_unit == 9) begin
                        hour_unit <= 0;
                        hour_ten  <= hour_ten + 1;
                    end
                    else begin
                        hour_unit <= hour_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (hour_ten == 0 && hour_unit == 0) begin
                        hour_ten  <= 2;
                        hour_unit <= 3;
                    end
                    else if (hour_unit == 0) begin
                        hour_unit <= 9;
                        hour_ten  <= hour_ten - 1;
                    end
                    else begin
                        hour_unit <= hour_unit - 1;
                    end
                end
                else begin
                    hour_ten  <= hour_ten;
                    hour_unit <= hour_unit;
                end
            end
            
        end
    end

    assign pulse_h = pulse_hour_ten & en_h;             

endmodule
