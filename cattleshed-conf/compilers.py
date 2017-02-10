# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import json
import os
import glob
from collections import defaultdict


def merge(*args):
    result = {}
    for dic in args:
        result.update(dic)
    return result


def script_path():
    return os.path.dirname(os.path.realpath(__file__))


def build_path():
    return os.path.join(script_path(), '..', 'build')


def data_path():
    return os.path.join(script_path(), '..', 'wandbox')


# [(<boost-version>, <compiler>-head)]
def get_boost_head_versions():
    lines = open(os.path.join(build_path(), 'boost-head', 'VERSIONS')).readlines()
    return [tuple(line.split()) for line in lines if len(line.strip()) != 0]


# [(<boost-version>, <compiler>, <compiler-version>)]
def get_boost_versions():
    lines = open(os.path.join(build_path(), 'boost', 'VERSIONS')).readlines()
    return [tuple(line.split()) for line in lines if len(line.strip()) != 0]


# [(<boost-version>, <compiler>, <compiler-version>)]
def get_boost_versions_with_head():
    return get_boost_versions() + [(bv,) + tuple(c.split('-')) for bv, c in get_boost_head_versions()]


def read_versions(name):
    lines = open(os.path.join(build_path(), name, 'VERSIONS')).readlines()
    return [line.strip() for line in lines if len(line) != 0]


def get_generic_versions(name, with_head):
    lines = read_versions(name)
    head = ['head'] if with_head else []
    return head + lines


# foo-1.23.4
def compare(a, b):
    name_a, version_a = a.split('-')
    name_b, version_b = b.split('-')
    n = cmp(name_a, name_b)
    if n != 0:
        return n
    return compare_version(version_a, version_b)


# 1.23.4
def compare_version(a, b):
    # 'head' is greater than others.
    if a == 'head' and b == 'head':
        return 0
    if a == 'head' and b != 'head':
        return 1
    if a != 'head' and b == 'head':
        return -1

    xs = [int(v) for v in a.split('.')]
    ys = [int(v) for v in b.split('.')]
    return cmp(xs, ys)


def cmpver(a, op, b):
    if op == '<':
        return compare_version(a, b) < 0
    if op == '>':
        return compare_version(a, b) > 0
    if op == '<=':
        return compare_version(a, b) <= 0
    if op == '>=':
        return compare_version(a, b) >= 0
    if op == '==':
        return compare_version(a, b) == 0
    raise Exception('unknown operation: {op}'.format(op=op))


def sort(versions, reverse=False):
    return sorted(versions, cmp=compare, reverse=reverse)


def sort_version(versions, reverse=False):
    return sorted(versions, cmp=compare_version, reverse=reverse)


def format_value(value, **kwargs):
    if isinstance(value, unicode):
        return value.format(**kwargs)
    elif isinstance(value, list):
        return [format_value(v, **kwargs) for v in value]
    elif isinstance(value, dict):
        return {format_value(k, **kwargs): format_value(v, **kwargs) for k, v in value.iteritems()}
    elif isinstance(value, tuple):
        return tuple(format_value(v, **kwargs) for v in value)
    else:
        return value


