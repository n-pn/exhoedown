# ExHoedown

Convert Markdown to HTML using [hoedown](https://github.com/hoedown/hoedown) library.

## Installation

```elixir
{:exhoedown, github: "nipinium/exhoedown"}
```

## Usage

```iex
iex> Markdown.to_html "# Hello World"
"<h1>Hello World</h1>\n"
iex> Markdown.to_html "http://elixir-lang.org/", autolink: true
"<p><a href=\"http://elixir-lang.org/\">http://elixir-lang.org/</a></p>\n"
```

## Options

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

## License

UNLICENSE
