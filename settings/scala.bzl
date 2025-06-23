load(
    "@io_bazel_rules_scala//scala:scala.bzl",
    upstream_bin = "scala_binary",
    upstream_lib = "scala_library",
    upstream_macro = "scala_macro_library",
)
load("@io_bazel_rules_scala//scala:scala_cross_version_select.bzl", "select_for_scala_version")
load(
    "@io_bazel_rules_scala//scala_proto:scala_proto.bzl",
    _scala_proto_library = "scala_proto_library",
)
load(
    "//settings:dependencies.bzl",
    _base_deps_213 = "base_deps_213",
    _base_deps_3 = "base_deps_3",
    _core_base_deps_213 = "core_base_deps_213",
    _core_base_deps_3 = "core_base_deps_3",
)

_default_scalac2_opts = [
    "-unchecked",
    "-deprecation",
    "-feature",
    "-Ywarn-unused:imports",
    "-Wvalue-discard",
    "-Ymacro-annotations",
    "-Xlint:adapted-args",
    "-Xfatal-warnings",
    "-language:existentials",
    "-language:experimental.macros",
    "-language:higherKinds",
    "-language:implicitConversions",
    "-language:postfixOps",
    "-quickfix:any",
    "-Xsource:3",
    "-Xsource-features:case-apply-copy-access,infer-override,package-prefix-implicits",
]

_default_scalac3_opts = [
    "-unchecked",
    "-deprecation",
    "-feature",
    "-Wunused:imports",
    "-Wvalue-discard",
    "-Xfatal-warnings",
    "-Xmax-inlines:128",
    "-language:existentials",
    "-language:experimental.macros",
    "-language:higherKinds",
    "-language:implicitConversions",
    "-language:postfixOps",
    "-Ykind-projector:underscores",
]

_default_scala2_plugins = []

def _scala_module_deps(modules, suffix):
    return [m + suffix for m in modules]

# Same as `scala_module` but with minimal 3d party dependency set
def scala_core_module(
        name,
        directory = None,
        deps = [],
        module_deps = [],
        macros = False,
        visibility = None,
        scala_version = None):
    core_base_deps = select_for_scala_version(
        before_3 = _core_base_deps_213,
        since_3 = _core_base_deps_3,
    )
    _scala_module_impl(name, directory, core_base_deps + deps, module_deps, macros, visibility, scala_version)

# Creates targets for scala sources of scala library using standard directory layout
# Attributes:
# - directory - base directory containing `src` directory
# - deps - compile dependencies for sources, see `scala_library`
# - module_deps - array of scala_module dependencies
#   `module_deps = ["foo"]` is equal to `deps = ["foo"]
# - macros - set to True if the library defines some macros
def scala_module(
        name,
        directory = None,
        deps = [],
        module_deps = [],
        macros = False,
        visibility = None,
        scala_version = None):
    base_deps = select_for_scala_version(
        before_3 = _base_deps_213,
        since_3 = _base_deps_3,
    )
    _scala_module_impl(name, directory, base_deps + deps, module_deps, macros, visibility, scala_version)

def _scala_module_impl(
        name,
        directory,
        deps,
        module_deps,
        macros,
        visibility,
        scala_version):
    if directory == None:
        src_directory = "src"
    else:
        src_directory = directory + "/src"
    version_dependent_srcs = select_for_scala_version(
        before_3 = native.glob([src_directory + "/main/scala-2/**/*.scala"]),
        since_3 = native.glob([src_directory + "/main/scala-3/**/*.scala"]),
    )
    main_srcs = native.glob([src_directory + "/main/scala/**/*.scala"]) + version_dependent_srcs
    main_resources = native.glob([src_directory + "/main/resources/**"])
    main_deps = deps + module_deps
    if macros:
        scala_macro_library(
            name = name,
            srcs = main_srcs,
            resources = main_resources,
            deps = main_deps,
            visibility = visibility,
            scala_version = scala_version,
        )
    else:
        scala_library(
            name = name,
            srcs = main_srcs,
            resources = main_resources,
            deps = main_deps,
            visibility = visibility,
            scala_version = scala_version,
        )

# Creates targets for scala sources of scala application using standard directory layout
# Attributes:
# - main_class - fully qualified canonical name of the main application class
# - other attributes - see `scala_module`
def scala_application(
        name,
        main_class,
        directory = None,
        deps = [],
        module_deps = [],
        visibility = None,
        scala_version = "2.13.14"):
    if directory == None:
        src_directory = "src"
    else:
        src_directory = directory + "/src"
    main_srcs = native.glob([src_directory + "/main/scala/**/*.scala"])
    main_resources = native.glob([src_directory + "/main/resources/**"])
    main_deps = select_for_scala_version(
        before_3 = _base_deps_213,
        since_3 = _base_deps_3,
    ) + deps + module_deps
    if main_srcs != [] or main_resources != []:
        scala_binary(
            name = name,
            main_class = main_class,
            srcs = main_srcs,
            resources = main_resources,
            deps = main_deps,
            visibility = visibility,
            scala_version = scala_version,
        )
    else:
        native.java_library(
            name = name,
            runtime_deps = main_deps,
            visibility = visibility,
        )

def scala_library(
        name,
        srcs = [],
        deps = [],
        resources = [],
        main_class = "",
        visibility = None,
        scala_version = None):
    scalacopts = select_for_scala_version(
        before_3 = _default_scalac2_opts,
        since_3 = _default_scalac3_opts,
    )
    plugins = select_for_scala_version(
        before_3 = _default_scala2_plugins,
        since_3 = [],
    )
    upstream_lib(
        name = name,
        srcs = srcs,
        deps = deps,
        scalacopts = scalacopts,
        resources = resources,
        plugins = plugins,
        main_class = main_class,
        visibility = visibility,
        scala_version = scala_version,
    )

def scala_macro_library(
        name,
        srcs = [],
        deps = [],
        resources = [],
        main_class = "",
        visibility = None,
        scala_version = None):
    scalacopts = select_for_scala_version(
        before_3 = _default_scalac2_opts,
        since_3 = _default_scalac3_opts,
    )
    plugins = select_for_scala_version(
        before_3 = _default_scala2_plugins,
        since_3 = [],
    )
    upstream_macro(
        name = name,
        srcs = srcs,
        deps = deps,
        scalacopts = scalacopts,
        resources = resources,
        plugins = plugins,
        main_class = main_class,
        visibility = visibility,
        scala_version = scala_version,
    )

def scala_binary(
        name,
        srcs = [],
        deps = [],
        resources = [],
        main_class = "",
        visibility = None,
        scala_version = None):
    scalacopts = select_for_scala_version(
        before_3 = _default_scalac2_opts,
        since_3 = _default_scalac3_opts,
    )
    plugins = select_for_scala_version(
        before_3 = _default_scala2_plugins,
        since_3 = [],
    )
    upstream_bin(
        name = name,
        srcs = srcs,
        deps = deps,
        scalacopts = scalacopts,
        resources = resources,
        plugins = plugins,
        main_class = main_class,
        visibility = visibility,
        scala_version = scala_version,
    )

def scala_proto_library(name, visibility, deps, **kwargs):
    _scala_proto_library(
        name = name + "_impl",
        visibility = visibility,
        deps = deps,
    )

    upstream_lib(
        name = name,
        visibility = visibility,
        deps = [":" + name + "_impl"],
        scala_version = "2.13.14",
    )
