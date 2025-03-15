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

pub usingnamespace @import("./structures/types.zig");
pub const Shard = @import("shard.zig");
pub const zjson = @import("json.zig");

pub const Internal = @import("internal.zig");
const GatewayDispatchEvent = Internal.GatewayDispatchEvent;
const GatewayBotInfo = Internal.GatewayBotInfo;
const Log = Internal.Log;

pub const Sharder = @import("core.zig");
const SessionOptions = Sharder.SessionOptions;

pub const FetchReq = @import("http.zig").FetchReq;
pub const FileData = @import("http.zig").FileData;

const std = @import("std");
const mem = std.mem;
const http = std.http;
const json = std.json;

const Self = @This();

allocator: mem.Allocator,
sharder: Sharder,
token: []const u8,

pub fn init(allocator: mem.Allocator) Self {
    return .{
        .allocator = allocator,
        .sharder = undefined,
        .token = undefined,
    };
}

pub fn deinit(self: *Self) void {
    self.sharder.deinit();
}

pub fn start(self: *Self, settings: struct {
    token: []const u8,
    intents: Self.Intents,
    options: struct {
        spawn_shard_delay: u64 = 5300,
        total_shards: usize = 1,
        shard_start: usize = 0,
        shard_end: usize = 1,
    },
    run: GatewayDispatchEvent(*Shard),
    log: Log,
}) !void {
    self.token = settings.token;
    var req = FetchReq.init(self.allocator, settings.token);
    defer req.deinit();

    const res = try req.makeRequest(.GET, "/gateway/bot", null);
    const body = try req.body.toOwnedSlice();
    defer self.allocator.free(body);

    // check status idk
    if (res.status != http.Status.ok) {
        std.debug.print("res not ok: {s}", .{body});
        @panic("we are cooked\n"); // check your token dumbass
    }

    const parsed = try json.parseFromSlice(GatewayBotInfo, self.allocator, body, .{});
    defer parsed.deinit();

    self.sharder = try Sharder.init(self.allocator, .{
        .token = settings.token,
        .intents = settings.intents,
        .run = settings.run,
        .options = SessionOptions{
            .info = parsed.value,
            .shard_start = settings.options.shard_start,
            .shard_end = @intCast(parsed.value.shards),
            .total_shards = @intCast(parsed.value.shards),
            .spawn_shard_delay = settings.options.spawn_shard_delay,
        },
        .log = settings.log,
    });

    try self.sharder.spawnShards();
}
