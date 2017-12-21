defmodule ExHoedownTest do
  use ExUnit.Case

  doctest ExHoedown

  test :tables do
    markdown = """
    |  J  |  O  |
    | --- | --- |
    |  S  |  É  |
    """

    html = ExHoedown.to_html(markdown, tables: true)
    assert html =~ ~r/<table>/
  end

  test :autolink do
    markdown = "http://devintorr.es/"
    html = ExHoedown.to_html(markdown, autolink: true)
    assert html =~ ~r[<a href="http://devintorr.es/">]
  end

  test :fenced_code do
    markdown = """
    ```
    ExHoedown.to_html(markdown)
    ```
    """

    html = ExHoedown.to_html(markdown, fenced_code: true)
    assert html =~ ~r/<code>/
  end

  test :fenced_code_with_lang do
    markdown = """
    ```elixir
    ExHoedown.to_html(markdown)
    ```
    """

    html = ExHoedown.to_html(markdown, fenced_code: true)
    assert html == ~s{<pre><code class="language-elixir">ExHoedown.to_html(markdown)\n</code></pre>\n}
  end

  test :escape_html do
    assert ExHoedown.to_html("<p></p>", escape_html: true) =~ ~r{&lt;p&gt;&lt;/p&gt;}
  end
end
