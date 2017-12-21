defmodule Mix.Tasks.Compile.Hoedown do

  def run(_) do
    if match? {:win32, _}, :os.type do
      {result, _error_code} = System.cmd("nmake", ["/F", "Makefile.win", "priv\\exhoedown.dll"], stderr_to_stdout: true)
      IO.binwrite result
    else
      {result, _error_code} = System.cmd("make", ["priv/exhoedown.so"], stderr_to_stdout: true)
      IO.binwrite result
    end

    :ok
  end
end

defmodule ExHoedown.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exhoedown,
      version: "0.1.0",
      elixir: "~> 1.5",
      compilers: [:hoedown] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:hoedown, github: "hoedown/hoedown", app: false}
    ]
  end
end
