//
// Copyright 2018 - 2025 (C). Alex Robenko. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

#include <cstdint>
#include <vector>
#include <string>

#include <boost/array.hpp>

#include "common/boost_wrap.h"

#include "cc_ublox/Message.h"
#include "cc_ublox/message/NavPosllh.h"
#include "cc_ublox/frame/UbloxFrame.h"

namespace cc_ublox
{

namespace simple_pos
{

class Session
{
    using InMessage =
        cc_ublox::Message<
            comms::option::ReadIterator<const std::uint8_t*>,
            comms::option::Handler<Session> // Dispatch to this object
        >;

    using OutBuffer = std::vector<std::uint8_t>;
    using OutMessage =
        cc_ublox::Message<
            comms::option::IdInfoInterface,
            comms::option::WriteIterator<std::back_insert_iterator<OutBuffer> >,
            comms::option::LengthInfoInterface
        >;

    using InNavPosllh = cc_ublox::message::NavPosllh<InMessage>;

public:
    Session(common::boost_wrap::io& io, const std::string& dev);
    ~Session();

    bool start();

    void handle(InNavPosllh& msg);

    void handle(InMessage& msg);

private:

    using AllInMessages =
        std::tuple<
            InNavPosllh
        >;

    using Frame = cc_ublox::frame::UbloxFrame<InMessage, AllInMessages>;

    using SerialPort = boost::asio::serial_port;

    void performRead();
    void processInputData();
    void sendPosPoll();
    void sendMessage(const OutMessage& msg);
    void configureUbxOutput();

    common::boost_wrap::io& m_io;
    SerialPort m_serial;
    boost::asio::deadline_timer m_pollTimer;
    std::string m_device;
    boost::array<std::uint8_t, 512> m_inputBuf;
    std::vector<std::uint8_t> m_inData;
    Frame m_frame;
};

} // namespace simple_pos

} // namespace cc_ublox
