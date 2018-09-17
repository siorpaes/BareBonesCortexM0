module barebonesCM0_top
(
    input wire i_clk,
    input wire i_reset,
    output wire o_txev,
    output wire o_lockup,
    output wire o_led,
    output wire o_clk_dbg,
    output wire [3:0] o_debug,
    
    /* SWD */
    input wire SWDCK,
    inout wire SWDIO
);


/* AHB Lite bus */
wire          HSEL;      // Device select
wire   [31:0] HADDR;     // Address
wire    [1:0] HTRANS;    // Transfer control
wire          HMASTLOCK; //
wire    [2:0] HSIZE;     // Transfer size
wire    [2:0] HBURST;    // 
wire    [3:0] HPROT;     // Protection
wire          HWRITE;    // Write control
wire   [31:0] HWDATA;    // Write data - not used
wire          HREADY;    // Transfer phase done
wire          HREADYOUT; // Device ready
wire   [31:0] HRDATA;    // Read data output
wire          HRESP;     // Device response (always OKAY)
wire          HMASTER;

wire    CODENSEQ;
wire    [2:0] CODEHINTDE;
wire    SPECHTRANS;

wire    SWCLKTCK;
wire    SWDO;
wire    SWDOEN;
wire    SWDITMS;
wire    TDO;
wire    nTDOEN;
wire    DBGRESTARTED;
wire    HALTED;

wire    TXEV;

wire    LOCKUP;
wire    SYSRESETREQ;

wire    SLEEPING;
wire    SLEEPDEEP;
wire    WAKEUP;
wire 	[33:0] WICSENSE;
wire    SLEEPHOLDACKn;
wire    WICENACK;
wire    CDBGPWRUPREQ;

/* SysTick timer signals */
wire              STCLKEN;
wire     [25:0]   STCALIB;

/* Clock divider */
reg[31:0] counter = 0;
wire clock;

always @ (posedge i_clk)
begin
	counter <= counter + 1;
end

assign clock = counter[4];

/* Top output signals */
assign o_txev = TXEV;
assign o_clk_dbg = clock;
assign o_debug = HRDATA[3:0];
assign o_lockup = LOCKUP;


/* SWD debugger */
assign SWDIO = SWDOEN ? SWDO : 1'bz; //SWD Output
assign SWDITMS = SWDIO;              //SWD Input
assign SWCLKTCK = SWDCK;             //SWD Clock

/* Unused signals */
wire unused;
assign unused = SPECHTRANS | CODENSEQ | (|CODEHINTDE) | (|WICSENSE) | HALTED; 

/* AHB decoder: ROM always selected */
assign HSEL = 1'b1;
assign HREADY = 1'b1;

/* Instantiate Cortex-M0 */
CORTEXM0INTEGRATION u_CORTEXM0INTEGRATION
(
/* Clocks and reset */
.FCLK       (clock),
.SCLK       (clock),
.HCLK       (clock),
.DCLK       (clock),
.PORESETn   (i_reset),
.DBGRESETn  (i_reset),
.HRESETn    (i_reset),
.nTRST      (i_reset),

/* AHB-Lite master port */
.HADDR      (HADDR[31:0]),
.HBURST     (HBURST[2:0]),
.HMASTLOCK  (HMASTLOCK),
.HPROT      (HPROT[3:0]),
.HSIZE      (HSIZE[2:0]),
.HTRANS     (HTRANS[1:0]),
.HWDATA     (HWDATA[31:0]),
.HWRITE     (HWRITE),
.HRDATA     (HRDATA[31:0]),
.HREADY     (HREADY),
.HRESP      (HRESP),
.HMASTER    (HMASTER),

/* Code sequentiality and speculation */
.CODENSEQ   (CODENSEQ),
.CODEHINTDE (CODEHINTDE[2:0]),
.SPECHTRANS (SPECHTRANS),

/* Debug */
.SWCLKTCK	(SWCLKTCK),
.SWDITMS    (SWDITMS),
.TDI        (1'b0),
.SWDO       (SWDO),
.SWDOEN     (SWDOEN),
.TDO        (TDO),
.nTDOEN     (nTDOEN),
.DBGRESTART (1'b0),
.DBGRESTARTED (DBGRESTARTED),
.EDBGRQ     (1'b0),
.HALTED     (HALTED),

/* Misc */
.NMI		 (1'b0),
.IRQ		 (32'h00000000),
.TXEV        (TXEV),
.RXEV		 (1'b0),
.LOCKUP      (LOCKUP),
.SYSRESETREQ (SYSRESETREQ),

/* Systick */
.STCLKEN     (STCLKEN),
.STCALIB	 (STCALIB),

.IRQLATENCY	 (8'h00),
.ECOREVNUM	 (28'haa),

/* Power management */
.SLEEPING       (SLEEPING),
.SLEEPDEEP      (SLEEPDEEP),
.WAKEUP         (WAKEUP),
.WICSENSE		(WICSENSE[33:0]),
.SLEEPHOLDREQn  (1'b1),
.SLEEPHOLDACKn  (SLEEPHOLDACKn),
.WICENREQ       (1'b0),
.WICENACK       (WICENACK),
.CDBGPWRUPREQ   (CDBGPWRUPREQ),
.CDBGPWRUPACK	(CDBGPWRUPREQ), //Wire request and ACK. See Fig. 6-7 in "CoreSight Technology System Design Guide"

/* Scan IO */
.SE             (1'b1),
.RSTBYPASS      (1'b0)
);

/* Instantiate ROM */
ahb_rom u_ahb_rom
(
.HCLK       (clock),
.HSEL       (HSEL),
.HADDR      (HADDR[31:0]),
.HBURST     (HBURST),
.HMASTLOCK  (HMASTLOCK),
.HPROT      (HPROT[3:0]),
.HSIZE      (HSIZE[2:0]),
.HTRANS     (HTRANS[1:0]),
.HWDATA     (HWDATA[31:0]),
.HWRITE     (HWRITE),
.HREADY     (HREADY),
.HRDATA     (HRDATA[31:0]),
.HRESP      (HRESP),
.HREADYOUT  (HREADYOUT)
);


/* Instantiate SysTick */
cmsdk_mcu_stclkctrl
   #(.DIV_RATIO (18'd01000))
   u_cmsdk_mcu_stclkctrl (
    .FCLK      (clock),
    .SYSRESETn (i_reset),

    .STCLKEN   (STCLKEN),
    .STCALIB   (STCALIB)
    );


/* Instantiate LED controller */
t_flipflop u_t_flipflop
(
.clk   (TXEV),
.reset (i_reset),
.q     (o_led)
);

endmodule
