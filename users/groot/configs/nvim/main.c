int main() {
  printf("foo");
  if (1) {
    // HACK: this should not be here
    // FIX:
    // TODO
    int some_int222;
    some_int222 = 1;
  }
}
