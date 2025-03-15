//! ISC License
//!
//! Copyright (c) 2024-2025 Yuzu
//!
//! Permission to use, copy, modify, and/or distribute this software for any
//! purpose with or without fee is hereby granted, provided that the above
//! copyright notice and this permission notice appear in all copies.
//!
//! THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
//! REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
//! AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
//! INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
//! LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
//! OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
//! PERFORMANCE OF THIS SOFTWARE.

const GatewayDispatchEventNames = @import("shared.zig").GatewayDispatchEventNames;

pub usingnamespace @import("shared.zig");
pub usingnamespace @import("partial.zig");
pub usingnamespace @import("snowflake.zig");
pub usingnamespace @import("events.zig");

pub usingnamespace @import("application.zig");
pub usingnamespace @import("attachment.zig");
pub usingnamespace @import("auditlog.zig");
pub usingnamespace @import("automod.zig");
pub usingnamespace @import("channel.zig");
pub usingnamespace @import("command.zig");
pub usingnamespace @import("component.zig");
pub usingnamespace @import("embed.zig");
pub usingnamespace @import("emoji.zig");
pub usingnamespace @import("gateway.zig");
pub usingnamespace @import("guild.zig");
pub usingnamespace @import("integration.zig");
pub usingnamespace @import("integration.zig");
pub usingnamespace @import("interaction.zig");
pub usingnamespace @import("invite.zig");
pub usingnamespace @import("member.zig");
pub usingnamespace @import("message.zig");
pub usingnamespace @import("monetization.zig");
pub usingnamespace @import("oauth.zig");
pub usingnamespace @import("poll.zig");
pub usingnamespace @import("role.zig");
pub usingnamespace @import("scheduled_event.zig");
pub usingnamespace @import("sticker.zig");
pub usingnamespace @import("team.zig");
pub usingnamespace @import("thread.zig");
pub usingnamespace @import("user.zig");
pub usingnamespace @import("webhook.zig");

/// https://discord.com/developers/docs/topics/gateway#payloads-gateway-payload-structure
pub fn GatewayPayload(comptime T: type) type {
    return struct {
        /// opcode for the payload
        op: isize,
        /// Event data
        d: ?T,
        /// Sequence isize, used for resuming sessions and heartbeats
        s: ?isize,
        /// The event name for this payload
        t: ?[]const u8,
        // t: ?GatewayDispatchEventNames,
    };
}
