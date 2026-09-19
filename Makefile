IVERILOG = iverilog
VVP = vvp
BUILD_DIR = build
SIMULATION = $(BUILD_DIR)/alu_sim

.PHONY: test clean

test:
	mkdir -p $(BUILD_DIR)
	$(IVERILOG) -g2012 -o $(SIMULATION) src/alu.sv tb/alu_tb.sv
	$(VVP) $(SIMULATION)

clean:
	rm -rf $(BUILD_DIR)
