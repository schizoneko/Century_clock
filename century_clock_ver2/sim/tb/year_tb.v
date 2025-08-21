`timescale 1ns/1ps

module count_year_tb;

  // Clock/Reset/Enable
  reg clk;
  reg rst_n;
  reg en_yr;

  // DUT outputs
  wire [3:0] year_unit;
  wire [3:0] year_ten;
  wire [3:0] year_hund;
  wire [3:0] year_thou;
  wire       leap_year;

  // Instantiate DUT
  count_year dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .en_yr     (en_yr),
    .year_unit (year_unit),
    .year_ten  (year_ten),
    .year_hund (year_hund),
    .year_thou (year_thou),
    .leap_year (leap_year)
  );

  // Clock 100 MHz
  initial clk = 1'b0;
  always #5 clk = ~clk;

  integer i;
  integer year_val;

  initial begin
    // Init
    en_yr = 1'b0;
    rst_n = 1'b0;

    // Reset vài nhịp
    repeat (3) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // Bật đếm năm
    en_yr = 1'b1;

    // In trạng thái ban đầu (mặc định 2000)
    #1;
    year_val = year_thou*1000 + year_hund*100 + year_ten*10 + year_unit;
    $display("[%0t] START: Year=%0d  leap_year=%0b", $time, year_val, leap_year);

    // Đếm 1 thế kỷ = 100 năm
    for (i = 0; i < 100; i = i + 1) begin
      @(posedge clk);
      #1; // đợi non-blocking cập nhật xong
      year_val = year_thou*1000 + year_hund*100 + year_ten*10 + year_unit;
      $display("[%0t] YEAR+%0d -> Year=%0d  leap_year=%0b",
               $time, i+1, year_val, leap_year);
    end

    $display("Done: counted one century (100 years).");
    $finish;
  end

endmodule
