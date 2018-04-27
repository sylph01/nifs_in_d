#include <erl_nif.h>

int add(int a, int b);

extern "C" int rt_init();
extern "C" int rt_term();

ERL_NIF_TERM add_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]){
  int a = 0;
  int b = 0;
  if (!enif_get_int(env, argv[0], &a)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &b)) {
    return enif_make_badarg(env);
  }

  // rt_init();
  int result = add(a, b);
  // rt_term();

  return enif_make_int(env, result);
}

ErlNifFunc nif_funcs[] = {
  {"add", 2, add_nif}
};

int load(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info) {
  rt_init();
  return 0;
}

ERL_NIF_INIT(Elixir.Add, nif_funcs, load, NULL, NULL, NULL);
