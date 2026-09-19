// 8-bit combinational Arithmetic Logic Unit
module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [3:0] opcode,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry,
    output logic       overflow
);

    logic [8:0] extended_sum;

    always_comb begin
        // Safe defaults also cover unused opcodes.
        result = 8'h00;
        carry = 1'b0;
        overflow = 1'b0;
        extended_sum = 9'h000;

        case (opcode)
            4'b0000: begin // ADD
                extended_sum = {1'b0, a} + {1'b0, b};
                result = extended_sum[7:0];
                carry = extended_sum[8];
                // Overflow occurs when same-sign inputs produce another sign.
                overflow = (~(a[7] ^ b[7])) & (result[7] ^ a[7]);
            end

            4'b0001: begin // SUB
                result = a - b;
                // For subtraction, carry is 1 when no unsigned borrow occurs.
                carry = (a >= b);
                // Overflow occurs when different-sign inputs produce a wrong sign.
                overflow = (a[7] ^ b[7]) & (result[7] ^ a[7]);
            end

            4'b0010: result = a & b; // AND
            4'b0011: result = a | b; // OR
            4'b0100: result = a ^ b; // XOR
            4'b0101: result = ~a;    // NOT

            4'b0110: begin // SHIFT LEFT
                result = a << 1;
                carry = a[7];
            end

            4'b0111: begin // SHIFT RIGHT
                result = a >> 1;
                carry = a[0];
            end

            4'b1000: result = (a == b) ? 8'h01 : 8'h00; // EQUAL
            4'b1001: result = ($signed(a) < $signed(b)) ? 8'h01 : 8'h00; // LESS THAN

            default: begin
                // Keep the safe defaults for unused opcodes.
            end
        endcase

        // The zero flag always describes the final result.
        zero = (result == 8'h00);
    end

endmodule
