`timescale 1ns/1ps

module alu_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic [3:0] opcode;
    logic [7:0] result;
    logic       zero;
    logic       carry;
    logic       overflow;

    integer failures;

    alu dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    task automatic check_operation(
        input string      test_name,
        input logic [3:0] test_opcode,
        input logic [7:0] test_a,
        input logic [7:0] test_b,
        input logic [7:0] expected_result,
        input logic       expected_zero,
        input logic       expected_carry,
        input logic       expected_overflow
    );
        begin
            a = test_a;
            b = test_b;
            opcode = test_opcode;
            #1;

            if ((result !== expected_result) ||
                (zero !== expected_zero) ||
                (carry !== expected_carry) ||
                (overflow !== expected_overflow)) begin
                failures = failures + 1;
                $display("FAIL: %s", test_name);
                $display("  opcode: %b", test_opcode);
                $display("  input a: %h", test_a);
                $display("  input b: %h", test_b);
                $display("  expected result: %h", expected_result);
                $display("  actual result:   %h", result);
                $display("  expected flags (zero carry overflow): %b%b%b",
                         expected_zero, expected_carry, expected_overflow);
                $display("  actual flags   (zero carry overflow): %b%b%b",
                         zero, carry, overflow);
            end else begin
                $display("PASS: %s", test_name);
            end
        end
    endtask

    initial begin
        failures = 0;

        check_operation("normal addition",       4'b0000, 8'h14, 8'h22, 8'h36, 1'b0, 1'b0, 1'b0);
        check_operation("addition producing carry", 4'b0000, 8'hF0, 8'h30, 8'h20, 1'b0, 1'b1, 1'b0);
        check_operation("addition with signed overflow", 4'b0000, 8'h7F, 8'h01, 8'h80, 1'b0, 1'b0, 1'b1);

        check_operation("normal subtraction",    4'b0001, 8'h35, 8'h12, 8'h23, 1'b0, 1'b1, 1'b0);
        check_operation("subtraction resulting in zero", 4'b0001, 8'h44, 8'h44, 8'h00, 1'b1, 1'b1, 1'b0);
        check_operation("subtraction with signed overflow", 4'b0001, 8'h80, 8'h01, 8'h7F, 1'b0, 1'b1, 1'b1);

        check_operation("AND",                    4'b0010, 8'hAA, 8'h0F, 8'h0A, 1'b0, 1'b0, 1'b0);
        check_operation("OR",                     4'b0011, 8'hA0, 8'h0F, 8'hAF, 1'b0, 1'b0, 1'b0);
        check_operation("XOR",                    4'b0100, 8'hFF, 8'h0F, 8'hF0, 1'b0, 1'b0, 1'b0);
        check_operation("NOT",                    4'b0101, 8'h55, 8'h00, 8'hAA, 1'b0, 1'b0, 1'b0);
        check_operation("shift left",             4'b0110, 8'h81, 8'h00, 8'h02, 1'b0, 1'b1, 1'b0);
        check_operation("shift right",            4'b0111, 8'h81, 8'h00, 8'h40, 1'b0, 1'b1, 1'b0);

        check_operation("equal values",           4'b1000, 8'h3C, 8'h3C, 8'h01, 1'b0, 1'b0, 1'b0);
        check_operation("different values",       4'b1000, 8'h3C, 8'h3D, 8'h00, 1'b1, 1'b0, 1'b0);
        check_operation("signed less-than",       4'b1001, 8'h03, 8'h05, 8'h01, 1'b0, 1'b0, 1'b0);
        check_operation("signed comparison negative", 4'b1001, 8'hFF, 8'h01, 8'h01, 1'b0, 1'b0, 1'b0);

        check_operation("zero flag",               4'b0010, 8'h00, 8'hFF, 8'h00, 1'b1, 1'b0, 1'b0);
        check_operation("carry flag",              4'b0000, 8'hFF, 8'h01, 8'h00, 1'b1, 1'b1, 1'b0);
        check_operation("overflow flag",           4'b0001, 8'h80, 8'h01, 8'h7F, 1'b0, 1'b1, 1'b1);
        check_operation("unused opcode defaults",  4'b1111, 8'hAA, 8'h55, 8'h00, 1'b1, 1'b0, 1'b0);

        if (failures == 0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $fatal(1, "%0d test(s) failed", failures);
        end

        $finish;
    end

endmodule
