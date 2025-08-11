module display_mode (
    input       [3:0]   sec_unit, sec_ten,
    input       [3:0]   min_unit, min_ten,
    input       [3:0]   hour_unit, hour_ten,
    input       [3:0]   day_unit,
    input       [1:0]   day_ten,
    input       [3:0]   month_unit,
    input       [1:0]   month_ten,
    input       [3:0]   year_hund, year_ten, year_thou, year_unit,
    
    input               mode,

    output      [6:0]   led0, led1, led2, led3,
    output      [6:0]   led4, led5,
    output      [6:0]   led6, led7
);
    
    localparam [6:0] BLANK = 7'b0111111;

    //------ TIME mode: 00 HH MMSS  ------
    wire [6:0] t_led0, t_led1, t_led2, t_led3, t_led4, t_led5;
    wire [6:0] t_led6 = BLANK;
    wire [6:0] t_led7 = BLANK;

    bcd_to_led u_t0 (.bcd(sec_unit), .led(t_led0));
    bcd_to_led u_t1 (.bcd(sec_ten),  .led(t_led1));
    bcd_to_led u_t2 (.bcd(min_unit), .led(t_led2));
    bcd_to_led u_t3 (.bcd(min_ten),  .led(t_led3));
    bcd_to_led u_t4 (.bcd(hour_unit),.led(t_led4));
    bcd_to_led u_t5 (.bcd(hour_ten), .led(t_led5));

    //------ DATE mode: DD MM YYYY  ------
    wire [6:0] d_led0, d_led1, d_led2, d_led3, d_led4, d_led5, d_led6, d_led7;
    wire [3:0] day_ten_bcd   = {2'b00, day_ten};
    wire [3:0] month_ten_bcd = {2'b00, month_ten};

    bcd_to_led u_d4 (.bcd(year_unit),     .led(d_led0));
    bcd_to_led u_d5 (.bcd(year_ten),      .led(d_led1));
    bcd_to_led u_d6 (.bcd(year_hund),     .led(d_led2));
    bcd_to_led u_d7 (.bcd(year_thou),     .led(d_led3));
    bcd_to_led u_d2 (.bcd(month_unit),    .led(d_led4));
    bcd_to_led u_d3 (.bcd(month_ten_bcd), .led(d_led5));
    bcd_to_led u_d0 (.bcd(day_unit),      .led(d_led6));
    bcd_to_led u_d1 (.bcd(day_ten_bcd),   .led(d_led7));

    //------     Display mode       ------
    assign led0 = mode ? t_led0 : d_led0;
    assign led1 = mode ? t_led1 : d_led1;
    assign led2 = mode ? t_led2 : d_led2;
    assign led3 = mode ? t_led3 : d_led3;
    assign led4 = mode ? t_led4 : d_led4;
    assign led5 = mode ? t_led5 : d_led5;
    assign led6 = mode ? t_led6 : d_led6;
    assign led7 = mode ? t_led7 : d_led7;


endmodule