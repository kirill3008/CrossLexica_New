"""
Bazel rules for building Pascal code with Free Pascal Compiler.
"""
PascalInfo = provider(
    doc = "Pascal dependency info",
    fields = {
        "unit_dirs": "directories to search for units",
        "ppu_files": "compiled PPU files that should be available during compilation",
        "object_files": "compiled object files needed for linking",
    },
)

def _object_file_name(basename):
    return basename + ".o"

def _binary_file_name(basename, output_type):
    if output_type == "unit":
        return basename + ".ppu"
    if output_type == "library":
        return "lib" + basename + ".so"
    if output_type == "program":
        return basename
    fail("unuspported type " + output_type)

def _fpc_common_impl(ctx, output_type):
    executable = "/usr/bin/fpc"

    if ctx.file.src.basename.endswith(".pas") or ctx.file.src.basename.endswith(".PAS"):
        basename = ctx.file.src.basename[:-4]
    else:
        fail("Invalid file extension")

    object_out = ctx.actions.declare_file(_object_file_name(basename))
    main_out = ctx.actions.declare_file(_binary_file_name(basename, output_type))

    arguments = []
    all_unit_dirs = {}
    dep_dirs = {}
    ppu_files = []
    object_files = []

    for dep in ctx.attr.deps:
        if PascalInfo in dep:
            for d in dep[PascalInfo].unit_dirs:
                all_unit_dirs[d] = 1
                dep_dirs[d] = 1
            ppu_files.extend(dep[PascalInfo].ppu_files)
            object_files.extend(dep[PascalInfo].object_files)
    for dep in ctx.files.deps:
        unit_dir = dep.dirname
        if not unit_dir in all_unit_dirs:
            all_unit_dirs[unit_dir] = 1
            dep_dirs[unit_dir] = 1
        if dep.basename.endswith(".ppu") or dep.basename.endswith(".PPU"):
            ppu_files.append(dep)
        if dep.basename.endswith(".o") or dep.basename.endswith(".O"):
            object_files.append(dep)

    for unit_dir in all_unit_dirs.keys():
        arguments.append("-Fu" + unit_dir)
        arguments.append("-Fo" + unit_dir)

    arguments.append("-FE" + main_out.dirname)
    arguments.append("-Fo" + object_out.dirname)
    arguments.append("-o{}".format(main_out.path))
    arguments.append(ctx.file.src.path)
    arguments.append("-Fccp866")

    env = {}
    if output_type in ["library", "program"]:
        env["PATH"] = "/usr/bin"  # needs ld to link library
    outputs = [main_out, object_out]
    ctx.actions.run(
        outputs = outputs,
        inputs = [ctx.file.src] + ctx.files.deps + ppu_files + object_files,
        arguments = arguments,
        executable = executable,
        env = env,
    )

    current_ppu_files = []
    if output_type == "unit":
        current_ppu_files = [main_out]
    all_ppu_files = current_ppu_files + ppu_files
    all_object_files = [object_out] + object_files
    return outputs, dep_dirs, all_ppu_files, all_object_files

def _fpc_unit_impl(ctx):
    outputs, unit_dirs, ppu_files, object_files = _fpc_common_impl(ctx, "unit")
    return [
        DefaultInfo(
            files = depset(outputs),
        ),
        PascalInfo(
            unit_dirs = unit_dirs,
            ppu_files = ppu_files,
            object_files = object_files,
        ),
    ]

fpc_unit = rule(
    doc = "Creates a unit with the FPC compiler",
    implementation = _fpc_unit_impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
    },
)

def _fpc_library_impl(ctx):
    outputs, unit_dirs, ppu_files, object_files = _fpc_common_impl(ctx, "library")
    return [
        DefaultInfo(
            files = depset(outputs),
        ),
        PascalInfo(
            unit_dirs = unit_dirs,
            ppu_files = ppu_files,
            object_files = object_files,
        ),
    ]

fpc_library = rule(
    doc = "Creates a shared library with the FPC compiler",
    implementation = _fpc_library_impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
    },
)

def _fpc_binary_impl(ctx):
    outputs, unit_dirs, ppu_files, object_files = _fpc_common_impl(ctx, "program")
    return [
        DefaultInfo(
            files = depset(outputs),
            executable = outputs[0],
        ),
        PascalInfo(
            unit_dirs = unit_dirs,
            ppu_files = ppu_files,
            object_files = object_files,
        ),
    ]

fpc_binary = rule(
    doc = "Creates a program with the FPC compiler",
    implementation = _fpc_binary_impl,
    executable = True,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(),
    },
)
