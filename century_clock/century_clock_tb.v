`timescale 1ns/1ps

`include "counter.v" 
`include "second.v" 
`include "minute.v" 
`include "hour.v" 
`include "day.v" 
`include "month.v" 
`include "year.v"

module century_clock_tb;

  reg clk;
  reg rst_n;
  reg en_s; // không dùng thực tế, chỉ để giữ cấu trúc DUT

  // Quan sát đầu ra
  wire [3:0] sec_unit, sec_ten;
  wire [3:0] min_unit, min_ten;
  wire [3:0] hour_unit, hour_ten;
  wire [3:0] day_unit;
  wire [1:0] day_ten;
  wire [3:0] month_unit;
  wire [1:0] month_ten;
  wire [3:0] year_unit, year_ten, year_hund, year_thou;

  // DUT
  century_clock dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .en_s      (en_s),
    .sec_unit  (sec_unit),
    .sec_ten   (sec_ten),
    .min_unit  (min_unit),
    .min_ten   (min_ten),
    .hour_unit (hour_unit),
    .hour_ten  (hour_ten),
    .day_unit  (day_unit),
    .day_ten   (day_ten),
    .month_unit(month_unit),
    .month_ten (month_ten),
    .year_hund (year_hund),
    .year_ten  (year_ten),
    .year_thou (year_thou),
    .year_unit (year_unit)
  );

  // Clock 100 MHz
  initial clk = 1'b0;
  always #5 clk = ~clk;

  integer i;
  integer m_val, y_val, d_val;

  initial begin
    // Khởi tạo
    en_s  = 1'b0;
    rst_n = 1'b0;

    // Reset vài nhịp
    repeat (3) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // In trạng thái ban đầu
    #1;
    m_val = month_ten*10 + month_unit;
    y_val = year_thou*1000 + year_hund*100 + year_ten*10 + year_unit;
    d_val = day_ten*10 + day_unit;
    $display("[%0t] START: Day=%0d  Month=%0d  Year=%0d", $time, d_val, m_val, y_val);

    // Đếm 3 thập kỷ = ~30*12*31 ≈ 11160 ngày
    for (i = 1; i <= (300*12*31); i = i + 1) begin
      @(posedge clk);
      force dut.pulse_h = 1'b1; 
      @(posedge clk);
      release dut.pulse_h;

      #1;
      m_val = month_ten*10 + month_unit;
      y_val = year_thou*1000 + year_hund*100 + year_ten*10 + year_unit;
      d_val = day_ten*10 + day_unit;

      // In ra mỗi lần sang ngày mới
      $display("[%0t] STEP=%0d  Day=%0d  Month=%0d  Year=%0d",
               $time, i, d_val, m_val, y_val);
    end

    $display("Done: simulated 3 decades via pulse_h forcing.");
    $finish;
  end

endmodule

