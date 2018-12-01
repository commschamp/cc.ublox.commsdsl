
#pragma once

#include <cstdint>
#include <limits>

namespace ublox
{

namespace frame
{

namespace checksum
{

/// @brief Checksum calculator.
/// @details Provided to @b comms::protocol::ChecksumLayer
///     when defining transport framing (@ref ublox::frame::UbloxFrame).
struct UbloxChecksum
{
    template <typename TIter>
    std::uint16_t operator()(TIter& iter, std::size_t len) const
    {
        std::uint8_t ckA = 0;
        std::uint8_t ckB = 0;
        for (auto idx = 0U; idx < len; ++idx) {
            ckA += *iter;
            ckB += ckA;
            ++iter;
        }

        return
            (static_cast<std::uint16_t>(ckB) << std::numeric_limits<std::uint8_t>::digits) |
            ckA;
    }
};

} // namespace checksum

}  // namespace frame

}  // namespace ublox


