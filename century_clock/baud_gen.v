`timescale 1ns/1ps

module baud_gen (
  input clk,              // Clock input
  input rst,              // Active HIGH reset - synchronous to clk
  output baud_en      // Baud rate enable for 1x baud rate
);

// Parameters for baud rate generator
parameter BAUD_RATE    = 57_600;              // Baud rate (set to 57,600bps by default)
parameter CLOCK_RATE   = 50_000_000;          // System clock rate (50 MHz by default)

localparam DIVIDER     = CLOCK_RATE / BAUD_RATE; // Divider to generate baud_en
localparam DIVIDER_VAL = DIVIDER - 1;    // Value to reload the counter

// Counter for generating baud_en signal
reg [31:0] internal_count;  // 32-bit internal counter to count clock cycles
reg baud_en_reg;         // The baud_en register for output

// Always block to update the counter and generate baud_en signal
always @(posedge clk)
begin
  if (rst) 
  begin
    internal_count <= DIVIDER_VAL;  // Reload counter when reset is active
    baud_en_reg <= 1'b0;         // Clear baud enable signal during reset
  end
  else 
  begin
    // When the counter reaches 0, assert baud_en signal
    if (internal_count == 0) 
    begin
      internal_count <= DIVIDER_VAL;   // Reload the counter
      baud_en_reg <= 1'b1;          // Assert baud_en signal
    end
    else 
    begin
      internal_count <= internal_count - 1'b1; // Decrement the counter
      baud_en_reg <= 1'b0;           // Deassert baud_en signal
    end
  end
end

// Output the baud_en signal
assign baud_en = baud_en_reg;

endmodule
