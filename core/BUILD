load("@io_bazel_rules_scala//scala:scala_cross_version_select.bzl", "select_for_scala_version")
load("//settings:dependencies.bzl", "fs2_213", "fs2_3")
load("//settings:scala.bzl", "scala_core_module")

package(
    default_visibility = ["//visibility:public"],
)

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
    scala_version = "2.13.14",
    deps = ["//proto:messages_pb"],
)

scala_core_module(
    name = "c",
    directory = "c",
    module_deps = ["//core:a"],
    scala_version = "3.3.1",
    deps = ["//proto:messages_pb"],
)
