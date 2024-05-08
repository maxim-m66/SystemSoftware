#ifndef SECTION_HPP
#define SECTION_HPP
#include <unordered_map>
#include <vector>

typedef unsigned int uint32;
typedef unsigned char uint8;

class Section {
public:
    uint32& next();

    void symbolise(int index, uint32 value);

    [[nodiscard]] int line() const { return line_count; }

    [[nodiscard]] const std::string& get_name() const { return name; }

    static std::vector<std::string>& get_extern() { return _extern; }

    static std::vector<std::string>& get_global() { return _global; }

    static Section* get_section(const std::string& name);

    static uint32 make_word(uint8* nibbles);

    friend std::ostream& operator<<(std::ostream& os, const Section& section);

protected:
    explicit Section(const std::string& name);

private:
    static std::unordered_map<std::string, Section*> sections;
    static std::vector<std::string> _extern;
    static std::vector<std::string> _global;
    std::vector<uint32> words;
    std::string name;
    int line_count;
};
#endif // SECTION_HPP
