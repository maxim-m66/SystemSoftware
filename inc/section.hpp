#ifndef SECTION_HPP
#define SECTION_HPP

#include <unordered_map>
#include <vector>
#include "int_util.hpp"

class StringSection;

class Section {
public:
    virtual ~Section() = default;

    uint32 &next();

    void ascii(std::string &);

    virtual int size() { return line_count; }

    void symbolise(int index, int value, bool whole = false);

    static void set_jumps();

    [[nodiscard]] int line() const { return line_count; }

    [[nodiscard]] const std::string &get_name() const { return name; }

    static Section *get_section(const std::string &name);

    static std::vector<Section *> &get_sections();

    static uint32 make_word(uint8 *nibbles);

    static void flush(std::ostream &out);

    void new_jump( int value, const std::string &symbol) {
        this->jumps.push_back({this->line_count, value, symbol});
    }

    friend std::ostream &operator<<(std::ostream &out, const Section &section);

protected:

    struct Jump {
        int line;
        int value;
        std::string symbol;
    };

    Section(const std::string &name);

    static std::unordered_map<std::string, Section *> sections;
    static std::vector<std::string> section_order;
    std::vector<uint32> words;
    std::vector<Jump> jumps;
    std::string name;
    int line_count;
    int ascii_byte;
};

#endif // SECTION_HPP
