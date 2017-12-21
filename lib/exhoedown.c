#include <string.h>
#include <stdint.h>

#include "erl_nif.h"

#include "buffer.h"
#include "document.h"
#include "html.h"

#define OUTPUT_UNIT 128

static ERL_NIF_TERM
to_html_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary input;
  ErlNifBinary output;

  hoedown_buffer* ob;
  hoedown_document* document;
  hoedown_renderer* renderer;

  if (enif_inspect_binary(env, argv[0], &input) == 0) {
    return enif_make_badarg(env);
  }

  if (input.size < 1) {
    return argv[0];
  }

  ERL_NIF_TERM html_options = argv[1];
  unsigned int html_flags = 0;
  enif_get_uint(env, html_options, &html_flags);

  ERL_NIF_TERM extension_options = argv[2];
  unsigned int extension_flags = 0;
  enif_get_uint(env, extension_options, &extension_flags);

  ob = hoedown_buffer_new(OUTPUT_UNIT);
  renderer = hoedown_html_renderer_new(html_flags, 0);
  document = hoedown_document_new(renderer, extension_flags, 16);
  hoedown_document_render(document, ob, (uint8_t*) input.data, input.size);

  enif_release_binary(&input);
  hoedown_html_renderer_free(renderer);
  hoedown_document_free(document);

  enif_alloc_binary(ob->size, &output);
  memcpy(output.data, ob->data, ob->size);
  hoedown_buffer_free(ob);

  return enif_make_binary(env, &output);
}

static ErlNifFunc funcs[] = {
  { "to_html_nif", 3, to_html_nif }
};

ERL_NIF_INIT(Elixir.ExHoedown, funcs, NULL, NULL, NULL, NULL)
