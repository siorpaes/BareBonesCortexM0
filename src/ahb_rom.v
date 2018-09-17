module ahb_rom
(
 /* AHB Lite interface */
 input wire         HCLK,                 // AHB clock
 input wire         HSEL,                 // AHB select
 input wire  [31:0] HADDR,                // AHB address
 input wire  [ 2:0] HBURST,               // AHB burst
 input wire         HMASTLOCK,            // AHB lock
 input wire  [ 3:0] HPROT,                // AHB prot
 input wire  [ 2:0] HSIZE,                // AHB size
 input wire  [ 1:0] HTRANS,               // AHB transfer
 input wire  [31:0] HWDATA,               // AHB write data
 input wire         HWRITE,               // AHB write
 input wire         HREADY,               // AHB ready
 output wire [31:0] HRDATA,               // AHB read-data
 output wire        HRESP,                // AHB response
 output wire        HREADYOUT);           // AHB ready out


reg  [15:0] haddr_reg;
wire [31:0] rdata;


wire trans_valid = HSEL & HTRANS[1] & HREADY;

always @(posedge HCLK)
    if (trans_valid)
    haddr_reg[15:0] <= HADDR[15:0];

   assign     HREADYOUT = 1'b1;
   assign     HRDATA    = rdata;
   assign     HRESP     = 1'b0;
   
   // Make unused AHB-Lite signals obvious for Lint purposes
   wire [66:0] unused = { HBURST[2:0], HMASTLOCK,
                          HPROT[3:0], HSIZE[2:0], HTRANS[0], HWDATA[31:0],
                          HWRITE };

/**
 SEV         0xbf40
 NOP		 0xbf00
 MOV R0, R0  0x4600
 B.0		 0xe7fe
 */

assign rdata[31:0] = (haddr_reg == 16'h0000) ? 32'h20001000 :	//SP
                     (haddr_reg == 16'h0004) ? 32'h00000009 :	//PC
                     (haddr_reg == 16'h0008) ? 32'hbf404600 :
                     (haddr_reg == 16'h000c) ? 32'h46004600 :
                     (haddr_reg == 16'h0010) ? 32'hbf404600 :
                     (haddr_reg == 16'h0014) ? 32'h46004600 :
                     (haddr_reg == 16'h0018) ? 32'he7f6e7f6 : 32'hCCCCCCCC;
endmodule
