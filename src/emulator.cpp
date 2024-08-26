#include <string>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <termios.h>
#include <fcntl.h>
#include <unistd.h>
#include <unordered_map>
#include <chrono>

#include "../inc/reg.hpp"

#define sp 14
#define pc 15
#define status 0
#define handler 1
#define cause 2

#define TIMER_MASK 1
#define TERMINAL_MASK (1 << 1)
#define INTERRUPT_MASK (1 << 2)

using namespace std;

void setNonBlocking(int fd) {
    int flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

void configureTerminal(termios &oldt, termios &newt) {
    tcgetattr(STDIN_FILENO, &oldt);

    newt = oldt;

    newt.c_lflag &= ~(ICANON | ECHO);

    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
}

void restoreTerminal(const termios &oldt) {
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
}

uint32 registers[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x40000000};

int csr[3] = {0, 0, 0};

unordered_map<long, long> timer_period = {
        {0, 500000000},
        {1, 1000000000},
        {2, 1500000000},
        {3, 2000000000},
        {4, 5000000000},
        {5, 10000000000},
        {6, 30000000000},
        {7, 60000000000}
};

uint64 time_ms = 0;

bool emulation = true;

Memory &MEM = Memory::get();

void emulate() {
    char ch = getchar();
    if (ch != EOF) {
        MEM.set(TERM_IN, ch);
        csr[cause] = 3;
    }
    int temp;
    uint8 op, mod, a, b, c;
    short displacement;

    MEM.decode(registers[pc], &op, &mod, &a, &b, &c, &displacement);

//        cout << hex << (int) op << " "<<(int) mod << " "<< (int) a << " " << (int) b << " " <<(int) c << " " <<(int) displacement << " ";

    registers[pc] += 4;
    registers[0] = 0;

    switch (op) {
        case 0b0000:
            emulation = false;
            return;
        case 0b0001:
            registers[sp] -= 4;
            MEM.set(registers[sp], registers[pc]);
            registers[sp] -= 4;
            MEM.set(registers[sp], csr[status]);
            csr[cause] = 4;
            csr[status] = csr[status] & ~1;
            registers[pc] = csr[handler];
            break;
        case 0b0010:
            switch (mod) {
                case 0b0000:
                    registers[sp] -= 4;
                    MEM.set(registers[sp], registers[pc]);
                    registers[pc] = registers[a] + registers[b] + displacement;
                    break;
                case 0b0001:
                    registers[sp] -= 4;
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
            break;
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
        default:
            csr[cause] = 1;
            break;
    }
    if ((csr[cause] == 2 or csr[cause] == 3) && (csr[status] & INTERRUPT_MASK) == 0) {
        if (csr[cause] == 2 && (csr[status] & TIMER_MASK) != 0) return;
        if (csr[cause] == 3 && (csr[status] & TERMINAL_MASK) != 0) return;
        registers[sp] -= 4;
        MEM.set(registers[sp], registers[pc]);
        registers[sp] -= 4;
        MEM.set(registers[sp], registers[status]);
        csr[status] |= INTERRUPT_MASK;
        registers[pc] = csr[handler];
    }
}

int main(int argc, char **argv) {

    if (argc != 2) {
        cerr << "Invalid number of aruments provided" << std::endl;
        exit(-1);
    }

    ifstream in(argv[1]);
    if (!in.is_open()) {
        cerr << "Unable to open file " + string(argv[1]) << std::endl;
        exit(-1);
    }

    termios oldt, newt;

    configureTerminal(oldt, newt);

    setNonBlocking(STDIN_FILENO);

    MEM.load(in);

    while (emulation) {
        auto start = std::chrono::high_resolution_clock::now();
        emulate();
        auto end = std::chrono::high_resolution_clock::now();
        time_ms += std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
        if (time_ms >= timer_period[MEM[TIM_CFG]]) {
            csr[cause] = 2;
            time_ms = 0;
        }
    }
    cout << endl;
    cout << "Emulated processor executed halt instruction" << endl;
    cout << "Emulated processor state" << endl;
    for (int i = 0; i < 16; i++) {
        cout << setw(3) << setfill(' ') << "r" + to_string(i) << "=0x";
        cout << setw(8) << setfill('0') << hex << registers[i];
        if (i % 4 == 3) cout << endl;
        else cout << "   ";
    }
    restoreTerminal(oldt);
}
