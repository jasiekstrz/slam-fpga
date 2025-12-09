module brief_descriptor_fast #(
    parameter PATCH_SIZE = 31,
    parameter N_BITS = 256,
    parameter PIXEL_WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    
    // Line buffer inputs
    input  logic [PIXEL_WIDTH-1:0] brief_rows [0:30],
    input  logic pixel_valid,
    
    // Control
    input  logic corner_detected,
    input  logic [10:0] corner_x,
    input  logic [10:0] corner_y,
    
    // Output
    output logic [N_BITS-1:0] descriptor,
    output logic descriptor_valid,
    output logic [10:0] descriptor_x,
    output logic [10:0] descriptor_y
);

    localparam HALF_PATCH = PATCH_SIZE / 2;

    logic signed [3:0][5:0] pattern_mem [0:N_BITS-1];
    logic signed [5:0] pat_x1[0:N_BITS-1];
    logic signed [5:0] pat_y1[0:N_BITS-1];
    logic signed [5:0] pat_x2[0:N_BITS-1];
    logic signed [5:0] pat_y2[0:N_BITS-1];

    initial begin
        for(int i=0; i<N_BITS; i++) begin
            pat_x1[i] = 0; pat_y1[i] = 0;
            pat_x2[i] = 0; pat_y2[i] = 0;
        end
        pattern_mem[  0] = { 6'd10,   6'd2,   6'd6,  6'd13};
        pattern_mem[  1] = { 6'd11,  -6'd6,   6'd5,   6'd0};
        pattern_mem[  2] = {  6'd0,   6'd2,   6'd0,   6'd9};
        pattern_mem[  3] = {  6'd4,   6'd0,   6'd2,   6'd2};
        pattern_mem[  4] = {  6'd9,  -6'd1,   6'd1,  -6'd5};
        pattern_mem[  5] = {-6'd15,   6'd4,   6'd5,  -6'd4};
        pattern_mem[  6] = { 6'd14,  -6'd9,   6'd0,  -6'd1};
        pattern_mem[  7] = {  6'd9,   6'd9,   6'd0,   6'd2};
        pattern_mem[  8] = { -6'd5, -6'd12,  -6'd2,   6'd0};
        pattern_mem[  9] = {  6'd7,   6'd7,  -6'd2,  -6'd1};
        pattern_mem[ 10] = { -6'd6,  -6'd8, -6'd10,  6'd12};
        pattern_mem[ 11] = { -6'd3,  -6'd2,  -6'd7,   6'd4};
        pattern_mem[ 12] = {-6'd10,  -6'd1,  -6'd5,   6'd2};
        pattern_mem[ 13] = { -6'd3,  -6'd7,   6'd0,   6'd2};
        pattern_mem[ 14] = {  6'd0,   6'd1,  -6'd3,  -6'd2};
        pattern_mem[ 15] = { -6'd4,  -6'd2,  -6'd5, -6'd10};
        pattern_mem[ 16] = {  6'd1,  -6'd2, -6'd10,   6'd2};
        pattern_mem[ 17] = { -6'd5,   6'd0,   6'd4,   6'd0};
        pattern_mem[ 18] = {  6'd7,  -6'd7,   6'd2,  -6'd4};
        pattern_mem[ 19] = { -6'd5,  -6'd3,  -6'd1,   6'd0};
        pattern_mem[ 20] = { -6'd7,   6'd5,   6'd2,  -6'd9};
        pattern_mem[ 21] = {  6'd9,  6'd11,   6'd7,  -6'd1};
        pattern_mem[ 22] = { -6'd6,   6'd6,  -6'd2,   6'd7};
        pattern_mem[ 23] = {  6'd1,   6'd6,   6'd2,   6'd4};
        pattern_mem[ 24] = {  6'd0,  6'd11,   6'd0,   6'd2};
        pattern_mem[ 25] = { 6'd11,  -6'd8,  -6'd7,   6'd6};
        pattern_mem[ 26] = { -6'd7,  6'd12,  -6'd2,  -6'd4};
        pattern_mem[ 27] = { 6'd11,   6'd9,  6'd11,   6'd5};
        pattern_mem[ 28] = { -6'd5,  6'd11,  -6'd1,   6'd4};
        pattern_mem[ 29] = {  6'd5,   6'd0,   6'd3,   6'd5};
        pattern_mem[ 30] = {  6'd2,  -6'd6,   6'd1,   6'd8};
        pattern_mem[ 31] = { -6'd4,   6'd0,  -6'd2,  6'd11};
        pattern_mem[ 32] = {  6'd4,   6'd2,  -6'd4,   6'd3};
        pattern_mem[ 33] = { -6'd4,   6'd0,  -6'd3,   6'd4};
        pattern_mem[ 34] = {  6'd3,  -6'd1,   6'd2,  -6'd6};
        pattern_mem[ 35] = { -6'd9,   6'd2,   6'd1,   6'd3};
        pattern_mem[ 36] = { 6'd14,   6'd5,  -6'd5,   6'd6};
        pattern_mem[ 37] = { -6'd8,  -6'd2,   6'd0,  6'd10};
        pattern_mem[ 38] = { -6'd4,  -6'd5,   6'd0,  -6'd4};
        pattern_mem[ 39] = {  6'd6,  -6'd6,  -6'd7,  -6'd2};
        pattern_mem[ 40] = { -6'd3,  6'd11,   6'd5,   6'd0};
        pattern_mem[ 41] = { -6'd7,   6'd5,  -6'd6,  -6'd9};
        pattern_mem[ 42] = {  6'd7,   6'd1,   6'd5,   6'd1};
        pattern_mem[ 43] = {  6'd5,  -6'd4,  -6'd6,   6'd4};
        pattern_mem[ 44] = { -6'd4,  -6'd4,  -6'd2,   6'd0};
        pattern_mem[ 45] = { -6'd2,  -6'd8,  -6'd3, -6'd13};
        pattern_mem[ 46] = {  6'd3,  -6'd9,  -6'd6,   6'd0};
        pattern_mem[ 47] = { -6'd4,   6'd9,  -6'd8,   6'd1};
        pattern_mem[ 48] = {  6'd0,  -6'd7,   6'd3,  -6'd1};
        pattern_mem[ 49] = {  6'd4,   6'd5,  6'd13,   6'd8};
        pattern_mem[ 50] = { -6'd2,  -6'd1,   6'd6,   6'd4};
        pattern_mem[ 51] = {  6'd3, -6'd10,   6'd0,  -6'd4};
        pattern_mem[ 52] = {  6'd1,   6'd0,   6'd5,   6'd1};
        pattern_mem[ 53] = {  6'd4,  -6'd2,  -6'd5,  -6'd2};
        pattern_mem[ 54] = {  6'd0,   6'd2,  6'd14,   6'd0};
        pattern_mem[ 55] = { -6'd5,  -6'd2,  -6'd2,   6'd2};
        pattern_mem[ 56] = { -6'd9,   6'd0,   6'd0,   6'd1};
        pattern_mem[ 57] = { -6'd3,  -6'd1,  -6'd8,  -6'd3};
        pattern_mem[ 58] = { -6'd3,   6'd2,  -6'd7,   6'd4};
        pattern_mem[ 59] = {  6'd9, -6'd12,   6'd2,   6'd4};
        pattern_mem[ 60] = { -6'd3,  -6'd2,   6'd0,  -6'd1};
        pattern_mem[ 61] = { -6'd1, -6'd10,   6'd7,   6'd6};
        pattern_mem[ 62] = { -6'd5,  -6'd9,   6'd3,  -6'd3};
        pattern_mem[ 63] = {  6'd0,  -6'd1,   6'd4,   6'd4};
        pattern_mem[ 64] = { -6'd4,  -6'd8,  -6'd9,   6'd3};
        pattern_mem[ 65] = { -6'd7,  -6'd3,  -6'd3,   6'd0};
        pattern_mem[ 66] = {-6'd12,   6'd1,   6'd3,   6'd0};
        pattern_mem[ 67] = { -6'd1,   6'd0,   6'd2, -6'd15};
        pattern_mem[ 68] = { 6'd12,   6'd2,  -6'd4,  -6'd2};
        pattern_mem[ 69] = {  6'd3,   6'd0, -6'd12,  6'd12};
        pattern_mem[ 70] = {  6'd0,   6'd6,  -6'd4,   6'd9};
        pattern_mem[ 71] = {  6'd1,   6'd3,  -6'd6,   6'd7};
        pattern_mem[ 72] = {  6'd4,   6'd8,  -6'd3,  -6'd2};
        pattern_mem[ 73] = { 6'd14,  -6'd6,   6'd0,   6'd7};
        pattern_mem[ 74] = {  6'd0,   6'd3,  -6'd2,   6'd2};
        pattern_mem[ 75] = { -6'd8,  6'd10,   6'd0,  -6'd4};
        pattern_mem[ 76] = {  6'd4,  -6'd2,  -6'd8,  -6'd8};
        pattern_mem[ 77] = {  6'd4,   6'd0,   6'd0,   6'd6};
        pattern_mem[ 78] = { -6'd6,  -6'd4,  -6'd2,   6'd0};
        pattern_mem[ 79] = {  6'd0,  -6'd1,   6'd0,   6'd0};
        pattern_mem[ 80] = { -6'd4,  -6'd5,   6'd1,  -6'd5};
        pattern_mem[ 81] = { -6'd7,  -6'd1,   6'd0,  6'd13};
        pattern_mem[ 82] = { -6'd4,   6'd5,   6'd4,  -6'd7};
        pattern_mem[ 83] = {  6'd4,  -6'd7, -6'd15,   6'd3};
        pattern_mem[ 84] = {-6'd10,   6'd2,  -6'd4,  6'd10};
        pattern_mem[ 85] = {  6'd6,  -6'd2,  -6'd4,  -6'd7};
        pattern_mem[ 86] = { -6'd2,  -6'd1,  -6'd2,   6'd0};
        pattern_mem[ 87] = {  6'd3,   6'd2,  -6'd4,  -6'd8};
        pattern_mem[ 88] = {  6'd8,  -6'd4,  -6'd4,  -6'd3};
        pattern_mem[ 89] = {-6'd11,  -6'd2,  -6'd2,   6'd3};
        pattern_mem[ 90] = {  6'd4,   6'd0,   6'd5,   6'd2};
        pattern_mem[ 91] = {  6'd0,   6'd0,  -6'd1,  -6'd2};
        pattern_mem[ 92] = { -6'd1,  -6'd6,   6'd1,  -6'd6};
        pattern_mem[ 93] = {  6'd5,  -6'd1,   6'd0,   6'd3};
        pattern_mem[ 94] = {  6'd3,  -6'd9,  -6'd1,   6'd5};
        pattern_mem[ 95] = {-6'd10,   6'd2, -6'd13,  -6'd6};
        pattern_mem[ 96] = {  6'd0, -6'd10,  -6'd6,  -6'd9};
        pattern_mem[ 97] = { 6'd10,   6'd1,   6'd3,  -6'd1};
        pattern_mem[ 98] = { -6'd2, -6'd10,  -6'd1,  -6'd4};
        pattern_mem[ 99] = {  6'd5,   6'd7,   6'd9,   6'd5};
        pattern_mem[100] = { -6'd3,  -6'd6,   6'd4,   6'd2};
        pattern_mem[101] = {-6'd10,   6'd2,   6'd5,   6'd0};
        pattern_mem[102] = { -6'd1,  -6'd5,  -6'd8,   6'd4};
        pattern_mem[103] = { -6'd1,  -6'd1,  6'd10,   6'd4};
        pattern_mem[104] = {  6'd2,   6'd0,   6'd9,  6'd10};
        pattern_mem[105] = {  6'd5,   6'd3, -6'd12,   6'd0};
        pattern_mem[106] = {  6'd0,   6'd0,   6'd5, -6'd15};
        pattern_mem[107] = { -6'd3,   6'd1,  -6'd2,  -6'd8};
        pattern_mem[108] = {  6'd5,   6'd1,  -6'd6,   6'd1};
        pattern_mem[109] = {  6'd5,   6'd0,   6'd4,   6'd0};
        pattern_mem[110] = { -6'd2,  -6'd7,   6'd0,   6'd1};
        pattern_mem[111] = {  6'd5,   6'd0,   6'd2,  -6'd5};
        pattern_mem[112] = { -6'd4,   6'd0,  -6'd6,   6'd5};
        pattern_mem[113] = {  6'd2,   6'd1,   6'd2,  6'd12};
        pattern_mem[114] = { -6'd2, -6'd13,   6'd1,   6'd0};
        pattern_mem[115] = { -6'd3,  -6'd6,  -6'd2,   6'd1};
        pattern_mem[116] = { -6'd3,  6'd14,  -6'd5,  -6'd4};
        pattern_mem[117] = {-6'd14,   6'd1, -6'd12,  -6'd3};
        pattern_mem[118] = { -6'd1,  -6'd4,  6'd10,   6'd6};
        pattern_mem[119] = {  6'd8,  -6'd5,   6'd6,   6'd3};
        pattern_mem[120] = {  6'd4,   6'd6,  -6'd5,  -6'd2};
        pattern_mem[121] = {  6'd5, -6'd15,   6'd9,   6'd3};
        pattern_mem[122] = {  6'd0,   6'd1,  -6'd6,  -6'd2};
        pattern_mem[123] = {  6'd6,   6'd8,  6'd15,   6'd0};
        pattern_mem[124] = { -6'd4,  -6'd3,  -6'd6,   6'd0};
        pattern_mem[125] = {  6'd2,   6'd0,   6'd6,  -6'd1};
        pattern_mem[126] = { -6'd2,  -6'd3, -6'd10,  -6'd9};
        pattern_mem[127] = { -6'd7,   6'd8,   6'd5,   6'd8};
        pattern_mem[128] = { -6'd8, -6'd12,  -6'd4,   6'd1};
        pattern_mem[129] = {  6'd3,   6'd6,   6'd1,  6'd10};
        pattern_mem[130] = { -6'd1,  -6'd5, -6'd10,  -6'd5};
        pattern_mem[131] = {  6'd1,  -6'd5,   6'd5,   6'd8};
        pattern_mem[132] = {-6'd14,   6'd5, -6'd13,   6'd2};
        pattern_mem[133] = {  6'd7,   6'd0,  -6'd7,  -6'd3};
        pattern_mem[134] = { -6'd1,  -6'd1,  -6'd1,   6'd0};
        pattern_mem[135] = {  6'd1,  -6'd7,  -6'd1,   6'd9};
        pattern_mem[136] = { -6'd2,  -6'd2,   6'd6, -6'd15};
        pattern_mem[137] = {  6'd7,  -6'd3,   6'd1,   6'd0};
        pattern_mem[138] = {  6'd5,  -6'd1,  -6'd4,   6'd8};
        pattern_mem[139] = {-6'd14,   6'd0,  -6'd8,  -6'd4};
        pattern_mem[140] = { 6'd12,   6'd0,   6'd1, -6'd11};
        pattern_mem[141] = { -6'd4,   6'd1,   6'd2,   6'd3};
        pattern_mem[142] = {  6'd0,   6'd3,   6'd2, -6'd11};
        pattern_mem[143] = {  6'd0,   6'd4,   6'd3,  -6'd2};
        pattern_mem[144] = { -6'd4,  -6'd6,   6'd0,   6'd7};
        pattern_mem[145] = {-6'd12,  -6'd4,  -6'd7,   6'd4};
        pattern_mem[146] = { -6'd3,  -6'd2,  -6'd1,   6'd2};
        pattern_mem[147] = { -6'd2, -6'd15,   6'd3,   6'd2};
        pattern_mem[148] = { -6'd1,  -6'd6,   6'd2,   6'd2};
        pattern_mem[149] = { -6'd2,  -6'd1,  -6'd5,  -6'd1};
        pattern_mem[150] = { -6'd9,   6'd2,  -6'd5,   6'd1};
        pattern_mem[151] = { -6'd8,  -6'd3,   6'd0, -6'd10};
        pattern_mem[152] = {  6'd0,  -6'd2, -6'd10,  -6'd8};
        pattern_mem[153] = {  6'd3,   6'd5,   6'd0,   6'd2};
        pattern_mem[154] = {  6'd1,   6'd2,   6'd7,  -6'd9};
        pattern_mem[155] = {  6'd4,  -6'd2,  -6'd1,  -6'd1};
        pattern_mem[156] = { -6'd2,  -6'd7,   6'd1,  6'd10};
        pattern_mem[157] = {  6'd0,   6'd0,  -6'd4,   6'd0};
        pattern_mem[158] = {  6'd2,  -6'd2,  -6'd2,   6'd2};
        pattern_mem[159] = { -6'd5,   6'd1,   6'd5,   6'd8};
        pattern_mem[160] = {  6'd0,   6'd8,   6'd6,  -6'd6};
        pattern_mem[161] = { -6'd7,  -6'd1,   6'd6,   6'd0};
        pattern_mem[162] = { -6'd3,   6'd9,   6'd1, -6'd14};
        pattern_mem[163] = {  6'd1,   6'd3,   6'd1,   6'd2};
        pattern_mem[164] = {  6'd0,  -6'd8,  -6'd2,  -6'd5};
        pattern_mem[165] = { -6'd5,  -6'd7,   6'd2,   6'd0};
        pattern_mem[166] = { -6'd2,  -6'd4,   6'd0,   6'd6};
        pattern_mem[167] = {-6'd12,   6'd2,  -6'd3, -6'd11};
        pattern_mem[168] = {-6'd12,  -6'd5,   6'd1,   6'd2};
        pattern_mem[169] = { -6'd5,   6'd6,   6'd8,   6'd2};
        pattern_mem[170] = { -6'd3,   6'd6,   6'd4,   6'd5};
        pattern_mem[171] = { -6'd4, -6'd15,  6'd13,  -6'd9};
        pattern_mem[172] = {  6'd0,  6'd14,   6'd2,   6'd5};
        pattern_mem[173] = { -6'd9, -6'd11,  -6'd3,   6'd6};
        pattern_mem[174] = { -6'd2,  -6'd4,   6'd1,   6'd6};
        pattern_mem[175] = { -6'd8,  -6'd7,  -6'd4,   6'd6};
        pattern_mem[176] = {  6'd1,  6'd13,   6'd5,   6'd0};
        pattern_mem[177] = {  6'd7,   6'd1,  -6'd4,   6'd4};
        pattern_mem[178] = { -6'd4,  -6'd1,   6'd8,   6'd0};
        pattern_mem[179] = { -6'd4,  -6'd2,   6'd6,  -6'd3};
        pattern_mem[180] = { -6'd2,  -6'd3,   6'd1,  -6'd2};
        pattern_mem[181] = { -6'd9,  -6'd5,  -6'd5,   6'd7};
        pattern_mem[182] = {  6'd5,   6'd3,  -6'd3,  -6'd5};
        pattern_mem[183] = { -6'd3,  -6'd6,  6'd15, -6'd13};
        pattern_mem[184] = {  6'd3,  -6'd7,   6'd0,  -6'd6};
        pattern_mem[185] = { -6'd7,  -6'd7,  6'd10,   6'd0};
        pattern_mem[186] = { -6'd4,   6'd3,   6'd0,   6'd4};
        pattern_mem[187] = {-6'd11,   6'd1,   6'd4, -6'd10};
        pattern_mem[188] = {  6'd2,  6'd10,   6'd0,   6'd5};
        pattern_mem[189] = {  6'd4,  -6'd4,   6'd0,  -6'd9};
        pattern_mem[190] = { -6'd2,   6'd1,   6'd4,   6'd0};
        pattern_mem[191] = {  6'd4,  -6'd6,   6'd0,   6'd0};
        pattern_mem[192] = { 6'd11,  -6'd1,  -6'd3,   6'd0};
        pattern_mem[193] = { -6'd5,   6'd1,  -6'd2, -6'd11};
        pattern_mem[194] = {  6'd0,  -6'd1, -6'd10,   6'd0};
        pattern_mem[195] = {  6'd9,   6'd3,   6'd3,  -6'd8};
        pattern_mem[196] = {  6'd2,   6'd0,   6'd3,   6'd2};
        pattern_mem[197] = { -6'd8,   6'd0,  -6'd4,   6'd0};
        pattern_mem[198] = { -6'd5,   6'd8,  -6'd5,  -6'd5};
        pattern_mem[199] = {  6'd0,  -6'd6,  -6'd2,  -6'd5};
        pattern_mem[200] = {  6'd8,   6'd4,   6'd0,  -6'd2};
        pattern_mem[201] = {  6'd5,   6'd2,   6'd3,   6'd0};
        pattern_mem[202] = {-6'd10,   6'd0,  -6'd3,   6'd3};
        pattern_mem[203] = {  6'd6,  -6'd4,   6'd2,  6'd10};
        pattern_mem[204] = { -6'd4,  6'd10,  -6'd5,   6'd0};
        pattern_mem[205] = {  6'd0,   6'd0,  -6'd5,  -6'd3};
        pattern_mem[206] = { -6'd4,   6'd2,   6'd2,  6'd13};
        pattern_mem[207] = {  6'd8,  -6'd3,   6'd2,   6'd6};
        pattern_mem[208] = {  6'd0,   6'd0,   6'd0,   6'd5};
        pattern_mem[209] = { -6'd5,  -6'd2,   6'd2,   6'd1};
        pattern_mem[210] = {  6'd1,  -6'd2,   6'd6,  6'd13};
        pattern_mem[211] = {  6'd2,  -6'd1,   6'd4,  -6'd3};
        pattern_mem[212] = { -6'd4,   6'd0, -6'd15,  -6'd7};
        pattern_mem[213] = { -6'd2,  -6'd8,  -6'd6,  -6'd2};
        pattern_mem[214] = {-6'd10,  -6'd2,  -6'd3,   6'd0};
        pattern_mem[215] = {  6'd7,   6'd1,   6'd0,   6'd0};
        pattern_mem[216] = {  6'd1,  -6'd6,   6'd0,   6'd1};
        pattern_mem[217] = { -6'd8,   6'd5,   6'd6,  -6'd3};
        pattern_mem[218] = { -6'd1,  -6'd5,   6'd4,  -6'd6};
        pattern_mem[219] = { -6'd1,  -6'd5,   6'd0, -6'd11};
        pattern_mem[220] = {  6'd8,  -6'd5,   6'd0,  -6'd1};
        pattern_mem[221] = { -6'd4,  -6'd5,   6'd5,  -6'd3};
        pattern_mem[222] = {  6'd1,  -6'd4,  -6'd4,   6'd2};
        pattern_mem[223] = {  6'd5,  -6'd1,  -6'd8,  6'd12};
        pattern_mem[224] = { -6'd5,  -6'd9,  6'd15,  -6'd2};
        pattern_mem[225] = { -6'd9,  -6'd4,   6'd2,   6'd1};
        pattern_mem[226] = { -6'd5,  6'd11,  -6'd3,  -6'd7};
        pattern_mem[227] = {  6'd5,   6'd8,  -6'd5,  -6'd8};
        pattern_mem[228] = {  6'd6, -6'd12,  -6'd7,   6'd5};
        pattern_mem[229] = {  6'd0,  -6'd1,   6'd2,   6'd0};
        pattern_mem[230] = { -6'd8,   6'd7,   6'd8,   6'd1};
        pattern_mem[231] = {  6'd0,  6'd14,  -6'd1,  -6'd1};
        pattern_mem[232] = {  6'd2,   6'd9,   6'd9,  -6'd1};
        pattern_mem[233] = {  6'd1,  -6'd8,  -6'd1,  -6'd5};
        pattern_mem[234] = { -6'd6,  6'd10,  -6'd4,  -6'd3};
        pattern_mem[235] = {  6'd2,   6'd8,   6'd2,  6'd15};
        pattern_mem[236] = {  6'd0,   6'd1,   6'd1,   6'd8};
        pattern_mem[237] = {  6'd3,   6'd0,  -6'd5,   6'd1};
        pattern_mem[238] = {  6'd8,  -6'd2,   6'd3,   6'd1};
        pattern_mem[239] = {  6'd5,  -6'd4,  6'd14,  -6'd7};
        pattern_mem[240] = { -6'd2,   6'd5,   6'd1,   6'd5};
        pattern_mem[241] = { -6'd3,   6'd0,   6'd0,   6'd9};
        pattern_mem[242] = {  6'd4,   6'd4,  -6'd4,   6'd6};
        pattern_mem[243] = {  6'd1,   6'd8,  6'd12,  -6'd1};
        pattern_mem[244] = { -6'd2,  -6'd5,   6'd0,  -6'd2};
        pattern_mem[245] = {  6'd2,   6'd0,  -6'd2,   6'd6};
        pattern_mem[246] = { -6'd5,   6'd2,  -6'd2,   6'd4};
        pattern_mem[247] = {  6'd8,  -6'd1,   6'd2,   6'd1};
        pattern_mem[248] = { -6'd4,   6'd1,   6'd1,   6'd2};
        pattern_mem[249] = { -6'd1,   6'd0,  -6'd7,  -6'd2};
        pattern_mem[250] = {  6'd3,   6'd5,  -6'd2,   6'd0};
        pattern_mem[251] = {  6'd1,   6'd1,   6'd3, -6'd11};
        pattern_mem[252] = {  6'd0,   6'd1,  -6'd6,  6'd10};
        pattern_mem[253] = {  6'd1,   6'd9,  -6'd4,  -6'd5};
        pattern_mem[254] = {  6'd1, -6'd10,   6'd1,   6'd0};
        pattern_mem[255] = {  6'd6,   6'd4,  -6'd2,  -6'd6};
        for(int i=0; i<N_BITS; i++) begin
            {pat_x1[i], pat_y1[i], pat_x2[i], pat_y2[i]} = pattern_mem[i];
        end
    end

    logic [7:0] taps [0:30][0:30]; 

    genvar r, c, b;
    generate
        for (r = 0; r < 31; r++) begin : rows
            for (b = 0; b < 8; b++) begin : bits
                logic [30:0] shift_reg; 
                
                always_ff @(posedge clk) begin
                    if (pixel_valid) begin
                        shift_reg <= {shift_reg[29:0], brief_rows[r][b]};
                    end
                end
                
                for (c = 0; c < 31; c++) begin : cols
                    assign taps[r][c][b] = shift_reg[30-c];
                end
            end
        end
    endgenerate
    
    logic [N_BITS-1:0] next_descriptor;
    
    always_comb begin
        next_descriptor = 0;

        for (int i = 0; i < N_BITS; i++) begin
            int p1_row, p1_col_idx;
            int p2_row, p2_col_idx;
            logic [PIXEL_WIDTH-1:0] pix1, pix2;

            p1_row = HALF_PATCH + pat_y1[i];
            p1_col_idx = HALF_PATCH + pat_x1[i]; 
            
            p2_row = HALF_PATCH + pat_y2[i];
            p2_col_idx = HALF_PATCH + pat_x2[i];

            pix1 = taps[p1_row][p1_col_idx];
            pix2 = taps[p2_row][p2_col_idx];

            next_descriptor[i] = (pix1 > pix2);
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            descriptor_valid <= 0;
            descriptor <= 0;
            descriptor_x <= 0;
            descriptor_y <= 0;
        end else begin
            descriptor_valid <= corner_detected;
            
            if (corner_detected) begin
                descriptor <= next_descriptor;
                descriptor_x <= corner_x; 
                descriptor_y <= corner_y;
            end
        end
    end

endmodule
