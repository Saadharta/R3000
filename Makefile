PROJECT_NAME = "Demiguel François-Etienne_VHDL"
ARCHIVE_NAME = ${PROJECT_NAME}.tgz

FLAGS = --ieee=synopsys -fexplicit
WAVE_DIR = ./simulation
CTOOLS = combinationalTools
STOOLS = sequentialTools
TBS = testbenches
all : code tests
code: comb reg reg_bank alu instr_dec alu_con cp_mux_con ext
tests: tb_dec tb_mux tb_shifter tb_reg tb_reb_bank tb_alu tb_cp_mux_con tb_ext

#Combinational tools
dec :
	ghdl -a --work=${CTOOLS} ${FLAGS} ${CTOOLS}/decoder.vhd

mux:
	ghdl -a --work=${CTOOLS} ${FLAGS} ${CTOOLS}/multiplexor.vhd

shifter:
	ghdl -a --work=${CTOOLS} ${FLAGS} ${CTOOLS}/barrel_shifter.vhd

adder:
	ghdl -a --work=${CTOOLS} ${FLAGS} ${CTOOLS}/adder.vhd

comb : dec mux shifter adder

#Sequential tools
reg:
	ghdl -a --work=${STOOLS} ${FLAGS} ${STOOLS}/parallel_register.vhd

sram:
	ghdl -a --work=${STOOLS} ${FLAGS} ${STOOLS}/sram_dps.vhd
	#ghdl -a --work=${STOOLS} ${FLAGS} ${STOOLS}/sram.vhd

seq : reg sram

#Main Components
reg_bank: comb seq
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} RegisterBank.vhd

alu: comb seq
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} ALU.vhd

instr_dec: comb seq
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} InstructionDecoder.vhd

alu_con : comb seq 
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} UALControler.vhd

cp_mux_con : comb seq
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} CpMuxControler.vhd

ext : comb seq
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} Extension.vhd

r3000: comb seq reg_bank alu instr_dec alu_con cp_mux_con ext 
	ghdl -a -P${CTOOLS} -P${STOOLS} ${FLAGS} R3000.vhd

### Testbenches
#Combinational
tb_dec : dec
	ghdl -a --work=${CTOOLS} ${FLAGS} ${TBS}/decoder_tb.vhd
	ghdl -e --work=${CTOOLS} ${FLAGS} test_decoder
	ghdl -r --work=${CTOOLS} ${FLAGS} test_decoder --wave=${WAVE_DIR}/decoder.ghw

tb_mux: mux
	ghdl -a --work=${CTOOLS} ${FLAGS} ${TBS}/multiplexor_tb.vhd
	ghdl -e --work=${CTOOLS} ${FLAGS} test_multiplexor
	ghdl -r --work=${CTOOLS} ${FLAGS} test_multiplexor --wave=${WAVE_DIR}/multiplexor.ghw

tb_shifter: shifter
	ghdl -a --work=${CTOOLS} ${FLAGS} ${TBS}/barrel_shifter_tb.vhd
	ghdl -e --work=${CTOOLS} ${FLAGS} test_barrel_shifter
	ghdl -r --work=${CTOOLS} ${FLAGS} test_barrel_shifter --wave=${WAVE_DIR}/barrel_shifter.ghw

#Sequential	
tb_reg: reg
	ghdl -a --work=${STOOLS} ${FLAGS} ${TBS}/parallel_register_tb.vhd
	ghdl -e --work=${STOOLS} ${FLAGS} test_parallel_register
	ghdl -r --work=${STOOLS} ${FLAGS} test_parallel_register --wave=${WAVE_DIR}/parallel_register.ghw

tb_sram: sram
	ghdl -a --work=${STOOLS} ${FLAGS} ${TBS}/sram_dps_tb.vhd
	ghdl -e --work=${STOOLS} ${FLAGS} test_sram_dps
	ghdl -r --work=${STOOLS} ${FLAGS} test_sram_dps --wave=${WAVE_DIR}/sram_dps.ghw

#Components
tb_reg_bank: reg_bank
	ghdl -a ${FLAGS} ${TBS}/RegisterBank_tb.vhd
	ghdl -e ${FLAGS} test_register_bank
	ghdl -r ${FLAGS} test_register_bank --wave=${WAVE_DIR}/RegisterBank.ghw

tb_alu: alu
	ghdl -a ${FLAGS} ${TBS}/ALU_tb.vhd
	ghdl -e ${FLAGS} test_alu
	ghdl -r ${FLAGS} test_alu --wave=${WAVE_DIR}/ALU.ghw

tb_instr_dec : instr_dec
	ghdl -a ${FLAGS} ${TBS}/InstructionDecoder_tb.vhd
	ghdl -e ${FLAGS} test_instruction_decoder
	ghdl -r ${FLAGS} test_instruction_decoder --wave=${WAVE_DIR}/InstructionDecoder.ghw
	
tb_alu_con : alu_con
	ghdl -a ${FLAGS} ${TBS}/UALControler_tb.vhd
	ghdl -e ${FLAGS} test_ual_controler
	ghdl -r ${FLAGS} test_ual_controler --wave=${WAVE_DIR}/UALControler.ghw

tb_cp_mux_con : cp_mux_con
	ghdl -a ${FLAGS} ${TBS}/CpMuxControler_tb.vhd
	ghdl -e ${FLAGS} test_cp_mux_controler
	ghdl -r ${FLAGS} test_cp_mux_controler --wave=${WAVE_DIR}/CpMuxControler.ghw

tb_ext : ext 
	ghdl -a ${FLAGS} ${TBS}/Extension_tb.vhd
	ghdl -e ${FLAGS} test_extension
	ghdl -r ${FLAGS} test_extension --wave=${WAVE_DIR}/Extension.ghw

tb_r3000: r3000 
	ghdl -a ${FLAGS} ${TBS}/R3000_tb.vhd
	ghdl -e ${FLAGS} test_r3000
	ghdl -r ${FLAGS} test_r3000 --wave=${WAVE_DIR}/R3000.ghw
	
	###ghdl -a ${FLAGS} ${TBS}/tb_r3000.vhd
	###ghdl -e ${FLAGS} tb_r3000
	###ghdl -r ${FLAGS} tb_r3000 --wave=${WAVE_DIR}/R3000.ghw
	
### Project management
archive: fclean
	tar zcvf ${ARCHIVE_NAME} --exclude=*.tgz *

clean :
	rm -rf *.cf

fclean: clean
	rm -rf ${WAVE_DIR}/*
	rm -rf ${ARCHIVE_NAME}

.PHONY : all code tests dec mux shifter reg sram reg_bank alu instr_dec alu_con cp_mux_con ext r3000 tb_dec tb_mux tb_shifter tb_reg tb_sram tb_reg_bank tb_alu tb_instr_dec tb_alu_con tb_cp_mux_con tb_ext tb_r3000 clean fclean 
