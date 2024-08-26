load("@io_bazel_rules_scala//scala:scala.bzl", "rules_scala_setup", "scala_repositories")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala//third_party/repositories:repositories.bzl", "repositories")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

def scala_register_toolchains():
    for scala_version in SCALA_VERSIONS:
        native.register_toolchains(
            "//settings:scala_toolchain" + version_suffix(scala_version),
        )


def _artifact_ids(scala_version):
    return [
        "io_bazel_rules_scala_scala_library",
        "io_bazel_rules_scala_scala_compiler",
        "io_bazel_rules_scala_scala_reflect",
        "io_bazel_rules_scala_scala_xml",
        "io_bazel_rules_scala_scala_parser_combinators",
        "org_scalameta_semanticdb_scalac",
    ] if scala_version.startswith("2") else [
        "io_bazel_rules_scala_scala_library",
        "io_bazel_rules_scala_scala_compiler",
        "io_bazel_rules_scala_scala_interfaces",
        "io_bazel_rules_scala_scala_tasty_core",
        "io_bazel_rules_scala_scala_asm",
        "io_bazel_rules_scala_scala_xml",
        "io_bazel_rules_scala_scala_parser_combinators",
        "io_bazel_rules_scala_scala_library_2",
    ]

def _rules_scala_toolchain_deps_repositories(
        maven_servers,
        fetch_sources):
    for scala_version in SCALA_VERSIONS:
        overriden_artifacts = {
            "io_bazel_rules_scala_scala_library": {
                "artifact": "org.scala-lang:scala-library:%s" % scala_version,
                "sha256": "43e0ca1583df1966eaf02f0fbddcfb3784b995dd06bfc907209347758ce4b7e3",
            },
            "io_bazel_rules_scala_scala_compiler": {
                "artifact": "org.scala-lang:scala-compiler:%s" % scala_version,
                "sha256": "17b7e1dd95900420816a3bc2788c8c7358c2a3c42899765a5c463a46bfa569a6",
            },
            "io_bazel_rules_scala_scala_reflect": {
                "artifact": "org.scala-lang:scala-reflect:%s" % scala_version,
                "sha256": "8846baaa8cf43b1b19725ab737abff145ca58d14a4d02e75d71ca8f7ca5f2926",
            },
        } if scala_version.startswith("2") else {}
        repositories(
            scala_version = scala_version,
            for_artifact_ids = _artifact_ids(scala_version),
            maven_servers = maven_servers,
            fetch_sources = fetch_sources,
            overriden_artifacts = overriden_artifacts,
            validate_scala_version = True,
        )

def custom_scala_repositories(maven_servers):
    rules_scala_setup()
    _rules_scala_toolchain_deps_repositories(
        maven_servers = maven_servers,
        fetch_sources = False,
    )
