#ifndef SECTION_HPP
#define SECTION_HPP

#include <unordered_map>
#include <vector>

typedef unsigned int uint32;
typedef unsigned char uint8;

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

    [[nodiscard]] int get_offset() const { return name_offset; }

    static Section *get_section(const std::string &name);

    static std::vector<Section *> &get_sections();

    static StringSection *get_strings() { return reinterpret_cast<StringSection *>(sections[".strtab"]); }

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

    Section(const std::string &name, int name_offset);

    static std::unordered_map<std::string, Section *> sections;
    std::vector<uint32> words;
    std::vector<Jump> jumps;
    std::string name;
    int line_count;
    int name_offset;
    int ascii_byte;
};

class StringSection : public Section {
public:
    void add(const std::string &);

    int size() override { return line_count; }

private:
    friend class Section;

    explicit StringSection(int name_offset);

    friend std::ostream &operator<<(std::ostream &out, const StringSection &section);
};

#endif // SECTION_HPP
