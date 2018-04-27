import std.stdio;
import std.conv;

union State {
	ulong[25]  q;
	ubyte[200] b;
}

ulong bitwiseRotateLeft(ulong target, int n) {
  return (target << n) | (target >> (64 - n));
}

ulong[25] keccak_f(ulong[25] a){
	const ulong[24] round_constants = [
	  0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
    0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
		0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
    0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
    0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
    0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
    0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
    0x8000000000008080, 0x0000000080000001, 0x8000000080008008
	];
	const int[24] rotation_offsets = [
		1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
    27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
	];
	const int[24] pi_length = [
		10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
    15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
	];

	ulong[5] b;
	ulong d, t;
	ulong[25] ret;
	foreach (int i; 0 .. 25) {
		ret[i] = a[i];
	}

	foreach (int rounds; 0 .. 24) {
	  // theta
	  foreach (int i; 0 .. 5) {
	    b[i] = ret[i] ^ ret[i + 5] ^ ret[i + 10] ^ ret[i + 15] ^ ret[i + 20];
	  }
	  foreach (int i; 0 .. 5){
	    d = b[(i + 4) % 5] ^ bitwiseRotateLeft(b[(i + 1) % 5], 1);
	    foreach (int j; 0 .. 5) {
	      ret[i + j * 5] ^= d;
	    }
	  }

	  // rho and pi
	  t = ret[1];
	  foreach (int i; 0 .. 24){
	    int j = pi_length[i];
	    b[0] = ret[j];
	    ret[j] = bitwiseRotateLeft(t, rotation_offsets[i]);
	    t = b[0];
	  }

	  // chi
	  for(int j; j < 25; j += 5) {
	    foreach (int i; 0 .. 5) {
	      b[i] = ret[j + i];
	    }
	    foreach (int i; 0 .. 5) {
	      ret[j + i] ^= (~b[(i + 1) % 5]) & b[(i + 2) % 5];
	    }
	  }

	  // iota
	  ret[0] ^= round_constants[rounds];
	}
	return ret;
}

// TODO: rewrite this with D template
// make mdlen a template variable, then calculate rsize accordingly,
// enabling other variations such as sha3_384(48), sha3_512(64)
char[32] sha3_256(const char[] input){
	const mdlen = 32;
	State st = {q: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]};
	int rsize, pt, j;
	char[32] md;
	size_t inlen = input.length;
	ulong[25] t;

	// initialize context
	foreach (int i; 0 .. 25) {
		st.q[i] = 0;
	}
	rsize = 200 - 2 * mdlen;
	pt = 0;

	// update state
	j = pt;
	for(size_t i = 0; i < inlen; i++) {
		st.b[j++] ^= (cast(const(ubyte*)) input)[i];
		if (j >= rsize) {
			t = keccak_f(st.q);
			foreach (int k; 0 .. 25) {
				st.q[k] = t[k];
			}
			j = 0;
		}
	}
	pt = j;

	// finalize and output hash
	st.b[pt] ^= 0x06;
	st.b[rsize - 1] ^= 0x80;
	t = keccak_f(st.q);
	foreach (int k; 0 .. 25) {
		st.q[k] = t[k];
	}

	for(int i = 0; i < 32; i++) {
		md[i] = st.b[i];
	}

	return md;
}

char[] to_hex(const char[] input) {
  import std.string;
  char[] output;
  foreach(ch; input) {
    output = output ~ format("%02x", ch);
  }
  return output;
}

extern (C++) immutable(char)* sha3_256_c(const char *s) {
  import std.string;
  return toStringz(to_hex(sha3_256(fromStringz(s))));
}
