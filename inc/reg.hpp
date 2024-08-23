#ifndef RESENJE_REG_HPP
#define RESENJE_REG_HPP

#include "../inc/int_util.hpp"


class Memory {
public:
    static Memory &get();

    int operator[](uint32 address);

    void set(uint32 address, uint32 value);

    void load(std::istream &in);

    void decode(uint32 address, uint8 *op, uint8 *mod, uint8 *ra, uint8 *rb, uint8 *rc, short *displacement);

private:
    Memory();

    static Memory *MEM;
    uint8 *data;
};

#endif //RESENJE_REG_HPP
