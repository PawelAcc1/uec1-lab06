module fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4 // 2^4 = 16 słów głębokości
)(
    input  logic clk,
    input  logic rst_n,
    input  logic wr,
    input  logic [DATA_WIDTH-1:0] w_data,
    input  logic rd,
    output logic [DATA_WIDTH-1:0] r_data,
    output logic full,
    output logic empty
);

    // 1. Definicja pamięci (Tablica rejestrów)
    // Głębokość to 2 do potęgi ADDR_WIDTH (np. 16)
    logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

    // 2. Wskaźniki (Pointers)
    // Uwaga: Dajemy jeden bit więcej ([ADDR_WIDTH:0] zamiast [ADDR_WIDTH-1:0])
    // Ten dodatkowy bit służy do rozróżnienia stanu Pełny od Pusty,
    // gdy wskaźniki wskazują ten sam adres w pamięci.
    logic [ADDR_WIDTH:0] wr_ptr, wr_ptr_nxt;
    logic [ADDR_WIDTH:0] rd_ptr, rd_ptr_nxt;

    // --- LOGIKA SEKWENCYJNA (Rejestry) ---
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end
        else begin
            wr_ptr <= wr_ptr_nxt;
            rd_ptr <= rd_ptr_nxt;
        end
    end

    // --- LOGIKA ZAPISU DO PAMIĘCI ---
    always_ff @(posedge clk) begin
        // Piszemy tylko gdy jest sygnał WR i bufor NIE jest pełny
        if (wr && !full) begin
            // Ucinamy najstarszy bit wskaźnika, żeby dostać poprawny adres
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= w_data;
        end
    end

    // --- LOGIKA KOMBINACYJNA (Next State & Flags) ---
    always_comb begin
        // Domyślne wartości (żeby uniknąć latchy)
        wr_ptr_nxt = wr_ptr;
        rd_ptr_nxt = rd_ptr;

        // 1. Obsługa Zapisu
        if (wr && !full) begin
            wr_ptr_nxt = wr_ptr + 1'b1;
        end

        // 2. Obsługa Odczytu
        if (rd && !empty) begin
            rd_ptr_nxt = rd_ptr + 1'b1;
        end
    end

    // --- OBSŁUGA WYJŚĆ ---
    
    // Dane wyjściowe są dostępne natychmiast ("asynchroniczny odczyt" z tablicy rejestrów)
    // W FPGA to się zsyntezuje jako Distributed RAM lub rejestry.
    assign r_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // Logika flag (na podstawie dodatkowego bitu wskaźnika)
    
    // Puste: Wskaźniki są identyczne (nawet dodatkowy bit ten sam)
    assign empty = (wr_ptr == rd_ptr);
    
    // Pełne: Adresy te same, ale dodatkowy bit (MSB) jest inny
    // To oznacza, że wskaźnik zapisu "zrobił kółko" i dogonił odczyt.
    assign full  = (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) &&
                   (wr_ptr[ADDR_WIDTH]     != rd_ptr[ADDR_WIDTH]);

endmodule