load("@io_bazel_rules_scala//scala:scala_cross_version_select.bzl", "select_for_scala_version")
load("//settings:scala.bzl", "scala_core_module")
load("//settings:dependencies.bzl", "fs2_213", "fs2_3")

package(
    default_visibility = ["//visibility:public"],
)

# This target is cross-built to scala 2.13 and scala 3.
# Depending on the scala version of targets depending on it.
scala_core_module(
    name = "a",
    directory = "a",
    deps = select_for_scala_version(
        before_3 = fs2_213,
        since_3 = fs2_3,
    ),
)

scala_core_module(
    name = "b",
    directory = "b",
    module_deps = ["//core:a"],
    scala_version = "2.13.14"
)

scala_core_module(
    name = "c",
    directory = "c",
    module_deps = ["//core:a"],
    scala_version = "3.3.1"
)
