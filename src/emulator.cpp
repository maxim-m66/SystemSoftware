#include <string>
#include <iostream>
#include <fstream>
#include <iomanip>
#include "../inc/reg.hpp"

#define sp 14
#define pc 15
#define status 0
#define handler 1
#define cause 2

int registers[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x1000000, 0000000};

int csr[3] = {};

bool emulation = true;

Memory &MEM = Memory::get();

using namespace std;

void emulate() {
    int temp;
    uint8 op, mod, a, b, c;
    short displacement;
    MEM.decode(registers[pc], &op, &mod, &a, &b, &c, &displacement);
    registers[pc] += 4;
    registers[0] = 0;
    switch (op) {
        case 0b0000:
            emulation = false;
            return;
        case 0b0001:
            registers[sp]--;
            MEM.set(registers[sp], csr[status]);
            registers[sp]--;
            MEM.set(registers[sp], registers[pc]);
            csr[cause] = 4;
            csr[status] = csr[status] & ~1;
            registers[pc] = csr[handler];
            break;
        case 0b0010:
            switch (mod) {
                case 0b0000:
                    registers[sp]--;
                    MEM.set(registers[sp], registers[pc]);
                    registers[pc] = registers[a] + registers[b] + displacement;
                    break;
                case 0b0001:
                    registers[sp]--;
                    MEM.set(registers[sp], registers[pc]);
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
                    MEM.set(registers[a] + registers[b] + displacement, registers[c]);
                    break;
                case 0b0010:
                    MEM.set(MEM[registers[a] + registers[b] + displacement], registers[c]);
                    break;
                case 00001:
                    registers[a] = registers[a] + displacement;
                    MEM.set(registers[a], registers[c]);
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

int main(int argc, char **argv) {
    if (argc != 2) {
        cerr << "Invalid number of aruments provided";
        exit(0);
    }

    ifstream in("tests/" + string(argv[1]));
    if (!in.is_open()) {
        cerr << "Unable to open file " + string(argv[1]);
        exit(0);
    }

    MEM.load(in);

    while (emulation) emulate();
    cout << "Emulated processor executed halt instruction" << endl;
    cout << "Emulated processor state" << endl;
    for (int i = 0; i < 16; i++) {
        cout << setw(3) << setfill(' ') << "r" + to_string(i) << "=0x";
        cout << setw(8) << setfill('0') << hex << registers[i];
        if (i % 4 == 3) cout << endl;
        else cout << "   ";
    }
}
