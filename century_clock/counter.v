module counter #(
    parameter MAX_COUNT = 9,
    parameter BIT_SIZE = 4
) (
    input                               clk,
    input                               rst_n,
    input                               en,
    input                               up, down,
    output  reg [BIT_SIZE - 1 : 0]      count,
    output  reg                         pulse_o
);

reg pulse;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count   <= {BIT_SIZE{1'b0}};;
        pulse   <= 1'b0;
    end 
    else begin
        if (en) begin
            if (count == MAX_COUNT) begin
                count <= {BIT_SIZE{1'b0}};
                pulse <= 1'b0;
            end else
                count <= count + {{(BIT_SIZE-1){1'b0}}, 1'b1};

            if (count == (MAX_COUNT - 1)) begin
                pulse <= 1'b1;
            end
            else begin
                pulse <= 1'b0;
            end
        end
        else begin
            pulse <= 1'b0; 
            if (up && !down) begin
                if (count == MAX_COUNT[BIT_SIZE-1:0])
                    count <= {BIT_SIZE{1'b0}};
                else
                    count <= count + {{(BIT_SIZE-1){1'b0}}, 1'b1};
            end
            else if (down && !up) begin
                if (count == {BIT_SIZE{1'b0}})
                    count <= MAX_COUNT[BIT_SIZE-1:0];
                else
                    count <= count - {{(BIT_SIZE-1){1'b0}}, 1'b1};
            end
            else begin
                count <= 0;
            end
        end
    end
end

assign pulse_o = pulse & en;

endmodule
