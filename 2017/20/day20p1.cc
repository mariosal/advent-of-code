#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

using namespace std;

class Particle {
 public:
  void setX(int x, int y, int z) {
    x_ = { x, y, z };
  }
  void setV(int x, int y, int z) {
    v_ = { x, y, z };
  }
  void setA(int x, int y, int z) {
    a_ = { x, y, z };
  }

  const vector<int>& x() const {
    return x_;
  }

  const vector<int>& v() const {
    return v_;
  }

  const vector<int>& a() const {
    return a_;
  }

  void Tick() {
    for (size_t i = 0; i < 3; ++i) {
      v_[i] += a_[i];
      x_[i] += v_[i];
    }
  }

 private:
  vector<int> x_;
  vector<int> v_;
  vector<int> a_;
};

static int Dist(const vector<int>& a, const vector<int>& b) {
  int ret = 0;
  for (size_t i = 0; i < 3; ++i) {
    ret += abs(a[i] - b[i]);
  }
  return ret;
}

int main() {
  vector<Particle> particles;
  while (true) {
    int x, y, z;
    Particle p;

    if (scanf("p=<%d,%d,%d>, ", &x, &y, &z) == EOF) {
      break;
    }
    p.setX(x, y, z);

    scanf("v=<%d,%d,%d>, ", &x, &y, &z);
    p.setV(x, y, z);

    scanf("a=<%d,%d,%d>\n", &x, &y, &z);
    p.setA(x, y, z);

    particles.push_back(p);
  }

  vector<int> o = { 0, 0, 0 };
  vector<int> dist(particles.size(), 987654321);
  int steady_time = -1;
  for (int t = 0; ; ++t) {
    bool dist_decreased = false;
    size_t min_i = 0;
    int min_dist = 987654321;
    bool steady = true;
    for (size_t i = 0; i < particles.size(); ++i) {
      particles[i].Tick();
      for (size_t j = 0; j < 3; ++j) {
        if (particles[i].v()[j] * particles[i].a()[j] <= 0 && particles[i].a()[j] != 0) {
          steady = false;
        }
      }
      int cur_dist = Dist(particles[i].x(), o);
      if (dist[i] > cur_dist) {
        dist[i] = cur_dist;
        dist_decreased = true;
      }
      if (min_dist > cur_dist) {
        min_dist = cur_dist;
        min_i = i;
      }
    }
    if (!dist_decreased && steady) {
      if (steady_time == -1) {
        steady_time = t;
      } else if (t == particles.size() + steady_time) {
        printf("%d %zu\n", t, min_i);
        break;
      }
    }
  }

  return 0;
}
