#pragma once

#include <cstdint>
#include <string>

#include <boost/program_options.hpp>

namespace cc_ublox
{

namespace simple_pos
{

class ProgramOptions
{
public:
    void parse(int argc, const char* argv[]);
    static void printHelp(std::ostream& out);

    bool helpRequested() const;
    std::string device() const;
private:
    boost::program_options::variables_map m_vm;
};

} // namespace simple_pos

} // namespace ublox
