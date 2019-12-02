

/**
*   multiargument
**/
struct pass {
template<typename ...T> pass(T...) {}
};
// ...
template<typename ...Args>
void print(Args&& ...args) {
    // std::cerr << 'argument'; //for all 'argument' in args
    pass{(std::cerr << args, 1)...};
}

/**
*   template of template
**/
template< 
    template<class> class ArgType
>
NewDeviceProperty getNewDeviceProperty(ArgType<std::string> &arg) {
}


/**
*   inheritance from std exception
**/
class BadCLArgumnets
    : public std::invalid_argument 
{
public:

    explicit BadCLArgumnets(const std::string &additionalDescription = "")
        : invalid_argument{additionalDescription}
    {}

    virtual ~BadCLArgumnets() noexcept = default;
};

// AVAILABLE by std::make_unique<>() IN C++ 14
template<typename PtrType, typename ...Args>
std::unique_ptr<PtrType> make_unique(Args&& ...args) {
    return std::unique_ptr<PtrType>(new PtrType(std::forward<Args>(args)...));
}


// USELESS IN C++ 17 (see new container function)
// TODO optimize it (perfect forward)
template<class Key, class Value, class... Args>
bool insertIfNotExisted(std::map<Key, Value> &userMap, const Key &key, Args&&... args) {
    auto pos = userMap.lower_bound(key);
    bool isNotEsisted = false;
    if (pos == userMap.end() || userMap.key_comp()(key, pos->first)) {
        userMap.emplace_hint(pos, key, args...);
        isNotEsisted = true;
    }
    return isNotEsisted;
}

// Segmentation fault catching
#include <signal.h>
void catchPosixDeathSignal(int signum) {
    LOGOUT_ERROR(std::string("Get POSIX signal SEGMENTATION FAULT. Code: ") + std::to_string(signum));
    // signal(signum, SIG_DFL); // перепосылка сигнала например
    exit(signum); //выход из программы без аварии с кодом возврата
}
// ...
int main(int argc, char** argv) {
    // ...
    signal(SIGSEGV, catchPosixDeathSignal);
    // ...

// NOTES
/** PROTOBUF
0) thrown error: basic_string assign когда байтовое поле прото записывалась set_...(void*, size) отрицательная длина
**/

//CMake
// FILE(GLOB SOURCE_MAIN ${LIB_DIR}/json/jsoncpp.cpp "src/*.cpp")
