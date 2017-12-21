defmodule ExHoedown do
  @moduledoc """
  Markdown to HTML conversion.
  """

  @on_load { :init, 0 }

  @app Mix.Project.config[:app]

  def init do
    path = :filename.join(:code.priv_dir(unquote(@app)), 'exhoedown')
    :ok = :erlang.load_nif(path, 0)
  end

  @doc ~S"""
  Converts a Markdown document to HTML:

      iex> ExHoedown.to_html "# Hello World"
      "<h1>Hello World</h1>\n"
      iex> ExHoedown.to_html "http://elixir-lang.org/", autolink: true
      "<p><a href=\"http://elixir-lang.org/\">http://elixir-lang.org/</a></p>\n"

  Available output options:

  * `:tables` - Enables Markdown Extra style tables (default: `false`)
  * `:fenced_code` - Enables fenced code blocks (default: `false`)
  * `:footnotes` - Parse footnotes. (default: `false`)
  * `:autolink` - Automatically turn URLs into links (default: `false`)
  * `:strikethrough` - Parse `~~stikethrough~~` spans. (default: `false`)
  * `:underline` - Parse `_underline_` instead of emphasis. (default: `false`)
  * `:highlight` - Parse `==highlight==` spans. (default: `false`)
  * `:quote` - Render `"quotes"` as `<q>quotes</q>`. (default: `false`)
  * `:superscript` - Parse `super^script`. (default: `false`)
  * `:no_intra_emphasis` - Disable `emphasis_between_words.` (default: `false`)
  * `:space_headers` - Require a space after '#' in headers. (default: `false`)
  * `:disable_indented_code` - Don't parse indented code blocks. (default: `false`)
  * `:strip_html` - Strip all HTML tags. (default: `false`)
  * `:escape_html` - Escape all HTML. (default: `false`)
  * `:hard_wrap` - Render each linebreak as `<br>`. (default: `false`)
  * `:xhtml` - Render XHTML. (default: `false`)
  """
  @spec to_html(doc :: String.t) :: String.t
  @spec to_html(doc :: String.t, options :: Keyword.t) :: String.t
  def to_html(doc, options \\ []) do
    {html_flags, extension_flags} = extract_flags(options)

    to_html_nif(doc, html_flags, extension_flags)
  end

  def to_html_nif(_, _, _) do
    exit(:nif_library_not_loaded)
  end

  use Bitwise

  @html_flags %{
    strip_html: (1 <<< 0),
    escape_html: (1 <<< 1),
    hard_wrap: (1 <<< 2),
    xhtml: (1 <<< 3),
  }

  @extension_flags %{
    # block-level extensions
    tables: (1 <<< 0),
    fenced_code: (1 <<< 1),
    footnotes: (1 <<< 2),
    # span-level extensions
    autolink: (1 <<< 3),
    strikethrough: (1 <<< 4),
    underline: (1 <<< 5),
    highlight: (1 <<< 6),
    quote: (1 <<< 7),
    superscript: (1 <<< 8),
    math: (1 <<< 9),
    # other flags
    no_intra_emphasis: (1 <<< 11),
    space_headers: (1 <<< 12),
    math_explicit: (1 <<< 13),
    # negative flags
    disable_indented_code: (1 <<< 14)
  }

  defp extract_flags(options) do
    Enum.reduce options, {0, 0}, fn {key, value}, {html_flags, extension_flags} ->
      case value do
        true -> {html_flags ||| Map.get(@html_flags, key, 0), extension_flags ||| Map.get(@extension_flags, key, 0)}
        false -> {html_flags, extension_flags}
      end
    end
  end
end
