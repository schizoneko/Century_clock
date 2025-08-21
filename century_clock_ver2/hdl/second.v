module count_second #(
    parameter MAX_DISPLAY_UNIT  = 4,
    parameter MAX_DISPLAY_TEN   = 4
) (
    input                                   clk,
    input                                   rst_n,
    input                                   en_s,
    input                                   up, down,
    output      [MAX_DISPLAY_UNIT - 1 : 0]  sec_unit,
    output      [MAX_DISPLAY_TEN  - 1 : 0]  sec_ten,
    output                                  pulse_s
);

    wire pulse_unit;

    counter #(
        .MAX_COUNT(9),
        .BIT_SIZE(4)
    ) u_count_unit (
        .clk    (clk),
        .rst_n  (rst_n),
        .en     (en_s),
        .up     (up),
        .down   (down),
        .count  (sec_unit),
        .pulse_o(pulse_unit)
    );

    counter #(
        .MAX_COUNT(5),
        .BIT_SIZE(4)
    ) u_count_ten (
        .clk    (clk),
        .rst_n  (rst_n),
        .en     (pulse_unit), 
        .up     (up),
        .down   (down),
        .count  (sec_ten),
        .pulse_o(pulse_s)
    );

endmodule
