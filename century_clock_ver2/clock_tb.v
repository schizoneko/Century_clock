`timescale 1ns/1ps

module clock_tb;

    // ====== Tín hiệu kết nối DUT ======
    reg         clk;
    reg         rst_n;
    reg         en_s;
    reg         display_mode;

    reg         up_s, down_s;
    reg         up_m, down_m;
    reg         up_h, down_h;

    wire [3:0]  sec_unit, sec_ten, min_unit, min_ten, hour_unit;
    wire [1:0]  hour_ten;

    integer clk_count;

    // ====== Khởi tạo DUT ======
    clock uut (
        .clk(clk),
        .rst_n(rst_n),
        .en_s(en_s),
        .display_mode(display_mode),
        .up_s(up_s),
        .down_s(down_s),
        .up_m(up_m),
        .down_m(down_m),
        .up_h(up_h),
        .down_h(down_h),
        .sec_unit(sec_unit),
        .sec_ten(sec_ten),
        .min_unit(min_unit),
        .min_ten(min_ten),
        .hour_unit(hour_unit),
        .hour_ten(hour_ten)
    );

    // ====== Tạo xung clock ======
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10ns
    end

    // ====== Mô phỏng ======
    initial begin
        // Khởi tạo tín hiệu
        rst_n = 0;
        en_s = 0;
        display_mode = 0;
        up_s = 0; down_s = 0;
        up_m = 0; down_m = 0;
        up_h = 0; down_h = 0;
        clk_count = 0;

        // Reset hệ thống
        #20 rst_n = 1;
        en_s = 1; // Bắt đầu cho giây đếm

        // Chạy mô phỏng trong 2000 xung clock
        #2000000 $finish;
    end

endmodule
