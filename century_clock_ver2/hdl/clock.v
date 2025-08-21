module clock (
    input               clk,
    input               rst_n,
    input               en_s,
    input               display_mode,

    input               up_s,   down_s,
    input               up_m,   down_m,
    input               up_h,   down_h,

    output      [3:0]   sec_unit, sec_ten, min_unit, min_ten, hour_unit,
    output      [1:0]   hour_ten
);

    wire         rst_hour;
    wire         pulse_s;
    wire         pulse_m;
    wire         pulse_h;

    wire         local_rst_hour = rst_n & rst_hour;


    // ======= SECOND =======
    count_second u_sec (
        .clk        (clk),
        .rst_n      (local_rst_hour),
        .en_s       (en_s),
        .up         (up_s),
        .down       (down_s),
        .sec_unit   (sec_unit),
        .sec_ten    (sec_ten),
        .pulse_s    (pulse_s)
    );

    // ======= MINUTE =======
    count_minute u_min (
        .clk        (clk),
        .rst_n      (local_rst_hour),
        .en_m       (pulse_s),  
        .up         (up_m),
        .down       (down_m),       
        .min_unit   (min_unit),
        .min_ten    (min_ten),
        .pulse_m    (pulse_m)       
    );

    // ======= HOUR  =======
    count_hour u_hour (
        .clk        (clk),
        .rst_n      (local_rst_hour),
        .en_h       (pulse_m),     
        .up         (up_h),
        .down       (down_h),       
        .hour_unit  (hour_unit),
        .hour_ten   (hour_ten),
        .pulse_h    (pulse_h),
        .rst_hour   (rst_hour)       
    );

endmodule