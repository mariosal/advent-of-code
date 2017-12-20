// a[t] = a[0]
// v[t] = v[t - 1] + a[0] * 1 = v[t - 2] + a[0] * 2 = v[0] + a[0] * t
// x[t] = x[t - 1] + 1 * v[0] + a[0] * t
//     = x[t - 2] + 2 * v[0] + a[0] * (t - 1) + a[0] * t
//     = x[t - 3] + 3 * v[0] + a[0] * (t - 2) + a[0] * (t - 1) + a[0] * t
//     = x[0] + v[0] * t + a[0] * (1 + 2 + ... + t)
//     = x[0] + v[0] * t + 1/2 * a[0] * t * (t + 1)
#include <cmath>
#include <cstdio>
#include <set>
#include <vector>

using namespace std;

const int kInf = 987654321;

struct Sol {
  size_t i;
  size_t j;
  int t;

  bool operator <(const Sol& o) const {
    if (t == o.t) {
      if (i == o.i) {
        return j < o.j;
      }
      return i < o.i;
    }
    return t < o.t;
  }
};

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

  vector<int> x(int t) const {
    vector<int> ret;
    for (size_t i = 0; i < 3; ++i) {
      ret.push_back(x_[i] + v_[i] * t + 1.0 / 2 * a_[i] * t * (t + 1));
    }
    return ret;
  }

  vector<int> v(int t) const {
    vector<int> ret;
    for (size_t i = 0; i < 3; ++i) {
      ret.push_back(v_[i] - a_[i] * t);
    }
    return ret;
  }

  const vector<int>& a() const {
    return a_;
  }

  int CountSol(const Particle& o, size_t axis) const {
    double alpha = 1.0 / 2 * (a_[axis] - o.a()[axis]);
    double beta = v_[axis] - o.v(0)[axis] + 1.0 / 2 * (a_[axis] - o.a()[axis]);
    double gamma = x_[axis] - o.x(0)[axis];
    double delta = beta * beta - 4 * alpha * gamma;

    if (fabs(alpha) < 1e-9) {
      if (fabs(beta) < 1e-9) {
        return fabs(gamma) < 1e-9 ? kInf : 0;
      } else {
        return 1;
      }
    } else {
      if (delta < 0) {
        return 0;
      } else if (fabs(delta) < 1e-9) {
        return 1;
      } else if (delta > 0) {
        return 2;
      }
    }
  }

  vector<int> IntersectTime(const Particle& o) const {
    bool noSol = true;
    bool allInf = true;
    size_t axis = 0;
    for (size_t i = 0; i < 3; ++i) {
      if (CountSol(o, i) > 0) {
        noSol = false;

        if (CountSol(o, i) != kInf) {
          axis = i;
          allInf = false;
        }
      }
    }
    if (noSol) {
      return {};
    }
    if (allInf) {
      return { 0 };
    }

    double alpha = 1.0 / 2 * (a_[axis] - o.a()[axis]);
    double beta = v_[axis] - o.v(0)[axis] + 1.0 / 2 * (a_[axis] - o.a()[axis]);
    double gamma = x_[axis] - o.x(0)[axis];
    double delta = beta * beta - 4 * alpha * gamma;

    vector<int> ret;
    if (fabs(alpha) < 1e-9) {
      ret.push_back(-gamma / beta);
    } else {
      if (fabs(delta) < 1e-9) {
        ret.push_back(-beta / (2 * alpha));
      } else if (delta > 0) {
        ret.push_back((-beta + sqrt(delta)) / (2 * alpha));
        ret.push_back((-beta - sqrt(delta)) / (2 * alpha));
      }
    }

    for (size_t i = 0; i < ret.size(); ++i) {
      bool sol = true;
      for (size_t j = 0; j < 3; ++j) {
        if (x(ret[i])[j] != o.x(ret[i])[j]) {
          sol = false;
          break;
        }
      }
      if (!sol) {
        ret.erase(ret.begin() + i);
        --i;
      }
    }
    return ret;
  }

 private:
  vector<int> x_;
  vector<int> v_;
  vector<int> a_;
};

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

  set<Sol> sols;
  for (size_t i = 0; i < particles.size(); ++i) {
    for (size_t j = i + 1; j < particles.size(); ++j) {
      vector<int> sol = particles[i].IntersectTime(particles[j]);
      for (size_t k = 0; k < sol.size(); ++k) {
        sols.insert({ i, j, sol[k] });
      }
    }
  }

  vector<int> del(particles.size(), -1);
  while (!sols.empty()) {
    Sol sol = *sols.begin();
    sols.erase(sols.begin());
    if (sol.t < 0) {
      continue;
    }
    if (del[sol.i] != sol.t && del[sol.i] != -1 && del[sol.j] == -1) {
      continue;
    }
    if (del[sol.i] == -1 && del[sol.j] != sol.t && del[sol.j] != -1) {
      continue;
    }
    del[sol.i] = sol.t;
    del[sol.j] = sol.t;
  }

  int remaining = 0;
  for (size_t i = 0; i < del.size(); ++i) {
    if (del[i] == -1) {
      ++remaining;
    }
  }
  printf("%d\n", remaining);

  return 0;
}
