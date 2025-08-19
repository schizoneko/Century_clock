module display_mode (
    input               clk_in,
    input               rst_n,

    input       [3:0]   sec_unit, sec_ten,
    input       [3:0]   min_unit, min_ten,
    input       [3:0]   hour_unit, 
    input       [1:0]   hour_ten,
    input       [3:0]   day_unit,
    input       [1:0]   day_ten,
    input       [3:0]   month_unit,
    input       [1:0]   month_ten,
    input       [3:0]   year_hund, year_ten, year_thou, year_unit,
    
    input               mode,         // Select display
    input       [2:0]   blink_mode,   // Blink blink                 

    output reg  [6:0]   led0, led1, led2, led3,
    output reg  [6:0]   led4, led5,
    output reg  [6:0]   led6, led7
);
    
    localparam [6:0]    BLANK       = ~7'b0111111;
    localparam [6:0]    BLINK       = 7'b1111111;

    //------ TIME mode: 00 HH MMSS  ------
    wire [6:0] t_led0, t_led1, t_led2, t_led3, t_led4, t_led5;
    wire [3:0] hour_ten_bcd = {2'b00, hour_ten}; 
    wire [6:0] t_led6       = BLANK;
    wire [6:0] t_led7       = BLANK;

    bcd_to_led u_t0 (.bcd(sec_unit),     .led(t_led0));
    bcd_to_led u_t1 (.bcd(sec_ten),      .led(t_led1));
    bcd_to_led u_t2 (.bcd(min_unit),     .led(t_led2));
    bcd_to_led u_t3 (.bcd(min_ten),      .led(t_led3));
    bcd_to_led u_t4 (.bcd(hour_unit),    .led(t_led4));
    bcd_to_led u_t5 (.bcd(hour_ten_bcd), .led(t_led5));

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
    wire [6:0] sel0 = mode ? t_led0 : d_led0;
    wire [6:0] sel1 = mode ? t_led1 : d_led1;
    wire [6:0] sel2 = mode ? t_led2 : d_led2;
    wire [6:0] sel3 = mode ? t_led3 : d_led3;
    wire [6:0] sel4 = mode ? t_led4 : d_led4;
    wire [6:0] sel5 = mode ? t_led5 : d_led5;
    wire [6:0] sel6 = mode ? t_led6 : d_led6;
    wire [6:0] sel7 = mode ? t_led7 : d_led7;
 
    //------     Blink tick       ------
    reg       tick_blink;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            tick_blink  <= 0;
        end
        else begin
            tick_blink  <= ~tick_blink;
        end
    end

    //------      Blink mode        ------
    always @(*) begin
        led0 = sel0; led1 = sel1; led2 = sel2; led3 = sel3;
        led4 = sel4; led5 = sel5; led6 = sel6; led7 = sel7;

        case (blink_mode)
            3'b001: begin 
                if (tick_blink) begin
                    led0 = BLINK; 
                    led1 = BLINK;
                end
                else begin 
                    led0 = sel0;
                    led1 = sel1;
                end
            end
            3'b010: begin
                if (tick_blink) begin
                    led2 = BLINK; 
                    led3 = BLINK;
                end
                else begin 
                    led2 = sel2;
                    led3 = sel3;
                end
            end
            3'b011: begin 
                if (tick_blink) begin
                    led4 = BLINK; 
                    led5 = BLINK;
                end
                else begin 
                    led4 = sel4;
                    led5 = sel5;
                end
            end
            3'b100: begin 
                if (tick_blink) begin
                    led6 = BLINK; 
                    led7 = BLINK;
                end
                else begin 
                    led6 = sel6;
                    led7 = sel7;
                end
            end
            3'b101: begin 
                if (tick_blink) begin
                    led4 = BLINK; 
                    led5 = BLINK;
                end
            end
            3'b110: begin 
                if (tick_blink) begin
                    led0 = BLINK; 
                    led1 = BLINK; 
                    led2 = BLINK; 
                    led3 = BLINK;
                end
            end
            default: 
            begin
                led0 = sel0; led1 = sel1; led2 = sel2; led3 = sel3;
                led4 = sel4; led5 = sel5; led6 = sel6; led7 = sel7;
            end
        endcase
    end



endmodule