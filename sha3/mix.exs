defmodule Mix.Tasks.Compile.Sha3 do
  def run(_args) do
    # first compile d code
    {_result, _errcode} = System.cmd("dmd",
      [
        "native_lib/sha3_d.d",
        "-c",
        "-fPIC",
        "-of=native_obj/sha3_d.o"
      ], stderr_to_stdout: true)

    # compile cpp code
    {_result, _errcode} = System.cmd("g++",
      [
        "native_lib/sha3.cpp",
        "native_obj/sha3_d.o",
        "-fPIC",
        "-shared",
        "-L/home/sylph01/.asdf/installs/dmd/2.079.1/dmd2/linux/lib64",
        "-I/home/sylph01/.asdf/installs/erlang/20.3.4/usr/include",
        "-lphobos2",
        "-pthread",
        "-o", "native_obj/sha3.so"
      ], stderr_to_stdout: true)

    :ok
  end
end

defmodule Sha3.MixProject do
  use Mix.Project

  def project do
    [
      app: :sha3,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:sha3] ++ Mix.compilers
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
