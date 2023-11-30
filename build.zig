const std = @import("std");
const builtin = @import("builtin");
const os = builtin.os.tag;
const arch = builtin.cpu.arch;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    if (os == .linux) {
        const dir = switch (arch) {
            .x86 => "l32",
            .x86_64 => "l64",
            .aarch64 => "l64arm",
            else => @compileError("Unsupported architecture - " ++ @tagName(arch)),
        };

        const c_lib = b.addStaticLibrary(.{
            .name = "c.o",
            .root_source_file = .{ .path = b.pathFromRoot(dir ++ "/c.o") },
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        b.installArtifact(c_lib);

        const e_lib = b.addStaticLibrary(.{
            .name = "e.o",
            .root_source_file = .{ .path = b.pathFromRoot(dir ++ "/e.o") },
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        b.installArtifact(e_lib);
    }
}
