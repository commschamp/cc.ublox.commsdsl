#include "ProgramOptions.h"
#include <iostream>
#include <cassert>
#include <vector>

namespace po = boost::program_options;

namespace ublox
{

namespace simple_pos
{    

namespace
{

const std::string HelpStr("help");
const std::string FullHelpStr(HelpStr + ",h");
const std::string DeviceStr("device");
const std::string FullDeviceStr(DeviceStr + ",d");

#ifdef WIN32
const std::string DefaultDevStr("COM1");
#else
const std::string DefaultDevStr("/dev/ttyACM0");
#endif


po::options_description createDescription()
{
    po::options_description desc("Options");
    desc.add_options()
        (FullHelpStr.c_str(), "This help.")
        (FullDeviceStr.c_str(), po::value<std::string>()->default_value(DefaultDevStr),
            "Specify u-blox USB device.")
    ;
    return desc;
}

const po::options_description& getDescription()
{
    static const auto Desc = createDescription();
    return Desc;
}

} // namespace

void ProgramOptions::parse(int argc, const char* argv[])
{
    po::options_description allOptions;
    allOptions.add(getDescription());
    auto parseResult =
        po::command_line_parser(argc, argv)
            .options(allOptions)
            .run();
    po::store(parseResult, m_vm);
    po::notify(m_vm);
}

void ProgramOptions::printHelp(std::ostream& out)
{
    out << getDescription() << std::endl;
}

bool ProgramOptions::helpRequested() const
{
    return 0 < m_vm.count(HelpStr);
}

std::string ProgramOptions::device() const
{
    return m_vm[DeviceStr].as<std::string>();
}

} // namespace simple_pos

} // namespace ublox

