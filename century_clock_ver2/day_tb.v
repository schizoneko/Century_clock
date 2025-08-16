`timescale 1ns/1ps

module century_clock_tb;

  // tín hiệu điều khiển đơn giản
  reg        clk;
  reg        rst_n;
  reg        en_s;
  reg [3:0]  day_mode_tb;   // <-- bạn tự đổi giá trị này khi đang sim

  // output từ DUT
  wire [3:0] sec_unit, sec_ten;
  wire [3:0] min_unit, min_ten;
  wire [3:0] hour_unit, hour_ten;
  wire [3:0] day_unit;
  wire [1:0] day_ten;
  wire       pulse_day;

  // DUT
  century_clock dut (
    .clk(clk),
    .rst_n(rst_n),
    .en_s(en_s),
    .day_mode(day_mode_tb),
    .sec_unit(sec_unit), .sec_ten(sec_ten),
    .min_unit(min_unit), .min_ten(min_ten),
    .hour_unit(hour_unit), .hour_ten(hour_ten),
    .day_unit(day_unit),
    .day_ten(day_ten),
    .pulse_day(pulse_day)
  );

  // clock 10ns
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // reset + enable đơn giản
  initial begin
    // mặc định mode 31 ngày
    day_mode_tb = 4'b0010;  // 0001:31, 0010:30, 0100:29, 1000:28
    en_s    = 0;
    rst_n   = 0;
    repeat (5) @(posedge clk);
    rst_n   = 1;
    en_s    = 1;

    // chạy mãi, bạn tự đổi day_mode_tb trong lúc mô phỏng (force/signal panel)
    // ví dụ ModelSim: force -deposit /century_clock_tb/day_mode_tb 4'b0010
  end

  // in log mỗi khi sang ngày mới (pulse_day lên 1)
  always @(posedge pulse_day) begin
    $display("[%0t] ROLLOVER -> Day=%0d, Time=%0d:%0d:%0d, mode=%b",
      $time,
      (day_ten*10 + day_unit),
      (hour_ten*10 + hour_unit),
      (min_ten*10  + min_unit),
      (sec_ten*10  + sec_unit),
      day_mode_tb
    );
  end

  // monitor nhẹ nhàng: in mỗi 00 giây cho đỡ spam (tuỳ thích, có thể bỏ)
  always @(posedge clk) begin
    if (sec_unit == 4'd0 && sec_ten == 4'd0) begin
      $display("[%0t] D=%0d  %0d%0d:%0d%0d:%0d%0d  mode=%b",
        $time,
        (day_ten*10 + day_unit),
        hour_ten, hour_unit, min_ten, min_unit, sec_ten, sec_unit,
        day_mode_tb
      );
    end
  end

endmodule
