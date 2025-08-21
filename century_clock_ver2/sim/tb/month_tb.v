`timescale 1ns/1ps

module count_month_tb;

  // Tín hiệu TB
  reg         clk;
  reg         rst_n;
  reg         en_mo;

  wire [3:0]  month_unit;
  wire [1:0]  month_ten;
  wire        pulse_mo;

  // DUT
  count_month dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .en_mo      (en_mo),
    .month_unit (month_unit),
    .month_ten  (month_ten),
    .pulse_mo   (pulse_mo)
  );

  // Clock 100 MHz
  initial clk = 1'b0;
  always #5 clk = ~clk;

  integer i;
  integer m;  // giá trị tháng dạng số (1..12)

  initial begin
    // Khởi tạo
    en_mo = 1'b0;
    rst_n = 1'b0;

    // Reset vài nhịp
    repeat (3) @(posedge clk);
    rst_n = 1'b1;

    // Bật đếm
    @(posedge clk);
    en_mo = 1'b1;

    // In trạng thái ban đầu sau reset
    #1 m = month_ten*10 + month_unit;
    $display("[%0t] START  : month=%0d (ten=%0d unit=%0d) pulse_mo=%0b",
             $time, m, month_ten, month_unit, pulse_mo);

    // Đếm liên tục qua nhiều vòng 12 tháng
    // Thay đổi STEPS theo nhu cầu quan sát
    for (i = 0; i < 60; i = i + 1) begin
      @(posedge clk);
      #1 m = month_ten*10 + month_unit;
      $display("[%0t] STEP=%0d: month=%0d (ten=%0d unit=%0d) pulse_mo=%0b",
               $time, i, m, month_ten, month_unit, pulse_mo);
    end

    $display("Done.");
    $finish;
  end

endmodule
