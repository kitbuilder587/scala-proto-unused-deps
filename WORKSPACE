load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/jdk:remote_java_repository.bzl", "remote_java_repository")

# Load rules for dependency fetching from Maven
RULES_JVM_EXTERNAL_TAG = "4.5"
RULES_JVM_EXTERNAL_SHA = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)


# Install external dependencies
load("@rules_jvm_external//:defs.bzl", "artifact", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")
load("//settings:dependencies.bzl", "artifacts")

repositories = [
  "https://repo.maven.apache.org/maven2",
  "https://maven-central.storage-download.googleapis.com/maven2",
  "https://mirror.bazel.build/repo1.maven.org/maven2",
  "https://jcenter.bintray.com",
]

# Use `bazel run @unpinned_maven//:pin` to update dependencies
maven_install(
    name = "maven",
    artifacts = artifacts,
    fetch_sources = True,
    maven_install_json = "//:maven_install.json",
    repositories = repositories,
    resolve_timeout = 3600,
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

http_archive(
    name = "bazel_skylib",
    sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
    ],
)

PY_SHA="84aec9e21cc56fbc7f1335035a71c850d1b9b5cc6ff497306f84cced9a769841"
PY_VERSION="0.23.1"

http_archive(
    name = "rules_python",
    sha256 = PY_SHA,
    strip_prefix = "rules_python-{}".format(PY_VERSION),
    url = "https://github.com/bazelbuild/rules_python/releases/download/{}/rules_python-{}.tar.gz".format(PY_VERSION,PY_VERSION),
)


# See https://github.com/bazelbuild/rules_scala/releases for up to date version information.
http_archive(
    name = "io_bazel_rules_scala",
    # sha256 = "ac4181c71bd6e7ad1f564c88405c18c60e365b0f",
    strip_prefix = "rules_scala-6.6.0",
    url = "https://github.com/bazelbuild/rules_scala/releases/download/v6.6.0/rules_scala-v6.6.0.tar.gz",
)


load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")
scala213_version = "2.13.14"

scala3_version = "3.3.1"

scala_versions = [
    scala213_version,
    scala3_version,
]

scala_config(
    scala_version = scala3_version,
    scala_versions = scala_versions,
)
load("@io_bazel_rules_scala//scala:scala.bzl", "rules_scala_setup")

# loads other rules Rules Scala depends on 
rules_scala_setup()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()


load("//settings:scala_toolchains.bzl", "custom_scala_repositories", "scala_register_toolchains")

custom_scala_repositories(
    maven_servers = repositories,
)

scala_register_toolchains()
