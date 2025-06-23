# WARNING: Changes in this file will not be used by Bazel by default
# See comments in maven_install sections in WORKSPACE

load("@rules_jvm_external//:defs.bzl", "artifact")
load("@rules_jvm_external//:specs.bzl", "maven")

def library213and3(org, version, artifacts, exclusions = []):
    return library213(org, version, artifacts, exclusions) + library3(org, version, artifacts, exclusions)

def library213(org, version, artifacts, exclusions = []):
    return library(org, version, artifacts, exclusions, "_2.13")

def library3(org, version, artifacts, exclusions = []):
    return library(org, version, artifacts, exclusions, "_3")

def jlibrary(org, version, artifacts, exclusions = []):
    return library(org, version, artifacts, exclusions, "")

def library(org, version, artifacts, exclusions, postfix):
    if len(exclusions) > 0:
        return [maven.artifact(
            group = org,
            artifact = artifact + postfix,
            version = version,
            exclusions = exclusions,
        ) for artifact in artifacts]
    else:
        return [org + ":" + artifact + postfix + ":" + version for artifact in artifacts]

artifacts = (
    library213and3("co.fs2", "3.10.2", ["fs2-core", "fs2-io", "fs2-reactive-streams"])
)

fs2_213 = [
    "@maven//:co_fs2_fs2_core_2_13",
]

fs2_3 = [
    "@maven//:co_fs2_fs2_core_3",
]

core_base_deps_213 = []

core_base_deps_3 = []

base_deps_213 = core_base_deps_213
base_deps_3 = core_base_deps_3
