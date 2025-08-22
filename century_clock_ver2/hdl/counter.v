module counter #(
    parameter MAX_COUNT = 9,
    parameter BIT_SIZE = 4
) (
    input                               clk,
    input                               rst_n,      // asynchronous reset
    input                               preset0,    // synchronous reset to 0
    input                               preset1,    // synchronous reset to 1 (for day and month)
    input                               en,         // enable counting 
    input                               up, down,   
    output  reg [BIT_SIZE - 1 : 0]      count,
    output                              pulse       // carry out
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count   <= {BIT_SIZE{1'b0}};
    end 
    else if (preset0) begin 
        count   <= {BIT_SIZE{1'b0}};
    end
    else if (preset1) begin 
        count   <= {{(BIT_SIZE-1){1'b0}},1'b1}
    end 
    else begin
        if (en) begin
            if (count == MAX_COUNT) begin
                count <= {BIT_SIZE{1'b0}};
            end 
            else begin
                count <= count + {{(BIT_SIZE-1){1'b0}}, 1'b1};
            end

            if (count == MAX_COUNT - 1) begin
                pulse <= 1;
            end
            else begin
                pulse <= 0;
            end
        end
        else begin 
            if (up && !down) begin
                if (count == MAX_COUNT)
                    count <= {BIT_SIZE{1'b0}};
                else
                    count <= count + {{(BIT_SIZE-1){1'b0}}, 1'b1};
            end
            else if (down && !up) begin
                if (count == {BIT_SIZE{1'b0}})
                    count <= MAX_COUNT;
                else
                    count <= count - {{(BIT_SIZE-1){1'b0}}, 1'b1};
            end
            else begin
                count <= count;
            end
        end
        
    end
end

endmodule
