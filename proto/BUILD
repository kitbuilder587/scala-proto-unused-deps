load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")
load("@rules_proto//proto:defs.bzl", "proto_library")
load("//settings:scala.bzl", "scala_proto_library")

proto_library(
    name = "messages_proto",
    srcs = ["messages.proto"],
    visibility = ["//visibility:public"],
)

# one ScalaPB target per Scala version you care about
scala_proto_library(
    name = "messages_pb",
    visibility = ["//visibility:public"],
    deps = [":messages_proto"],
)
