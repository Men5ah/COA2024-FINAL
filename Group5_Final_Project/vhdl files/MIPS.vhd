library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use IEEE.NUMERIC_STD.ALL;

entity MIPS is
    port (
        clk, reset: in std_logic;
        pc_out: out std_logic_vector(31 downto 0);
        alu_result: out std_logic_vector(31 downto 0)
    );
end MIPS;

architecture Behavioral of MIPS is

    signal pc_current: std_logic_vector(31 downto 0);
    signal pc_next, pc2: std_logic_vector(31 downto 0);
    signal instr: std_logic_vector(31 downto 0);
    signal alu_op: std_logic_vector(2 downto 0);  -- Changed to 3-bit vector
    signal jump, branch, branch_l, branch_g, mem_read, mem_write, alu_src, reg_write, reg_dst, mem_to_reg: std_logic;
    signal reg_write_dest: std_logic_vector(4 downto 0);
    signal reg_write_data: std_logic_vector(31 downto 0);
    signal reg_read_addr_1: std_logic_vector(4 downto 0);
    signal reg_read_data_1: std_logic_vector(31 downto 0);
    signal reg_read_addr_2: std_logic_vector(4 downto 0);
    signal reg_read_data_2: std_logic_vector(31 downto 0);
    signal sign_ext_im, read_data2: std_logic_vector(31 downto 0);
    signal ALU_Control: std_logic_vector(2 downto 0);
    signal ALU_out: std_logic_vector(31 downto 0);
    signal zero_flag, sign_flag: std_logic;
    signal PC_j, PC_branch, PC_4branch, PC_4beqj: std_logic_vector(31 downto 0);
    signal mem_read_data: std_logic_vector(31 downto 0);
    signal f1: std_logic;

        component InstructionMemory
        port (
            inst_add: in std_logic_vector(31 downto 0);
            instruction: out std_logic_vector(31 downto 0)
        );
    end component;
    signal instruction: std_logic_vector(31 downto 0);

    component controlunit
        port (
            opcode: in std_logic_vector(5 downto 0);
            reset: in std_logic;
            alu_op: out std_logic_vector(2 downto 0);  -- Updated to 3-bit vector
            reg_dst, mem_to_reg, jump, branch, branch_g, branch_l, mem_read, mem_write, alu_src, reg_write: out std_logic
        );
    end component;

    component controlALU
        port(
            ALU_Control: out std_logic_vector(2 downto 0);
            ALUOp: in std_logic_vector(2 downto 0);
            ALU_Funct: in std_logic_vector(5 downto 0)
        );
    end component;

    component registerFile 
        port (
            clk, rst: in std_logic;
            reg_write_en: in std_logic;
            reg_write_dest: in std_logic_vector(4 downto 0);
            reg_write_data: in std_logic_vector(31 downto 0);
            reg_read_addr_1: in std_logic_vector(4 downto 0);
            reg_read_data_1: out std_logic_vector(31 downto 0);
            reg_read_addr_2: in std_logic_vector(4 downto 0);
            reg_read_data_2: out std_logic_vector(31 downto 0)
        );
    end component;

    component ALU 
        port ( 
            inp_a: in std_logic_vector(31 downto 0);
            inp_b: in std_logic_vector(31 downto 0);
            alu_control: in std_logic_vector(2 downto 0);
            alu_result: out std_logic_vector(31 downto 0);
            zero_flag, sign_flag: out std_logic
        );
    end component;

    component Sram
        generic(
            width: integer := 32; -- word
            depth: integer := 8; -- number of locations
            dataaddr: integer := 3
        );
        port(
            clk: in std_logic;
            Read: in std_logic;
            Write: in std_logic;
            Addr: in std_logic_vector(dataaddr - 1 downto 0); -- 3
            Data_in: in std_logic_vector(width - 1 downto 0); -- 32
            Data_out: out std_logic_vector(width - 1 downto 0) -- 32
        );
    end component;

begin
    -- PC of the MIPS Processor in VHDL
    process(clk, reset)
    begin 
        if(reset = '1') then
            pc_current <= (others => '0');
        elsif(rising_edge(clk)) then
            pc_current <= pc_next;
        end if;
    end process;

    -- PC + 1 
    pc2 <= std_logic_vector(unsigned(pc_current) + 1);

    -- Instruction memory of the MIPS Processor in VHDL
    Instruction_Memory: InstructionMemory
        port map (
            inst_add => pc_current,
            instruction => instr
        );

    -- Control unit of the MIPS Processor in VHDL
    control: controlunit
        port map (
            reset => reset,
            opcode => instr(31 downto 26),
            reg_dst => reg_dst,
            mem_to_reg => mem_to_reg,
            alu_op => alu_op,
            jump => jump,
            branch => branch,
            branch_g => branch_g,
            branch_l => branch_l,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            reg_write => reg_write
        );

    -- Multiplexer regdest
    reg_write_dest <= 
        instr(15 downto 11) when reg_dst = '1' else
        instr(20 downto 16);

    -- Register file instantiation of the MIPS Processor in VHDL
    reg_read_addr_1 <= instr(25 downto 21);
    reg_read_addr_2 <= instr(20 downto 16);
    register_file: registerFile
        port map (
            clk => clk,
            rst => reset,
            reg_write_en => reg_write,
            reg_write_dest => reg_write_dest,
            reg_write_data => reg_write_data,
            reg_read_addr_1 => reg_read_addr_1,
            reg_read_data_1 => reg_read_data_1,
            reg_read_addr_2 => reg_read_addr_2,
            reg_read_data_2 => reg_read_data_2
        );

    -- Sign extend to 32 bits
    sign_ext_im <= std_logic_vector(resize(signed(instr(15 downto 0)), 32));

    -- ALU control unit of the MIPS Processor in VHDL
    ALUControl: controlALU 
        port map (
            ALUOp => alu_op,
            ALU_Funct => instr(5 downto 0),
            ALU_Control => ALU_Control
        );

    -- Multiplexer alu_src
    read_data2 <= sign_ext_im when alu_src = '1' else reg_read_data_2;

    -- ALU unit of the MIPS Processor in VHDL
    aalu: ALU
        port map (
            inp_a => reg_read_data_1,
            inp_b => read_data2,
            alu_control => ALU_Control,
            alu_result => ALU_out,
            zero_flag => zero_flag,
            sign_flag => sign_flag
        );

    -- PC beq 
    PC_branch <= std_logic_vector(resize(signed(sign_ext_im(15 downto 0)), 32));

    -- PC_beq: branch - beq, branch_g - branch if greater, branch_l - branch if less
    f1 <= ((branch and zero_flag) or (branch_g and (not sign_flag)) or (branch_l and sign_flag));
    PC_4branch <= PC_branch when f1 = '1' else pc2;

    -- PC_j 
    PC_j <= sign_ext_im;

    -- PC_4beqj
    PC_4beqj <= PC_j when jump = '1' else PC_4branch;

    -- PC_next
    pc_next <= PC_4beqj;

    -- Data memory of the MIPS Processor in VHDL
    ssram: Sram 
        generic map (
            width => 32,
            depth => 8,
            dataaddr => 3
        )
        port map (
            clk => clk,
            Addr => ALU_out(2 downto 0),
            Data_in => reg_read_data_2,
            Write => mem_write,
            Read => mem_read,
            Data_out => mem_read_data
        );

    -- Write back of the MIPS Processor in VHDL
    reg_write_data <= mem_read_data when (mem_to_reg = '1') else ALU_out;

    -- Output
    pc_out <= pc_current;
    alu_result <= ALU_out;

end Behavioral;