class Switches(object):
    def resolve_conflicts(self, pairs):
        conflicts = [p[0] for p in pairs]
        return [(p[0], merge(p[1], { 'conflicts': conflicts })) for p in pairs]

    def make_c(self):
        pairs = [
            ('c89', {
                'flags': ['-std=c89'],
                'display-name': 'C89',
            }),
            ('gnu89', {
                'flags': ['-std=gnu89'],
                'display-name': 'C89(GNU)',
            }),
            ('c99', {
                'flags': ['-std=c99'],
                'display-name': 'C99',
            }),
            ('gnu99', {
                'flags': ['-std=gnu99'],
                'display-name': 'C99(GNU)',
            }),
            ('c1x', {
                'flags': ['-std=c1x'],
                'display-name': 'C11',
            }),
            ('gnu1x', {
                'flags': ['-std=gnu1x'],
                'display-name': 'C11(GNU)',
            }),
            ('c11', {
                'flags': ['-std=c11'],
                'display-name': 'C11',
            }),
            ('gnu11', {
                'flags': ['-std=gnu11'],
                'display-name': 'C11(GNU)',
            }),
        ]
        return self.resolve_conflicts(pairs)

    def make_cxx(self):
        pairs = [
            ('c++98', {
                'flags': ['-std=c++98'],
                'display-name': 'C++03',
            }),
            ('gnu++98', {
                'flags': '-std=gnu++98',
                'display-name': 'C++03(GNU)',
            }),
            ('c++0x', {
                'flags': ['-std=c++0x'],
                'display-name': 'C++0x',
            }),
            ('gnu++0x', {
                'flags': '-std=gnu++0x',
                'display-name': 'C++0x(GNU)',
            }),
            ('c++11', {
                'flags': ['-std=c++11'],
                'display-name': 'C++11',
            }),
            ('gnu++11', {
                'flags': '-std=gnu++11',
                'display-name': 'C++11(GNU)',
            }),
            ('c++1y', {
                'flags': ['-std=c++1y'],
                'display-name': 'C++1y',
            }),
            ('gnu++1y', {
                'flags': '-std=gnu++1y',
                'display-name': 'C++1y(GNU)',
            }),
            ('c++14', {
                'flags': ['-std=c++14'],
                'display-name': 'C++14',
            }),
            ('gnu++14', {
                'flags': '-std=gnu++14',
                'display-name': 'C++14(GNU)',
            }),
            ('c++1z', {
                'flags': ['-std=c++1z'],
                'display-name': 'C++1z',
            }),
            ('gnu++1z', {
                'flags': '-std=gnu++1z',
                'display-name': 'C++1z(GNU)',
            }),
        ]
        return self.resolve_conflicts(pairs)

    def make_boost(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        gcc_vers = sort_version(get_generic_versions('gcc', with_head=True))
        clang_vers = sort_version(get_generic_versions('clang', with_head=True))
        compiler_vers = [('gcc', v) for v in gcc_vers] + [('clang', v) for v in clang_vers]

        boost_ver_set = set(get_boost_versions_with_head())
        boost_libs = {}
        for bv in boost_vers:
            for c, cv in compiler_vers:
                if (bv, c, cv) not in boost_ver_set:
                    continue
                path = os.path.join(data_path(), 'boost-{bv}/{c}-{cv}/lib/libboost_*.so'.format(**locals()))
                path2 = os.path.join(data_path(), 'boost-{bv}/{c}-{cv}/lib/libboost_*.a'.format(**locals()))
                libs = sorted(os.path.splitext(os.path.basename(a))[0] for a in glob.glob(path) + glob.glob(path2))
                boost_libs[(bv, c, cv)] = libs

        result = []
        for c, cv in compiler_vers:
            pairs = format_value([
                ('boost-nothing-{c}-{cv}', {
                    'flags': [],
                    'display-name': "Don't Use Boost",
                    'display-flags': '',
                }),
            ], c=c, cv=cv)
            for bv in boost_vers:
                if (bv, c, cv) not in boost_ver_set:
                    continue

                libs = ['-l' + lib[3:] for lib in boost_libs[(bv, c, cv)]]

                # clang-3.3, clang-3.4 needs `-lsupc++` after `-lboost_*` for a compile error like:
                #   /opt/wandbox/boost-1.63.0/clang-3.3/lib/libboost_locale.so: undefined reference to `typeinfo for wchar_t'
                if c == 'clang':
                    if cmpver(cv, '==', '3.3') or cmpver(cv, '==', '3.4'):
                        libs += ['-lsupc++']

                pairs.append(format_value(('boost-{bv}-{c}-{cv}', {
                    'flags': [
                        '-I/opt/wandbox/boost-{bv}/{c}-{cv}/include',
                        '-L/opt/wandbox/boost-{bv}/{c}-{cv}/lib',
                        '-Wl,-rpath,/opt/wandbox/boost-{bv}/{c}-{cv}/lib'] + libs,
                    'display-name': 'Boost {bv}',
                    'display-flags': '-I/opt/wandbox/boost-{bv}/{c}-{cv}/include',
                }), bv=bv, c=c, cv=cv))
            result.append(self.resolve_conflicts(pairs))
        return merge(*result)

    def make_boost_header(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        gcc_vers = sort_version(get_generic_versions('gcc', with_head=True))
        clang_vers = sort_version(get_generic_versions('clang', with_head=True))
        compiler_vers = [('gcc', v) for v in gcc_vers] + [('clang', v) for v in clang_vers]

        boost_ver_set = set(get_boost_versions_with_head())
        result = []
        for c, cv in compiler_vers:
            pairs = format_value([
                ('boost-nothing-{c}-{cv}-header', {
                    'flags': [],
                    'display-name': "Don't Use Boost",
                    'display-flags': '',
                    'runtime': True,
                }),
            ], c=c, cv=cv)
            for bv in boost_vers:
                if (bv, c, cv) not in boost_ver_set:
                    continue

                pairs.append(format_value(('boost-{bv}-{c}-{cv}-header', {
                    'flags': ['-I/opt/wandbox/boost-{bv}/{c}-{cv}/include'],
                    'display-name': 'Boost {bv}',
                    'display-flags': '-I/opt/wandbox/boost-{bv}/{c}-{cv}/include',
                    'runtime': True,
                }), bv=bv, c=c, cv=cv))
            result.append(self.resolve_conflicts(pairs))
        return merge(*result)

    def make_pedantic(self):
        pairs = [
            ('cpp-no-pedantic', {
                'flags': [],
                'display-name': 'no pedantic',
                'display-flags': '',
            }),
            ('cpp-pedantic', {
                'flags': ['-pedantic'],
                'display-name': '-pedantic',
                'display-flags': '-pedantic',
            }),
            ('cpp-pedantic-errors', {
                'flags': ['-pedantic-errors'],
                'display-name': '-pedantic-errors',
                'display-flags': '-pedantic-errors',
            }),
        ]
        return self.resolve_conflicts(pairs)

    def make_default(self):
        return {
            'sprout': {
                'flags': ['-I/opt/wandbox/sprout'],
                'display-name': 'Sprout',
                'display-flags': '-I/opt/wandbox/sprout',
            },
            'msgpack': {
                'flags': ['-I/opt/wandbox/msgpack-c/include'],
                'display-name': 'MessagePack',
                'display-flags': '-I/opt/wandbox/msgpack/include',
            },
            'warning': {
                'flags': ['-Wall', '-Wextra'],
                'display-name': 'Warnings',
            },
            'oldgcc-warning': {
                'flags': ['-Wall', '-W'],
                'display-name': 'Warnings',
            },
            'optimize': {
                'flags': ['-O2', '-march=native'],
                'display-name': 'Optimization',
            },
            'mono-optimize': {
                'flags': '-optimize',
                'display-name': 'Optimization',
            },
            'cpp-verbose': {
                'flags': ['-v'],
                'display-name': 'Verbose',
            },
            'cpp-p': {
                'flags': ['-P'],
                'display-name': '-P',
                'runtime': True,
            },
            'haskell-warning': {
                'flags': '-Wall',
                'display-name': 'Warnings',
            },
            'haskell-optimize': {
                'flags': '-O2',
                'display-name': 'Optimization',
            },
        }

    def make(self):
        return merge(
            self.make_default(),
            self.make_pedantic(),
            self.make_boost(),
            self.make_boost_header(),
            self.make_c(),
            self.make_cxx())

class Compilers(object):
    def make_gcc_c(self):
        gcc_vers = sort_version(get_generic_versions('gcc', with_head=True), reverse=True)

        compilers = []
        for cv in gcc_vers:
            switches = []
            initial_checked = []

            # default
            if cmpver(cv, '>=', '4.5.4'):
                switches += ['warning']
                initial_checked += ['warning']
            else:
                switches += ['oldgcc-warning']
                initial_checked += ['oldgcc-warning']
            switches += ["optimize", "cpp-verbose"]

            # C
            switches += ['c89', 'gnu89', 'c99', 'gnu99']
            if cmpver(cv, '==', '4.6.4'):
                switches += ['c1x', 'gnu1x']
            if cmpver(cv, '>=', '4.7.3'):
                switches += ['c11', 'gnu11']
            initial_checked += [switches[-1]]

            # pedantic
            if cmpver(cv, '>=', '4.5.4'):
                switches += ["cpp-no-pedantic", "cpp-pedantic", "cpp-pedantic-errors"]

            # head specific
            if cv == 'head':
                display_name = 'gcc HEAD'
                version_command = ["/bin/sh", "-c", "/opt/wandbox/gcc-head/bin/gcc --version | head -1 | cut -d' ' -f3-"]
            else:
                display_name = 'gcc'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'gcc-{cv}-c',
                'compile-command': [
                    '/opt/wandbox/gcc-{cv}/bin/gcc',
                    '-oprog.exe',
                    '-Wl,-rpath,/opt/wandbox/gcc-{cv}/lib64',
                    'prog.c'
                ],
                'version-command': version_command,
                'display-name': display_name,
                'display-compile-command': 'gcc prog.c',
                'language': 'C',
                'output-file': 'prog.c',
                'run-command': './prog.exe',
                'displayable': True,
                'compiler-option-raw': True,
                'switches': switches,
                'initial-checked': initial_checked,
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_gcc(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        gcc_vers = sort_version(get_generic_versions('gcc', with_head=True), reverse=True)

        boost_ver_set = set(get_boost_versions_with_head())
        # boost versions
        boost_switches = {}
        for cv in gcc_vers:
            xs = []
            for bv in boost_vers:
                if (bv, 'gcc', cv) not in boost_ver_set:
                    continue
                xs.append('{bv}'.format(bv=bv))
            nothing = ['boost-nothing-gcc-{cv}'.format(cv=cv)]
            boost_switches[cv] = nothing + ['boost-{x}-gcc-{cv}'.format(x=x, cv=cv) for x in sort_version(xs)]

        compilers = []
        for cv in gcc_vers:
            switches = []
            initial_checked = []

            # default
            if cmpver(cv, '>=', '4.5.4'):
                switches += ['warning']
                initial_checked += ['warning']
            else:
                switches += ['oldgcc-warning']
                initial_checked += ['oldgcc-warning']
            switches += ["optimize", "cpp-verbose"]

            # boost
            if cv in boost_switches:
                bs = boost_switches[cv]
                switches += bs
                initial_checked += [bs[-1]]

            # libs
            if cmpver(cv, '>=', '4.5.4'):
                switches += ['sprout', 'msgpack']

            # C++
            switches += ["c++98", "gnu++98"]
            if cmpver(cv, '>=', '4.7.0'):
                switches += ['c++11', 'gnu++11']
            else:
                switches += ['c++0x', 'gnu++0x']
            if cmpver(cv, '>=', '4.8.0'):
                if cmpver(cv, '>=', '5.2.0'):
                    switches += ['c++14', 'gnu++14']
                else:
                    switches += ['c++1y', 'gnu++1y']
            if cmpver(cv, '>=', '5.1.0'):
                switches += ['c++1z', 'gnu++1z']
            initial_checked += [switches[-1]]

            # pedantic
            if cmpver(cv, '>=', '4.5.4'):
                switches += ["cpp-no-pedantic", "cpp-pedantic", "cpp-pedantic-errors"]

            # head specific
            if cv == 'head':
                display_name = 'gcc HEAD'
                version_command = ["/bin/sh", "-c", "/opt/wandbox/gcc-head/bin/g++ --version | head -1 | cut -d' ' -f3-"]
            else:
                display_name = 'gcc'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'gcc-{cv}',
                'compile-command': [
                    '/opt/wandbox/gcc-{cv}/bin/g++',
                    '-oprog.exe',
                    '-Wl,-rpath,/opt/wandbox/gcc-{cv}/lib64',
                    '-lpthread',
                    '-I/opt/wandbox/boost-sml/include',
                    '-I/opt/wandbox/range-v3/include',
                    'prog.cc'
                ],
                'version-command': version_command,
                'display-name': display_name,
                'display-compile-command': 'g++ prog.cc',
                'language': 'C++',
                'output-file': 'prog.cc',
                'run-command': './prog.exe',
                'displayable': True,
                'compiler-option-raw': True,
                'switches': switches,
                'initial-checked': initial_checked,
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_clang_c(self):
        clang_vers = sort_version(get_generic_versions('clang', with_head=True), reverse=True)

        compilers = []
        for cv in clang_vers:
            switches = []
            initial_checked = []

            # default
            switches += ['warning', 'optimize', 'cpp-verbose']
            initial_checked += ['warning']

            # C
            switches += ['c89', 'gnu89', 'c99', 'gnu99', 'c11', 'gnu11']
            initial_checked += [switches[-1]]

            # pedantic
            switches += ['cpp-no-pedantic', 'cpp-pedantic', 'cpp-pedantic-errors']

            # -fansi-escape-codes
            if cmpver(cv, '>=', '3.4'):
                ansi_escape_codes = ['-fansi-escape-codes']
            else:
                ansi_escape_codes = []

            # compile-command
            compile_command = [
                '/opt/wandbox/clang-{cv}/bin/clang',
                '-oprog.exe',
                '-fcolor-diagnostics'
                ] + ansi_escape_codes + [
                'prog.c'
            ]

            # head specific
            if cv == 'head':
                display_name = 'clang HEAD'
                version_command = ["/bin/sh", "-c", "/opt/wandbox/clang-{cv}/bin/clang --version | head -1 | cut -d' ' -f3-"]
            else:
                display_name = 'clang'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'clang-{cv}-c',
                'compile-command': compile_command,
                'version-command': version_command,
                'display-name': display_name,
                'display-compile-command': 'clang prog.c',
                'language': 'C',
                'output-file': 'prog.c',
                'run-command': './prog.exe',
                'displayable': True,
                'compiler-option-raw': True,
                'switches': switches,
                'initial-checked': initial_checked,
                'jail-name': 'melpon2-default',
            }, cv=cv))

        return compilers

    def make_clang(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        clang_vers = sort_version(get_generic_versions('clang', with_head=True), reverse=True)

        boost_ver_set = set(get_boost_versions_with_head())
        # boost versions
        boost_switches = {}
        for cv in clang_vers:
            xs = []
            for bv in boost_vers:
                if (bv, 'clang', cv) not in boost_ver_set:
                    continue
                xs.append('{bv}'.format(bv=bv))
            nothing = ['boost-nothing-clang-{cv}'.format(cv=cv)]
            boost_switches[cv] = nothing + ['boost-{x}-clang-{cv}'.format(x=x, cv=cv) for x in sort_version(xs)]

        compilers = []
        for cv in clang_vers:
            switches = []
            initial_checked = []

            # default
            switches += ['warning', 'optimize', 'cpp-verbose']
            initial_checked += ['warning']

            # boost
            if cv in boost_switches:
                bs = boost_switches[cv]
                switches += bs
                initial_checked += [bs[-1]]

            # libs
            if cmpver(cv, '>=', '3.2'):
                switches += ['sprout', 'msgpack']

            # C++
            switches += ['c++98', 'gnu++98', 'c++11', 'gnu++11']
            if cmpver(cv, '>=', '3.2'):
                if cmpver(cv, '>=', '3.5.0'):
                    switches += ['c++14', 'gnu++14']
                else:
                    switches += ['c++1y', 'gnu++1y']
            if cmpver(cv, '>=', '3.5.0'):
                switches += ['c++1z', 'gnu++1z']
            initial_checked += [switches[-1]]

            # pedantic
            switches += ['cpp-no-pedantic', 'cpp-pedantic', 'cpp-pedantic-errors']

            # -fansi-escape-codes
            if cmpver(cv, '>=', '3.4'):
                ansi_escape_codes = ['-fansi-escape-codes']
            else:
                ansi_escape_codes = []

            # compile-command
            compile_command = [
                '/opt/wandbox/clang-{cv}/bin/clang++',
                '-oprog.exe',
                '-fcolor-diagnostics'
                ] + ansi_escape_codes + [
                '-I/opt/wandbox/clang-{cv}/include/c++/v1',
                '-L/opt/wandbox/clang-{cv}/lib',
                '-Wl,-rpath,/opt/wandbox/clang-{cv}/lib',
                '-lpthread',
                '-I/opt/wandbox/boost-sml/include',
                '-I/opt/wandbox/range-v3/include']

            if cmpver(cv, '==', '3.2'):
                # /usr/include/c++/5/type_traits:310:39: error: use of undeclared identifier '__float128'
                #   struct __is_floating_point_helper<__float128>
                compile_command += ['-D__STRICT_ANSI__']
            if cmpver(cv, '<=', '3.2'):
                compile_command += [
                    '-I/usr/include/c++/5',
                    '-I/usr/include/x86_64-linux-gnu/c++/5']
            if cmpver(cv, '>=', '3.3'):
                compile_command += ['-stdlib=libc++', '-nostdinc++']
            if cmpver(cv, '==', '3.3'):
                # /opt/wandbox/clang-3.3/include/c++/v1/cstdio:156:9: error: no member named 'gets' in the global namespace
                # using ::gets;
                compile_command += ['-Dgets=fgets']
            if cmpver(cv, '==', '3.3') or cmpver(cv, '==', '3.4'):
                # /opt/wandbox/boost-1.63.0/clang-3.3/lib/libboost_locale.so: undefined reference to `typeinfo for wchar_t'
                compile_command += ['-lsupc++']
            if cmpver(cv, '>=', '3.5.0'):
                compile_command += ['-lc++abi']
            if cmpver(cv, '==', 'head'):
                # /opt/wandbox/boost-1.63.0/clang-head/include/boost/smart_ptr/scoped_ptr.hpp:74:31: error: no type named 'auto_ptr' in namespace 'std'
                #     explicit scoped_ptr( std::auto_ptr<T> p ) BOOST_NOEXCEPT : px( p.release() )
                #                              ~~~~~^
                #compile_command += ['-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR']
                compile_command += ['-DBOOST_NO_AUTO_PTR']

            compile_command += ['prog.cc']

            # head specific
            if cv == 'head':
                display_name = 'clang HEAD'
                version_command = ["/bin/sh", "-c", "/opt/wandbox/clang-{cv}/bin/clang++ --version | head -1 | cut -d' ' -f3-"]
            else:
                display_name = 'clang'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'clang-{cv}',
                'compile-command': compile_command,
                'version-command': version_command,
                'display-name': display_name,
                'display-compile-command': 'clang++ prog.cc',
                'language': 'C++',
                'output-file': 'prog.cc',
                'run-command': './prog.exe',
                'displayable': True,
                'compiler-option-raw': True,
                'switches': switches,
                'initial-checked': initial_checked,
                'jail-name': 'melpon2-default',
            }, cv=cv))

        return compilers

    def make_mono(self):
        mono_vers = sort_version(get_generic_versions('mono', with_head=True), reverse=True)
        compilers = []
        for cv in mono_vers:
            if cv == 'head':
                display_name = 'mcs HEAD'
                version_command = ['/bin/sh', '-c', "/opt/wandbox/mono-{cv}/bin/mcs --version | head -1 | cut -d' ' -f5"]
            else:
                display_name = 'mcs'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'mono-{cv}',
                'displayable': True,
                'language': 'C#',
                'output-file': 'prog.cs',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/mono-{cv}/bin/mcs', '-out:prog.exe', 'prog.cs'],
                'version-command': version_command,
                'switches': ['mono-optimize'],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'mcs -out:prog.exe prog.cs',
                'run-command': ['/opt/wandbox/mono-{cv}/bin/mono', 'prog.exe'],
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_rill(self):
        rill_vers = ['head']
        compilers = []
        for cv in rill_vers:
            if cv == 'head':
                display_name = 'rillc HEAD'
            else:
                display_name = 'rillc'

            compilers.append(format_value({
                'name': 'rill-{cv}',
                'displayable': True,
                'language': 'Rill',
                'output-file': 'prog.rill',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/rill-{cv}/bin/rillc', '-o', 'prog.exe', '--llc-path', '/opt/wandbox/rill-{cv}/bin/llc', 'prog.rill'],
                'version-command': ['/bin/sh', '-c', "/opt/wandbox/rill-{cv}/bin/rillc --version | head -1 | cut -d' ' -f2-"],
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'rillc -o prog.exe prog.rill',
                'run-command': './prog.exe',
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_erlang(self):
        erlang_vers = sort_version(get_generic_versions('erlang', with_head=True), reverse=True)
        compilers = []
        for cv in erlang_vers:
            if cv == 'head':
                display_name = 'erlang HEAD'
            else:
                display_name = 'erlang'

            if cv == 'head':
                version_command = ['/bin/bash', '-c', 'cat `find /opt/wandbox/erlang-head/lib/erlang/releases/ -name OTP_VERSION | head -n 1`']
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'erlang-{cv}',
                'displayable': True,
                'language': 'Erlang',
                'output-file': 'prog.erl',
                'compiler-option-raw': False,
                'compile-command': ['/bin/true'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'ecript prog.erl',
                'run-command': ['/opt/wandbox/erlang-{cv}/bin/escript', 'prog.erl'],
                'runtime-option-raw': True,
                'jail-name': 'melpon2-erlangvm',
            }, cv=cv))
        return compilers

    def make_elixir(self):
        elixir_vers = sort_version(get_generic_versions('elixir', with_head=True), reverse=True)
        compilers = []
        for cv in elixir_vers:
            if cv == 'head':
                display_name = 'elixir HEAD'
            else:
                display_name = 'elixir'

            if cv == 'head':
                version_command = ['/bin/bash', '-c', "/opt/wandbox/elixir-{cv}/bin/run-elixir.sh --version | tail -n 1 | cut -d' ' -f2-"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'elixir-{cv}',
                'displayable': True,
                'language': 'Elixir',
                'output-file': 'prog.exs',
                'compiler-option-raw': False,
                'compile-command': ['/bin/true'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'elixir prog.exs',
                'run-command': ['/opt/wandbox/elixir-{cv}/bin/run-elixir.sh', 'prog.exs'],
                'runtime-option-raw': True,
                'jail-name': 'melpon2-erlangvm',
            }, cv=cv))
        return compilers

    def make_ghc(self):
        ghc_vers = sort_version(get_generic_versions('ghc', with_head=True), reverse=True)
        compilers = []
        for cv in ghc_vers:
            if cv == 'head':
                display_name = 'ghc HEAD'
            else:
                display_name = 'ghc'

            if cv == 'head':
                version_command = ['/bin/bash', '-c', "/opt/wandbox/ghc-{cv}/bin/ghc --version | cut -d' ' -f8"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'ghc-{cv}',
                'displayable': True,
                'language': 'Haskell',
                'output-file': 'prog.hs',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/ghc-{cv}/bin/ghc', '-o', 'prog.exe', 'prog.hs'],
                'version-command': version_command,
                'switches': ['haskell-warning', 'haskell-optimize'],
                'initial-checked': ['haskell-warning'],
                'display-name': display_name,
                'display-compile-command': 'ghc prog.hs -o prog.exe',
                'run-command': './prog.exe',
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_dmd(self):
        dmd_vers = sort_version(get_generic_versions('dmd', with_head=True), reverse=True)
        compilers = []
        for cv in dmd_vers:
            if cv == 'head':
                display_name = 'dmd HEAD'
            else:
                display_name = 'dmd'

            if cv == 'head':
                version_command = ['/bin/sh', '-c', "/opt/wandbox/dmd-{cv}/linux/bin64/dmd --version | head -1 | cut -d' ' -f4"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'dmd-{cv}',
                'displayable': True,
                'language': 'D',
                'output-file': 'prog.d',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/dmd-{cv}/linux/bin64/dmd', '-ofprog.exe', 'prog.d'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'dmd prog.d -ofprog.exe',
                'run-command': './prog.exe',
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_gdc(self):
        gdc_vers = ['head']
        compilers = []
        for cv in gdc_vers:
            if cv == 'head':
                display_name = 'gdc HEAD'
            else:
                display_name = 'gdc'

            if cv == 'head':
                version_command = ['/bin/sh', '-c', "/opt/wandbox/gdc-{cv}/bin/gdc --version | head -1 | cut -d' ' -f3-"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'gdc-{cv}',
                'displayable': True,
                'language': 'D',
                'output-file': 'prog.d',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/gdc-{cv}/bin/gdc', '-o', 'prog.exe', 'prog.d'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'gdc prog.d -o prog.exe',
                'run-command': './prog.exe',
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_openjdk(self):
        openjdk_vers = get_generic_versions('openjdk', with_head=True)
        compilers = []
        for cv in openjdk_vers:
            if cv == 'head':
                display_name = 'OpenJDK HEAD'
                version_command = ['/bin/bash', '-c', "/opt/wandbox/openjdk-{cv}/bin/java -version 2>&1 | head -n1 | cut -d' ' -f3- | cut -d'\"' -f2"]
            else:
                display_name = 'OpenJDK'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'openjdk-{cv}',
                'displayable': True,
                'language': 'Java',
                'output-file': 'prog.java',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/openjdk-{cv}/bin/javac', 'prog.java'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'javac prog.java',
                'run-command': ['/opt/wandbox/openjdk-{cv}/bin/run-java.sh'],
                'jail-name': 'melpon2-jvm',
            }, cv=cv))
        return compilers

    def make_rust(self):
        rust_vers = sort_version(get_generic_versions('rust', with_head=True), reverse=True)
        compilers = []
        for cv in rust_vers:
            if cv == 'head':
                display_name = 'rust HEAD'
            else:
                display_name = 'rust'

            if cv == 'head':
                version_command = ['/bin/sh', '-c', "/opt/wandbox/rust-{cv}/bin/rustc --version | head -1 | cut -d' ' -f2-"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'rust-{cv}',
                'displayable': True,
                'language': 'Rust',
                'output-file': 'prog.rs',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/rust-{cv}/bin/rustc', 'prog.rs'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'rust prog.rs',
                'run-command': './prog',
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_cpython(self):
        cpython_vers = ['head', '2.7-head'] + sort_version(get_generic_versions('cpython', with_head=False), reverse=True)
        compilers = []
        for cv in cpython_vers:
            if cv == 'head':
                display_name = 'CPython HEAD'
            elif cv == '2.7-head':
                display_name = 'CPython2.7 HEAD'
            else:
                display_name = 'CPython'

            if cv == 'head':
                python = 'python3'
            elif cv == '2.7-head':
                python = 'python'
            elif cmpver(cv, '>=', '3.0.0'):
                python = 'python3'
            else:
                python = 'python'

            if 'head' in cv:
                version_command = ["/opt/wandbox/cpython-{cv}/bin/{python}", "-c", "import sys; print(sys.version.split()[0])"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'cpython-{cv}',
                'displayable': True,
                'language': 'Python',
                'output-file': 'prog.py',
                'compiler-option-raw': False,
                'compile-command': ['/bin/true'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': '{python} prog.py',
                'run-command': ['/opt/wandbox/cpython-{cv}/bin/{python}', 'prog.py'],
                'runtime-option-raw': True,
                'jail-name': 'melpon2-default',
            }, cv=cv, python=python))
        return compilers

    def make_ruby(self):
        ruby_vers = get_generic_versions('ruby', with_head=True)
        compilers = []
        for cv in ruby_vers:
            if cv == 'head':
                display_name = 'ruby HEAD'
            else:
                display_name = 'ruby'

            if cv == 'head':
                version_command = ['/bin/bash', '-c', "/opt/wandbox/ruby-{cv}/bin/ruby --version | cut -d' ' -f2"]
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'ruby-{cv}',
                'displayable': True,
                'language': 'Ruby',
                'output-file': 'prog.rb',
                'compiler-option-raw': False,
                'compile-command': ['/bin/true'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'ruby prog.rb',
                'run-command': ['/opt/wandbox/ruby-{cv}/bin/ruby', 'prog.rb'],
                'runtime-option-raw': True,
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_mruby(self):
        mruby_vers = sort_version(get_generic_versions('mruby', with_head=True), reverse=True)
        compilers = []
        for cv in mruby_vers:
            if cv == 'head':
                display_name = 'mruby HEAD'
            else:
                display_name = 'mruby'

            if cv == 'head':
                version_command = ['/bin/cat', '/opt/wandbox/mruby-{cv}/VERSION']
            else:
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'mruby-{cv}',
                'displayable': True,
                'language': 'Ruby',
                'output-file': 'prog.rb',
                'compiler-option-raw': False,
                'compile-command': ['/bin/true'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'mruby prog.rb',
                'run-command': ['/opt/wandbox/mruby-{cv}/bin/mruby', 'prog.rb'],
                'runtime-option-raw': True,
                'jail-name': 'melpon2-default',
            }, cv=cv))
        return compilers

    def make_scala(self):
        scala_vers = read_versions('scala-head') + get_generic_versions('scala', with_head=False)
        compilers = []
        for cv in scala_vers:
            if cv[-2:] == '.x':
                display_name = 'Scala {cv} HEAD'
                version_command = ['/bin/bash', '-c', "/opt/wandbox/scala-{cv}/bin/run-scalac.sh -version 2>&1 | cut -d' ' -f4"]
            else:
                display_name = 'Scala'
                version_command = ['/bin/echo', '{cv}']

            compilers.append(format_value({
                'name': 'scala-{cv}',
                'displayable': True,
                'language': 'Scala',
                'output-file': 'prog.scala',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/scala-{cv}/bin/run-scalac.sh', 'prog.scala'],
                'version-command': version_command,
                'switches': [],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'scalac prog.scala',
                'run-command': ['/opt/wandbox/scala-{cv}/bin/run-scala.sh'],
                'jail-name': 'melpon2-jvm',
            }, cv=cv))
        return compilers

    def make(self):
        return (
            self.make_gcc_c() +
            self.make_gcc() +
            self.make_clang_c() +
            self.make_clang() +
            self.make_mono() +
            self.make_rill() +
            self.make_erlang() +
            self.make_elixir() +
            self.make_ghc() +
            self.make_dmd() +
            self.make_gdc() +
            self.make_openjdk() +
            self.make_rust() +
            self.make_cpython() +
            self.make_ruby() +
            self.make_mruby() +
            self.make_scala()
        )

def make_config():
    return {
        'switches': Switches().make(),
        'compilers': Compilers().make(),
    }

if __name__ == '__main__':
    print(json.dumps(make_config(), indent=4))
