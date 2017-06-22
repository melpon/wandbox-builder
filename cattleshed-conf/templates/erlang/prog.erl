% This file is a "Hello, world!" in Erlang for wandbox.
-module(prog).

% Erlang for Wandbox must exports main/0
-export([main/0]).

main() ->
    io:format("Hello, Wandbox!~n").

% Erlang language reference:
%   http://erlang.org/doc/reference_manual/users_guide.html
