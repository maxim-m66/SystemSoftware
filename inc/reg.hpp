#ifndef RESENJE_REG_HPP
#define RESENJE_REG_HPP

#include "../inc/int_util.hpp"

class reg {
public:
    explicit reg(int value) : value(value) {}

    virtual reg &operator=(const reg &right);

    virtual reg &operator=(int value);

    bool operator==(const reg &right);

    bool operator==(int value);

    bool operator>(const reg &right);

    bool operator>(int value);

    bool operator!=(const reg &right) {
        return not(*this == right);
    }

    bool operator!=(int value) {
        return !(*this == value);
    }

    int get_value() { return this->value; }

protected:
    int value;
};

class reg0 : public reg {
public:
    reg0() : reg(0) {}

    reg0 &operator=(const reg &right) override;

    reg0 &operator=(const int value) override;
};

class register_file {
public:
    register_file(bool system);

    reg &operator[](int i);

private:
    reg **registers;
    int len;
};

#endif //RESENJE_REG_HPP
