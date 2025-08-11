module century_clock (
    input               clk,
    input               rst_n,
    input               en_s,
    input               display_mode,

    input               up_s,   down_s,
    input               up_m,   down_m,
    input               up_h,   down_h,
    input               up_d,   down_d,
    input               up_mo,  down_mo,
    input               up_y,   down_y,

    output      [6:0]   led0, led1, led2, led3,
    output      [6:0]   led4, led5,
    output      [6:0]   led6, led7
);

    wire         pulse_s;
    wire         pulse_m;
    wire         pulse_h;
    wire         pulse_day;
    wire         pulse_mo;
    wire         TO, T, TN;
    wire         leap_year;

    reg  [3:0]   sec_unit, sec_ten;
    reg  [3:0]   min_unit, min_ten;
    reg  [3:0]   hour_unit, hour_ten;
    reg  [3:0]   day_unit;
    reg  [1:0]   day_ten;
    reg  [3:0]   month_unit;
    reg  [1:0]   month_ten;
    reg  [3:0]   year_hund, year_ten, year_thou, year_unit;

    // ======= SECOND =======
    count_second u_sec (
        .clk        (clk),
        .rst_n      (rst_n),
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
        .rst_n      (rst_n),
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
        .rst_n      (rst_n),
        .en_h       (pulse_m),     
        .up         (up_h),
        .down       (down_h),       
        .hour_unit  (hour_unit),
        .hour_ten   (hour_ten),
        .pulse_h    (pulse_h)       
    );

    // =======  DAY  =======
    count_day u_day (
        .clk        (clk),
        .rst_n      (rst_n),
        .en_d       (pulse_h),  
        .up         (up_d),
        .down       (down_d), 
        .leap_year  (leap_year),
        .T          (T),
        .TO         (TO),
        .TN         (TN),
        .day_unit   (day_unit),
        .day_ten    (day_ten),
        .pulse_d    (pulse_day)     
    );

    // ======= MONTH =======
    count_month u_month (
        .clk        (clk),
        .rst_n      (rst_n),
        .en_mo      (pulse_day),  
        .up         (up_mo),
        .down       (down_mo), 
        .month_unit (month_unit),
        .month_ten  (month_ten),
        .pulse_mo   (pulse_mo),
        .T          (T),
        .TO         (TO),
        .TN         (TN)
    );

    // =======  YEAR  =======
    count_year u_year (
        .clk       (clk),
        .rst_n     (rst_n),
        .en_yr     (pulse_mo),   
        .up_d      (up_y),
        .down      (down_y),           
        .year_unit (year_unit),
        .year_ten  (year_ten),
        .year_hund (year_hund),
        .year_thou (year_thou),
        .leap_year (leap_year)
    );

    // ======= DISPLAY =======
    display_mode u_disp (
        .sec_unit   (sec_unit),
        .sec_ten    (sec_ten),
        .min_unit   (min_unit),
        .min_ten    (min_ten),
        .hour_unit  (hour_unit),
        .hour_ten   (hour_ten),
        .day_unit   (day_unit),
        .day_ten    (day_ten),      
        .month_unit (month_unit),
        .month_ten  (month_ten),    
        .year_hund  (year_hund),
        .year_ten   (year_ten),
        .year_thou  (year_thou),
        .year_unit  (year_unit),
        .mode       (display_mode),

        .led0(led0), .led1(led1), .led2(led2), .led3(led3),
        .led4(led4), .led5(led5), .led6(led6), .led7(led7)
    );

endmodule