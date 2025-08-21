`timescale 1ns/1ps

`include "counter.v"
`include "clock_divider.v"
`include "display_mode.v"
`include "bcd_to_led.v"

`include "second.v" 
`include "minute.v" 
`include "hour.v" 
`include "day.v" 
`include "month.v" 
`include "year.v"

module century_clock_tb;

  reg clk;
  reg rst_n;
  reg en_s;
  reg display_mode;

  reg up_s,   down_s;
  reg up_m,   down_m;
  reg up_h,   down_h;
  reg up_d,   down_d;
  reg up_mo,  down_mo;
  reg up_y,   down_y;

  wire [6:0] led0, led1, led2, led3;
  wire [6:0] led4, led5;
  wire [6:0] led6, led7;

  // ==== DUT ====
  // Override parameter của clock_divider để mô phỏng nhanh
  century_clock #() dut (
    .clk(clk),
    .rst_n(rst_n),
    .en_s(en_s),
    .display_mode(display_mode),
    .up_s(up_s),     .down_s(down_s),
    .up_m(up_m),     .down_m(down_m),
    .up_h(up_h),     .down_h(down_h),
    .up_d(up_d),     .down_d(down_d),
    .up_mo(up_mo),   .down_mo(down_mo),
    .up_y(up_y),     .down_y(down_y),
    .led0(led0), .led1(led1), .led2(led2), .led3(led3),
    .led4(led4), .led5(led5),
    .led6(led6), .led7(led7)
  );

  // Clock hệ thống TB
  initial clk = 0;
  always #5 clk = ~clk; // 100MHz giả định

  integer month_val, year_val, day_val;
  integer i;

  initial begin
    // Init inputs
    en_s = 0; display_mode = 0;
    up_s=0; down_s=0;  up_m=0; down_m=0;  up_h=0; down_h=0;
    up_d=0; down_d=0;  up_mo=0; down_mo=0;  up_y=0; down_y=0;

    rst_n = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;
    @(posedge clk);
    en_s = 1; // enable đếm

    // In trạng thái ban đầu
    #1;
    day_val   = dut.day_ten*10 + dut.day_unit;
    month_val = dut.month_ten*10 + dut.month_unit;
    year_val  = dut.year_thou*1000 + dut.year_hund*100 + dut.year_ten*10 + dut.year_unit;
    $display("START: Day=%0d Month=%0d Year=%0d", day_val, month_val, year_val);

    // Số bước giả lập (tùy tần số chia) để ra 1 thập kỷ
    // Nếu F_OUT trong clock_divider được set nhỏ, bạn điều chỉnh vòng for này cho vừa
    for (i = 0; i < 120*320; i = i + 1) begin
      @(posedge dut.pulse_mo); // chờ rollover tháng
      month_val = dut.month_ten*10 + dut.month_unit;
      year_val  = dut.year_thou*1000 + dut.year_hund*100 + dut.year_ten*10 + dut.year_unit;
      $display("[%0t] Month=%0d Year=%0d", $time, month_val, year_val);
    end

    $display("Done: one decade reached.");
    $finish;
  end

endmodule
