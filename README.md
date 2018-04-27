# NIF Examples in D

Material for LT @ [Ruby x Elixir Conf Taiwan 2018](https://2018.rubyconf.tw/). Erlang NIF (Native Implemented Function) examples, which is written using [Dlang](https://dlang.org/). Uses C++ as intermediate interface.

## Note: to run it on your environment

As of this version, the library path and the header include path is hard-coded for my development environment. I will fix it later, but to try it out yourself, please change the following in each folder's `mix.exs`:

- `-L` (library path) to the directory with D libraries installed (which should have `libphobos2.so`)
- `-I` (header include path) to the directory with Erlang NIF headers (which should have `erl_nif.h`)

You can also add those directories to your library path / include path.

(Also try [asdf](https://github.com/asdf-vm/asdf), this makes version management of multiple languages way easier! By the way, [I wrote the D compiler plugin :)](https://github.com/sylph01/asdf-dmd))
