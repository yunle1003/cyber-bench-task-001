// Vulnerable Timing Comparator
// Vulnerability: Early termination causes timing leak
module timing_comparator (
    input clk,
    input rst,
    input [255:0] expected_key,
    input [255:0] input_key,
    output reg match,
    output reg [8:0] timing_out
);

    reg [8:0] cycle_count;
    integer i;
    reg is_match;
    reg mismatch_found;

    always @(posedge clk) begin
        if (rst) begin
            match <= 0;
            cycle_count <= 0;
            timing_out <= 0;
        end else begin
            is_match = 1;
            cycle_count = 0;
            mismatch_found = 0;
            
            for (i = 0; i < 256; i = i + 1) begin
                if (!mismatch_found) begin
                    if (expected_key[i] != input_key[i]) begin
                        is_match = 0;
                        mismatch_found = 1;
                    end else begin
                        cycle_count = cycle_count + 1;
                    end
                end
            end
            
            match <= is_match;
            timing_out <= cycle_count;
        end
    end

endmodule
