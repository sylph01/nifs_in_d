#include <erl_nif.h>
#include <iostream>
#include <cstring>

using namespace std;

const char* sha3_256_c(const char* in);
extern "C" int rt_init();

ERL_NIF_TERM sha3_256_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]){
  // extract binary from arguments in the form of ERL_NIF_TERM
  ErlNifBinary input;
  if (!enif_inspect_iolist_as_binary(env, argv[0], &input)){
    return enif_make_badarg(env);
  }

  // assign a buffer for return values
  ERL_NIF_TERM term;
  unsigned char* ret = enif_make_new_binary(env, 64, &term);

  // run the function, put the result in the buffer
  memcpy(ret, sha3_256_c(reinterpret_cast<const char* >(input.data)), 64);

  return term;
}

ErlNifFunc nif_funcs[] = {
  {"sha3_256", 1, sha3_256_nif}
};

int load(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info) {
  rt_init();
  return 0;
}

ERL_NIF_INIT(Elixir.Sha3, nif_funcs, load, NULL, NULL, NULL);
