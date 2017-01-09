#include <sstream>
#include <iostream>

#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <boost/system/system_error.hpp>

void test_serialization() {
    std::stringstream ss;
    {
        boost::archive::text_oarchive oa(ss);
        int n = 23;
        oa << n;
    }
    {
        boost::archive::text_iarchive ia(ss);
        int n;
        ia >> n;
        std::cout << n << std::endl;
    }
}
void test_system() {
    boost::system::error_code ec;
    std::cout << ec.value() << std::endl;
    std::cout << ec.message() << std::endl;
}

int main() {
    test_serialization();
    test_system();
}
