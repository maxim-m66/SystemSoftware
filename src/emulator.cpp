#define sp 14
#define pc 15
#define status 0
#define handler 1
#define cause 2

int registers[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x40000000};

int csr[3] = {};

int MEM[0xFFFFFFFF] = {};

void decode(char *op, char *mod, char *a, char *b, char *c, short *displacement);

void emulate() {
    int temp;
    char op, mod, a, b, c;
    short displacement;
    decode(&op, &mod, &a, &b, &c, &displacement);
    switch (op) {
        case 0b0000:
            registers[0] = 0;
            return;
        case 0b0001:
            registers[sp]--;
            MEM[sp] = csr[status];
            registers[sp]--;
            MEM[sp] = registers[pc];
            csr[cause] = 4;
            csr[status] = csr[status] & ~1;
            registers[pc] = csr[handler];
            break;
        case 0b0010:
            switch (mod) {
                case 0b0000:
                    registers[sp]--;
                    MEM[sp] = registers[pc];
                    registers[pc] = registers[a] + registers[b] + displacement;
                    break;
                case 0b0001:
                    registers[sp]--;
                    MEM[sp] = registers[pc];
                    registers[pc] = MEM[registers[a] + registers[b] + displacement];
                    break;
            }
            break;
        case 0b0011:
            switch (mod) {
                case 0b0000:
                    registers[pc] = registers[a] + displacement;
                    break;
                case 0b0001:
                    if (registers[b] == registers[c]) registers[pc] = registers[a] + displacement;
                    break;
                case 0b0010:
                    if (registers[b] != registers[c]) registers[pc] = registers[a] + displacement;
                    break;
                case 0b0011:
                    if (registers[b] > registers[c]) registers[pc] = registers[a] + displacement;
                    break;
                case 0b1000:
                    registers[pc] = MEM[registers[a] + displacement];
                    break;
                case 0b1001:
                    if (registers[b] == registers[c]) registers[pc] = MEM[registers[a] + displacement];
                    break;
                case 0b1010:
                    if (registers[b] != registers[c]) registers[pc] = MEM[registers[a] + displacement];
                    break;
                case 0b1011:
                    if (registers[b] > registers[c]) registers[pc] = MEM[registers[a] + displacement];
                    break;
            }
        case 0b0100:
            temp = registers[b];
            registers[b] = registers[c];
            registers[c] = temp;
            break;
        case 0b0101:
            switch (mod) {
                case 0b0000:
                    registers[a] = registers[b] + registers[c];
                    break;
                case 0b0001:
                    registers[a] = registers[b] - registers[c];
                    break;
                case 0b0010:
                    registers[a] = registers[b] * registers[c];
                    break;
                case 0b0011:
                    registers[a] = registers[b] / registers[c];
                    break;
            }
            break;
        case 0b0110:
            switch (mod) {
                case 0b0000:
                    registers[a] = ~registers[b];
                    break;
                case 0b0001:
                    registers[a] = registers[b] & registers[c];
                    break;
                case 0b0010:
                    registers[a] = registers[b] | registers[c];
                    break;
                case 0b0011:
                    registers[a] = registers[b] ^ registers[c];
                    break;
            }
            break;
        case 0b0111:
            switch (mod) {
                case 0b0000:
                    registers[a] = registers[b] << registers[c];
                    break;
                case 0b0001:
                    registers[a] = registers[b] >> registers[c];
                    break;
            }
            break;
        case 0b1000:
            switch (mod) {
                case 0b0000:
                    MEM[registers[a] + registers[b] + displacement] = registers[c];
                    break;
                case 0b0010:
                    MEM[MEM[registers[a] + registers[b] + displacement]] = registers[c];
                    break;
                case 00001:
                    registers[a] = registers[a] + displacement;
                    MEM[registers[a]] = registers[c];
                    break;
            }
            break;
        case 0b1001:
            switch (mod) {
                case 0b0000:
                    registers[a] = csr[b];
                    break;
                case 0b0001:
                    registers[a] = registers[b] + displacement;
                    break;
                case 0b0010:
                    registers[a] = MEM[registers[b] + registers[c] + displacement];
                    break;
                case 0b0011:
                    registers[a] = MEM[registers[b]];
                    registers[b] = registers[b] + displacement;
                    break;
                case 0b0100:
                    csr[a] = registers[b];
                    break;
                case 0b0101:
                    csr[a] = csr[b] | displacement;
                    break;
                case 0b0110:
                    csr[a] = MEM[registers[b] + registers[c] + displacement];
                    break;
                case 0b0111:
                    csr[a] = MEM[registers[b]];
                    registers[b] = registers[b] + displacement;
                    break;
            }
            break;
    }
}

int main() {
    emulate();
}
