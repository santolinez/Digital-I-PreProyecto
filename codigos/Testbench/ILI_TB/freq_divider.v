module freq_divider #(parameter DIVIDER = 1)(
    input wire clk,
    input wire rst,
    output reg clk_out
);

    reg [$clog2(DIVIDER)-1:0] counter; 

    always @(posedge clk) begin
        if (!rst) begin
            counter <= 'b0;
            clk_out <= 'b0;
        end else begin
            if (counter == (DIVIDER - 1)) begin
                clk_out <= ~clk_out;
                counter <= 'b0;
            end else begin
                counter <= counter + 'b1;
            end
        end
    end
endmodule
