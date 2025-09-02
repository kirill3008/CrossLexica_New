load("//bazel:files_processing.bzl", "process_files")

# process_files(
#     srcs = [
#         "HYPONYM.TXT",
#         "//DAS:TOOLONG.DAS",
#     ],
#     binary = "//pascal:HYPOCOD",
#     outs = [
#         "HYPONYM.COD",
#         "MAG_1.DAT",
#     ],
# )

filegroup(
    name = "OPFUNC_all",
    srcs = glob([
        "OPFUNC*.TXT",
    ]),
)

process_files(
    srcs = [
        ":OPFUNC_all",
        "//DAS:FORBASE.DAS",
    ],
    binary = "//pascal:ENCODOB2",
    outs = [
        "OPFUNC_0.LST",
        "OPFUNC.COD",
        "PREPO.LST",
        "OPFUNC_A.LST",
        "MORFCASE.LST",
        "SOBCOUNT.LST",
        "VNEXAMPL.TXT",
        "VNEXAMPL2.TXT",
        "OPFUNC00.COD",
        #all other shoul bee here
        "OPFUNC77.COD",

    ],
)
