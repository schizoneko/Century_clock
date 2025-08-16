module count_hour #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 2
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_h,
    input                                   up, down,             
    output      [MAX_DISPLAY_UNIT - 1 : 0]  hour_unit,        
    output      [MAX_DISPLAY_TEN  - 1 : 0]  hour_ten,
    output                                  rst_hour,
    output                                  pulse_h       
);

    wire pulse_unit;

    counter #(
        .MAX_COUNT(9),
        .BIT_SIZE(4)
    ) u_count_unit (
        .clk(clk),
        .rst_n(rst_n),
        .en(en_h),
        .up(up),
        .down(down),
        .count(hour_unit),
        .pulse_o(pulse_unit)
    );

    counter #(
        .MAX_COUNT(2),
        .BIT_SIZE(2)
    ) u_count_ten (
        .clk(clk),
        .rst_n(rst_n),
        .en(pulse_unit),
        .up(up),
        .down(down),             
        .count(hour_ten),
        .pulse_o()                     
    );
    

endmodule
