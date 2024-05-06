#include <string>
#include <vector>

typedef unsigned int uint32;

class Section {
public:
    Section();

    uint32& next();

protected:

private:
    static std::hashmap<std::string, std::vector<uint32>> sections;
    std::vector<uint32> words;
    int line_count;
};
