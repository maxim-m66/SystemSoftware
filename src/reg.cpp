#include <iostream>
#include <iomanip>
#include "../inc/reg.hpp"

Memory *Memory::MEM = nullptr;

Memory::Memory() {
    this->data = new uint8[0xFFFFFFFF];
}

uint32 Memory::operator[](uint32 address) {
    uint32 ret = 0;
    for (int i = 0; i < 4; i++) {
        uint32 byte = this->data[address + i];
        ret |= (byte << (i * 8));
    }
    return ret;
}

void Memory::load(std::istream &in) {
    in >> std::hex;
    uint32 address;
    uint16 byte;
    std::string junk;
    while (in >> address >> junk) {
        for (int i = 0; i < 8; i++) {
            in >> byte;
            this->data[address + i] = byte;
        }
    }
}

void Memory::decode(uint32 address, uint8 *op, uint8 *mod, uint8 *ra, uint8 *rb, uint8 *rc, short *displacement) {
    *op = (this->data[address] & 0xF0) >> 4;
    *mod = this->data[address] & 0xF;
    *ra = (this->data[address + 1] & 0xF0) >> 4;
    *rb = this->data[address + 1] & 0xF;
    *rc = (this->data[address + 2] & 0xF0) >> 4;
    *displacement = ((short) (this->data[address + 2] & 0xF) << 8) | this->data[address + 3];
    if ((*displacement & 0x800) != 0) *displacement |= 0xF000;
}

void Memory::set(uint32 address, uint32 value) {
    if (address >= TERM_OUT and address <= TERM_OUT + 3) {
        std::cout << (char) value;
        return;
    }
    uint8 b0 = value & 0xFF;
    uint8 b1 = (value & 0xFF00) >> 8;
    uint8 b2 = (value & 0xFF0000) >> 16;
    uint8 b3 = (value & 0xFF000000) >> 24;
    this->data[address] = b0;
    this->data[address + 1] = b1;
    this->data[address + 2] = b2;
    this->data[address + 3] = b3;
}

Memory &Memory::get() {
    if (MEM == nullptr) {
        MEM = new Memory();
    }
    return *MEM;
}
