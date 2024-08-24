#ifndef SECTION_HPP
#define SECTION_HPP

#include <unordered_map>
#include <vector>
#include "int_util.hpp"

class StringSection;

class Section {
public:
    virtual ~Section() = default;

    void next_word(uint32 word);

    void next_byte(uint8 byte);

    void ascii(std::string &);

    void symbolise(int index, int value, bool whole = false);

    static void set_jumps();

    [[nodiscard]] int line() const { return byte_count; }

    [[nodiscard]] const std::string &get_name() const { return name; }

    static Section *get_section(const std::string &name);

    static std::vector<Section *> &get_sections();

    static uint32 make_word(uint8 *nibbles);

    static void flush(std::ostream &out);

    static int number();

    static void out_obj(std::ostream &out);

    void new_jump(long value, const std::string &symbol) {
        this->jumps.push_back({this->byte_count, value, symbol});
    }

    friend std::ostream &operator<<(std::ostream &out, const Section &section);

protected:

    struct Jump {
        int line;
        long value;
        std::string symbol;
    };

    Section(const std::string &name);

    static std::unordered_map<std::string, Section *> sections;
    static std::vector<std::string> section_order;
    static int txt_called;
    std::vector<uint8> bytes;
    std::vector<Jump> jumps;
    std::string name;
    int byte_count;
};

#endif // SECTION_HPP
