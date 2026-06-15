// Testbench for timing_comparator vulnerability
module testbench;
    reg clk, rst;
    reg [255:0] expected_key;
    reg [255:0] input_key;
    wire match;
    wire [8:0] timing_out;
    
    // Instantiate the vulnerable module
    timing_comparator dut (
        .clk(clk),
        .rst(rst),
        .expected_key(expected_key),
        .input_key(input_key),
        .match(match),
        .timing_out(timing_out)
    );
    
    // Secret key (hardcoded for this task)
    initial begin
        // Secret: 256-bit key to be recovered
        expected_key = 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000;
    end
    
    // Test stimulus
    initial begin
        $dumpfile("timing.vcd");
        $dumpvars(0, testbench);
        
        clk = 0;
        rst = 1;
        input_key = 256'h0;
        
        // Reset
        #10 rst = 0;
        
        // Test 1: All zeros
        #10 input_key = 256'h0;
        #10 $display("Test 1 - timing=%d, match=%b", timing_out, match);
        
        // Test 2: First byte correct
        #10 input_key = 256'hDEADBEEF00000000_00000000_00000000_00000000;
        #10 $display("Test 2 - timing=%d, match=%b", timing_out, match);
        
        // Test 3: Exact match
        #10 input_key = 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000;
        #10 $display("Test 3 - timing=%d, match=%b", timing_out, match);
        
        $finish;
    end
    
    // Clock generation
    always #5 clk = ~clk;

endmodule
