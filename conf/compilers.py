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


def get_gcc_versions():
    lines = open(os.path.join(build_path(), 'gcc', 'VERSIONS')).readlines()
    return [line.strip() for line in lines if len(line) != 0]


def get_gcc_versions_with_head():
    return get_gcc_versions() + ['head']


def get_clang_versions():
    lines = open(os.path.join(build_path(), 'clang', 'VERSIONS')).readlines()
    return [line.strip() for line in lines if len(line) != 0]


def get_clang_versions_with_head():
    return get_clang_versions() + ['head']


def get_mono_versions():
    lines = open(os.path.join(build_path(), 'mono', 'VERSIONS')).readlines()
    return [line.strip() for line in lines if len(line) != 0]


def get_mono_versions_with_head():
    return get_mono_versions() + ['head']


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

    def make_cxx(self):
        pairs = [
            ('c89', {
                'flags': ['-std=c89'],
                'display-name': 'C89',
            }),
            ('c99', {
                'flags': ['-std=c99'],
                'display-name': 'C99',
            }),
            ('c11', {
                'flags': ['-std=c11'],
                'display-name': 'C11',
            }),
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
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions()))
        gcc_vers = sort_version(get_gcc_versions())
        clang_vers = sort_version(get_clang_versions())
        compiler_vers = [('gcc', v) for v in gcc_vers] + [('clang', v) for v in clang_vers]

        boost_ver_set = set(get_boost_versions())
        boost_libs = {}
        # ライブラリの一覧を調べる
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
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions()))
        gcc_vers = sort_version(get_gcc_versions())
        clang_vers = sort_version(get_clang_versions())
        compiler_vers = [('gcc', v) for v in gcc_vers] + [('clang', v) for v in clang_vers]

        boost_ver_set = set(get_boost_versions())
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
                'flags': ['-I/opt/wandbox/msgpack-head/include'],
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
        }

    def make(self):
        return merge(
            self.make_default(),
            self.make_pedantic(),
            self.make_boost(),
            self.make_boost_header(),
            self.make_cxx())

class Compilers(object):
    def make_gcc(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        gcc_vers = sort_version(get_gcc_versions_with_head(), reverse=True)

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
                switches += ['oldgcc-warning']
                initial_checked += ['oldgcc-warning']
            else:
                switches += ['warning']
                initial_checked += ['warning']
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
                version_command = ['/opt/wandbox/gcc-{cv}/bin/g++', '-dumpversion']

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
            }, cv=cv))
        return compilers

    def make_clang(self):
        boost_vers = sort_version(set(a for a, _, _ in get_boost_versions_with_head()))
        clang_vers = sort_version(get_clang_versions_with_head(), reverse=True)

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

            # compile-command
            compile_command = [
                '/opt/wandbox/clang-{cv}/bin/clang++',
                '-oprog.exe',
                '-fansi-escape-codes',
                '-fcolor-diagnostics',
                '-I/opt/wandbox/clang-{cv}/include/c++/v1',
                '-L/opt/wandbox/clang-{cv}/lib',
                '-Wl,-rpath,/opt/wandbox/clang-{cv}/lib',
                '-lpthread',
                '-I/opt/wandbox/boost-sml/include',
                '-I/opt/wandbox/range-v3/include']

            if cmpver(cv, '<=', '3.2'):
                compile_command += [
                    '-I/usr/include/c++/5',
                    '-I/usr/include/x86_64-linux-gnu/c++/5']
            if cmpver(cv, '>=', '3.3'):
                compile_command += ['-stdlib=libc++', '-nostdinc++']
            if cmpver(cv, '>=', '3.5.0'):
                compile_command += ['-lc++abi']

            compile_command += ['proc.cc']

            # head specific
            if cv == 'head':
                display_name = 'clang HEAD'
                version_command = ['/bin/sh', '-c', '/opt/wandbox/clang-head/bin/clang++ --version | head -1 | cut -d' ' -f3-']
            else:
                display_name = 'clang'
                version_command = ['/opt/wandbox/clang-{cv}/bin/clang++', '-dumpversion']

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
            }, cv=cv))

        return compilers

    def make_mono(self):
        mono_vers = sort_version(get_mono_versions_with_head(), reverse=True)
        compilers = []
        for cv in mono_vers:
            if cv == 'head':
                display_name = 'mcs HEAD'
            else:
                display_name = 'mcs'

            compilers.append(format_value({
                'name': 'mono-{cv}',
                'displayable': True,
                'language': 'C#',
                'output-file': 'prog.cs',
                'compiler-option-raw': True,
                'compile-command': ['/opt/wandbox/mono-{cv}/bin/mcs', '-out:prog.exe', 'prog.cs'],
                'version-command': ['/bin/sh', '-c', '/opt/wandbox/mono-{cv}/bin/mcs --version | head -1 | cut -d' ' -f5'],
                'swithes': ['mono-optimize'],
                'initial-checked': [],
                'display-name': display_name,
                'display-compile-command': 'mcs -out:prog.exe prog.cs',
                'run-command': ['/opt/wandbox/mono-{cv}/bin/mono', 'prog.exe']
            }, cv=cv))
        return compilers

    def make(self):
        return (
            self.make_gcc() +
            self.make_clang() +
            self.make_mono()
        )

def make_config():
    return {
        'switches': Switches().make(),
        'compilers': Compilers().make(),
    }

if __name__ == '__main__':
    print(json.dumps(make_config(), indent=4))
