#include <cstdio>
#include <map>

using namespace std;

struct Layer {
  bool dir;
  int pos;
  int range;
};

static void Tick(map<int, Layer>* firewall) {
  for (auto it = firewall->begin(); it != firewall->end(); ++it) {
    if (it->second.dir && it->second.pos == it->second.range) {
      it->second.dir = false;
    } else if (!it->second.dir && it->second.pos == 1) {
      it->second.dir = true;
    }
    it->second.pos += !it->second.dir * -1 + it->second.dir * 1;
  }
}

int main() {
  map<int, Layer> firewall;

  while (true) {
    int i, r;
    if (scanf("%d: %d", &i, &r) == EOF) {
      break;
    }
    Layer l = { true, 1, r };
    firewall[i] = l;
  }

  int count = 0;
  for (int i = 0; i <= firewall.crbegin()->first; ++i) {
    auto it = firewall.find(i);
    if (it != firewall.end()) {
      if (it->second.pos == 1) {
        count += i * it->second.range;
      }
    }
    Tick(&firewall);
  }
  printf("%d\n", count);

  return 0;
}
