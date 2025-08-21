module clock_divider #(
    parameter integer F_IN  = 50_000_000,  // Hz
    parameter integer F_OUT = 10        // Hz
)(
    input       clk,
    input       rst_n,
    output      clk_out,   // xung vuông F_OUT 
    output reg  ce_out     // xung 1 chu kỳ ở F_OUT (50 kHz)
);
    // Toggle mỗi HALF chu kỳ để ra xung vuông F_OUT
    localparam integer HALF = F_IN / (2*F_OUT);
    // Đếm trọn 1 chu kỳ để tạo CE 1-shot tại F_OUT
    localparam integer TICK = F_IN / F_OUT;

    // Chiều rộng counter
    localparam integer W_HALF = (HALF <= 1) ? 1 : $clog2(HALF);
    localparam integer W_TICK = (TICK <= 1) ? 1 : $clog2(TICK);

    reg [W_HALF-1:0] cnt_half = {W_HALF{1'b0}};
    reg [W_TICK-1:0] cnt_tick = {W_TICK{1'b0}};
    reg clk_reg = 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_half <= {W_HALF{1'b0}};
            cnt_tick <= {W_TICK{1'b0}};
            clk_reg  <= 1'b0;
            ce_out   <= 1'b0;
        end else begin
            // Mặc định không kích CE
            ce_out <= 1'b0;

            // Tạo xung vuông 50 kHz
            if (cnt_half == HALF-1) begin
                cnt_half <= {W_HALF{1'b0}};
                clk_reg  <= ~clk_reg;
            end else begin
                cnt_half <= cnt_half + 1'b1;
            end

            // Tạo CE 1 chu kỳ ở 50 kHz
            if (cnt_tick == TICK-1) begin
                cnt_tick <= {W_TICK{1'b0}};
                ce_out   <= 1'b1;
            end else begin
                cnt_tick <= cnt_tick + 1'b1;
            end
        end
    end

    assign clk_out = clk_reg;
endmodule
