module count_year #(
    parameter MAX_UNIT = 4,  
    parameter MAX_TEN  = 4,  
    parameter MAX_HUND = 4, 
    parameter MAX_THOU = 4  
) (
    input                           clk,
    input                           rst_n,
    input                           en_yr,      
    input                           up,down,
    output reg [MAX_UNIT -1:0]      year_unit,
    output reg [MAX_TEN  -1:0]      year_ten,
    output reg [MAX_HUND -1:0]      year_hund,
    output reg [MAX_THOU -1:0]      year_thou,
    output                          leap_year   
);

    wire xx_00, xx; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            year_unit <= 0;
            year_ten  <= 0;
            year_hund <= 0;
            year_thou <= 2;
        end
        else begin
            if (en_yr) begin
                if (year_unit == 9) begin
                    year_unit <= 0;
                    if (year_ten == 9) begin
                        year_ten <= 0;
                        if (year_hund == 9) begin
                            year_hund <= 0;
                            if (year_thou == 9)
                                year_thou <= 0;
                            else
                                year_thou <= year_thou + 1;
                        end
                        else
                            year_hund <= year_hund + 1;
                    end
                    else
                        year_ten <= year_ten + 1;
                end
                else begin
                    year_unit <= year_unit + 1;
                end
            end
            else begin
                if (up && !down) begin
                    if (year_unit == 9) begin
                        year_unit <= 0;
                        if (year_ten == 9) begin
                            year_ten <= 0;
                            if (year_hund == 9) begin
                                year_hund <= 0;
                                if (year_thou == 9)
                                    year_thou <= 0;
                                else
                                    year_thou <= year_thou + 1;
                            end
                            else
                                year_hund <= year_hund + 1;
                        end
                        else
                            year_ten <= year_ten + 1;
                    end
                    else begin
                        year_unit <= year_unit + 1;
                    end
                end
                else if (down && !up) begin
                    if (year_unit == 0) begin
                        year_unit <= 9;
                        if (year_ten == 0) begin
                            year_ten <= 9;
                            if (year_hund == 0) begin
                                year_hund <= 9;
                                if (year_thou == 0)
                                    year_thou <= 9;
                                else
                                    year_thou <= year_thou - 1;
                            end
                            else
                                year_hund <= year_hund - 1;
                        end
                        else
                            year_ten <= year_ten - 1;
                    end
                    else begin
                        year_unit <= year_unit - 1;
                    end
                end
                else begin
                    year_unit <= year_unit;
                    year_ten  <= year_ten;
                    year_hund <= year_hund;
                    year_thou <= year_thou;
                end
            end
        end
    end

    assign xx        = (~year_ten[0] & ~year_unit[0] & ~year_unit[1]) | (year_ten[0] & year_unit[1] & ~year_unit[0]);
    assign xx_00     = xx & (~|year_ten) & (~|year_unit);
    assign leap_year = xx | xx_00;

endmodule
