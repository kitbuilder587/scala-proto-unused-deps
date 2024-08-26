load("@io_bazel_rules_scala//scala:providers.bzl", "declare_deps_provider")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala//scala:scala_toolchain.bzl", "scala_toolchain")
load("@io_bazel_rules_scala//scala/private:macros/setup_scala_toolchain.bzl", "setup_scala_toolchain")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

package(
    default_visibility = ["//visibility:public"],
)

[
    setup_scala_toolchain(
        name = "scala_toolchain" + version_suffix(scala_version),
        dependency_mode = "transitive",
        enable_diagnostics_report = True,
        enable_semanticdb = True,
        scala_version = scala_version,
        scalac_jvm_flags = ["-Xss1G"],
        strict_deps_mode = "off",
        unused_dependency_checker_mode = "off",
        use_argument_file_in_runner = True,
    )
    for scala_version in SCALA_VERSIONS
]
