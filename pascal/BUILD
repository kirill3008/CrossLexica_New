load("//bazel:pascal.bzl", "fpc_binary", "fpc_unit")

fpc_unit(
    name = "NOUNTHRU",
    src = "NOUNTHRU.PAS",
    deps = [
        ":CLASTABL",
    ],
)

fpc_unit(
    name = "SUBMODUL",
    src = "SUBMODUL.PAS",
)

fpc_unit(
    name = "CLASTABL",
    src = "CLASTABL.PAS",
)

fpc_unit(
    name = "INITVER4",
    src = "INITVER4.PAS",
    deps = [
        ":CLASTABL",
    ],
)

fpc_unit(
    name = "ENCODSCI",
    src = "ENCODSCI.PAS",
    deps = [
        ":CLASTABL",
        ":NOUNTHRU",
    ],
)

fpc_binary(
    name = "COORDALN",
    src = "COORDALN.PAS",
    deps = [
        ":CLASTABL",
        ":NOUNTHRU",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "STATSUB3",
    src = "STATSUB3.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCODSV",
    src = "ENCODSV.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "COSUCONT",
    src = "COSUCONT.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCOGER2",
    src = "ENCOGER2.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "DISTANT2",
    src = "DISTANT2.PAS",
    deps = [
        ":CLASTABL",
        ":NOUNTHRU",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "HYPOCOD",
    src = "HYPOCOD.PAS",
    deps = [
        ":CLASTABL",
        ":NOUNTHRU",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCPART2",
    src = "ENCPART2.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SINGMUL5",
    src = "SINGMUL5.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "COPUCONT",
    src = "COPUCONT.PAS",
    deps = [":INITVER4"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "MAGNCLAS",
    src = "MAGNCLAS.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
        ":NOUNTHRU",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "topairs",
    src = "topairs.pas",
    deps = [
        ":CLASTABL",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SYNCOD",
    src = "SYNCOD.PAS",
    deps = [
        ":INITVER4",
        ":CLASTABL",
        ":NOUNTHRU",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCODOB2",
    src = "ENCODOB2.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "CUT_EXPL",
    src = "CUT_EXPL.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCADAJV",
    src = "ENCADAJV.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "PARCOD",
    src = "PARCOD.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCODAV",
    src = "ENCODAV.PAS",
    deps = [":INITVER4"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "STATADJ",
    src = "STATADJ.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "STATVER",
    src = "STATVER.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "STATVER2",
    src = "STATVER2.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "topairs2",
    src = "topairs2.pas",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SINGMUL2",
    src = "SINGMUL2.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "LONGCLAS",
    src = "LONGCLAS.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SINGMULT",
    src = "SINGMULT.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "GETSHORT",
    src = "GETSHORT.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SINGMUL3",
    src = "SINGMUL3.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "COGECONT",
    src = "COGECONT.PAS",
    deps = [":INITVER4"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "COPACONT",
    src = "COPACONT.PAS",
    deps = [":INITVER4"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SINGMUL4",
    src = "SINGMUL4.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCODVV",
    src = "ENCODVV.PAS",
    deps = [":INITVER4"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "GETPARTI",
    src = "GETPARTI.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "totrees",
    src = "totrees.pas",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "DERICONT",
    src = "DERICONT.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
        ":NOUNTHRU",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ANTOCOD",
    src = "ANTOCOD.PAS",
    deps = [
        ":CLASTABL",
        ":INITVER4",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "totrees2",
    src = "totrees2.pas",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "ENCODNOM",
    src = "ENCODNOM.PAS",
    deps = [
        ":CLASTABL",
        ":ENCODSCI",
        ":NOUNTHRU",
    ],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "SUBJCONT",
    src = "SUBJCONT.PAS",
    deps = [":SUBMODUL"],
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "MERGEV",
    src = "MERGEV.PAS",
    visibility = ["//visibility:public"],
)

fpc_binary(
    name = "NAMESAP",
    src = "NAMESAP.PAS",
    deps = [":CLASTABL"],
    visibility = ["//visibility:public"],
)
