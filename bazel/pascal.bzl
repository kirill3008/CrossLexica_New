"""
Bazel rules for building Pascal code with Free Pascal Compiler.
"""

def _object_file_name(basename):
    return basename + ".o"

def _binary_file_name(basename, platform, output_type):
    if output_type == "unit":
        return basename + ".ppu"
    if output_type == "library":
        if platform == "macos":
            return "lib" + basename + ".dylib"
        if platform == "linux":
            return "lib" + basename + ".so"
        if platform == "windows":
            return basename + ".dll"
        fail("unsupported platform " + platform)
    if output_type == "program":
        if platform == "windows":
            return basename + ".exe"
        return basename
    fail("unuspported type " + output_type)

def _fpc_common_impl(ctx, output_type):
    platform = ""
    executable = ""
    if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        platform = "windows"
        executable = "C:\\opt\\lazarus\\fpc\\3.2.2\\bin\\x86_64-win64\\fpc.exe"
    elif ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        platform = "linux"
        executable = "/usr/bin/fpc"
    elif ctx.target_platform_has_constraint(ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]):
        platform = "macos"
        executable = "/usr/local/bin/fpc"
    else:
        fail("Unsupported platform!")

    basename = ctx.file.src.basename.replace(".pas", "")
    object_out = ctx.actions.declare_file(_object_file_name(basename))
    main_out = ctx.actions.declare_file(_binary_file_name(basename, platform, output_type))

    arguments = []
    unit_dirs = {}
    for dep in ctx.files.deps:
        unit_dir = dep.dirname
        if not unit_dir in unit_dirs:
            arguments.append("-Fu" + unit_dir)
            unit_dirs[unit_dir] = 1
    arguments.append("-o{}".format(main_out.path))
    arguments.append(ctx.file.src.path)

    env = {}
    if output_type in ["library", "program"] and platform == "linux":
        env["PATH"] = "/usr/bin"  # needs ld to link library
    outputs = [main_out, object_out]
    ctx.actions.run(
        outputs = outputs,
        inputs = [ctx.file.src] + ctx.files.deps,
        arguments = arguments,
        executable = executable,
        env = env,
    )
    return outputs

def _fpc_unit_impl(ctx):
    outputs = _fpc_common_impl(ctx, "unit")
    return DefaultInfo(files = depset(outputs))

fpc_unit = rule(
    doc = "Creates a unit with the FPC compiler",
    implementation = _fpc_unit_impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
        "_windows_constraint": attr.label(default = Label("@platforms//os:windows")),
        "_linux_constraint": attr.label(default = Label("@platforms//os:linux")),
        "_macos_constraint": attr.label(default = Label("@platforms//os:macos")),
    },
)

def _fpc_library_impl(ctx):
    outputs = _fpc_common_impl(ctx, "library")
    return DefaultInfo(files = depset(outputs))

fpc_library = rule(
    doc = "Creates a shared library with the FPC compiler",
    implementation = _fpc_library_impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
        "_windows_constraint": attr.label(default = Label("@platforms//os:windows")),
        "_linux_constraint": attr.label(default = Label("@platforms//os:linux")),
        "_macos_constraint": attr.label(default = Label("@platforms//os:macos")),
    },
)

def _fpc_binary_impl(ctx):
    outputs = _fpc_common_impl(ctx, "program")
    return DefaultInfo(files = depset(outputs), executable = outputs[0])

fpc_binary = rule(
    doc = "Creates a program with the FPC compiler",
    implementation = _fpc_binary_impl,
    executable = True,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
        "_windows_constraint": attr.label(default = Label("@platforms//os:windows")),
        "_linux_constraint": attr.label(default = Label("@platforms//os:linux")),
        "_macos_constraint": attr.label(default = Label("@platforms//os:macos")),
    },
)
