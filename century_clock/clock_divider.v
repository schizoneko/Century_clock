module clock_divider #(
    parameter integer F_IN = 50_000_000  // Hz
)(
    input  wire clk,
    input  wire rst_n,
    input  wire sel,        // 1: 10 kHz, 0: 1 Hz  (async from a switch)
    output reg  clk_out
);
    // Half-period constants
    localparam integer HALF_10K = F_IN / (2*10_000);
    localparam integer HALF_1HZ = F_IN / 2;

    // 1) Đồng bộ sel (2 FF)
    reg sel_s0, sel_s1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sel_s0 <= 1'b0;
            sel_s1 <= 1'b0;
        end else begin
            sel_s0 <= sel;
            sel_s1 <= sel_s0;
        end
    end

    // 2) Theo dõi đổi trạng thái của sel đã đồng bộ
    reg sel_sync_d;
    wire sel_changed = (sel_s1 ^ sel_sync_d);

    // 3) Lưu ngưỡng hiện hành vào thanh ghi (tránh dao động tổ hợp)
    reg [31:0] half_target_r;
    reg [31:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sel_sync_d    <= 1'b0;
            half_target_r <= HALF_1HZ;   // mặc định 1 Hz
            cnt           <= 32'd0;
            clk_out       <= 1'b0;
        end else begin
            // chốt sel sync
            sel_sync_d <= sel_s1;

            // Nếu sel đổi: nạp ngưỡng mới và reset đếm/pha để tránh xung "vô định"
            if (sel_changed) begin
                half_target_r <= sel_s1 ? HALF_10K : HALF_1HZ;
                cnt           <= 32'd0;
                clk_out       <= 1'b0;   
            end else begin
                // Bình thường đếm và đảo pha khi đủ nửa chu kỳ
                if (cnt >= half_target_r - 1) begin
                    cnt     <= 32'd0;
                    clk_out <= ~clk_out;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end
endmodule
