module count_minute #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 4
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_m,  
    input                                   up, down,
    output  reg [MAX_DISPLAY_UNIT - 1 : 0]  min_unit,         
    output  reg [MAX_DISPLAY_TEN  - 1 : 0]  min_ten,
    output                                  pulse_m          
);

    wire pulse_unit;

    counter #(
        .MAX_COUNT(9),
        .BIT_SIZE(4)
    ) u_count_unit (
        .clk(clk),
        .rst_n(rst_n),
        .en(en_m),
        .up(up),
        .down(down),
        .count(min_unit),
        .pulse_o(pulse_unit)
    );

    counter #(
        .MAX_COUNT(5),
        .BIT_SIZE(4)
    ) u_count_ten (
        .clk(clk),
        .rst_n(rst_n),
        .en(pulse_unit),
        .up(up),
        .down(down),             
        .count(min_ten),
        .pulse_o(pulse_m)                     
    );

endmodule
