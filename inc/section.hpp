#ifndef SECTION_HPP
#define SECTION_HPP
#include <unordered_map>
#include <vector>

typedef unsigned int uint32;
typedef unsigned char uint8;

class Section {
public:
    uint32& next();

    static Section& get_section(const std::string& name);

    static uint32 make_word(const uint8 *nibbles);

    friend std::ostream& operator<<(std::ostream& os, const Section& section);

protected:
    explicit Section(const std::string& name);

private:
    static std::unordered_map<std::string, Section*> sections;
    std::vector<uint32> words;
    std::string name;
    int line_count;
};
#endif // SECTION_HPP
