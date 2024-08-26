#ifndef RESENJE_REG_HPP
#define RESENJE_REG_HPP

#define TERM_OUT 0xFFFFFF00
#define TERM_IN 0xFFFFFF04
#define TIM_CFG 0xFFFFFF10

#include "../inc/int_util.hpp"


class Memory {
public:
    static Memory &get();

    uint32 operator[](uint32 address);

    void set(uint32 address, uint32 value);

    void load(std::istream &in);

    void decode(uint32 address, uint8 *op, uint8 *mod, uint8 *ra, uint8 *rb, uint8 *rc, short *displacement);

private:
    Memory();

    static Memory *MEM;
    uint8 *data;
};

#endif //RESENJE_REG_HPP
