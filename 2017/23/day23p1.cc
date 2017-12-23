#include <cstdio>
#include <cstring>
#include <map>
#include <queue>
#include <vector>

using namespace std;

class Process {
 public:
  Process(const vector<char*>& in)
      : finished_(false), count_mul_(0), pc_(0), in_(in) {
  }

  bool finished() const {
    return finished_;
  }

  int count_mul() const {
    return count_mul_;
  }

  void Tick() {
    if (pc_ < 0 || in_.size() <= pc_) {
      finished_ = true;
      return;
    }

    char cmd[4], x;
    sscanf(in_[pc_], "%s %c", cmd, &x);

    long long y = 0;
    char buf[16];
    sscanf(in_[pc_], "%*s %*c%s", buf);
    if ('a' <= buf[0] && buf[0] <= 'z') {
      y = reg_[buf[0]];
    } else {
      sscanf(buf, "%lld", &y);
    }

    if (!strcmp(cmd, "set")) {
      Set(x, y);
    } else if (!strcmp(cmd, "sub")) {
      Sub(x, y);
    } else if (!strcmp(cmd, "mul")) {
      Mul(x, y);
    } else if (!strcmp(cmd, "jnz")) {
      if (Jnz(x, y)) {
        --pc_;
      }
    }
    ++pc_;
  }

  void Set(char x, long long y) {
    reg_[x] = y;
  }

  void Sub(char x, long long y) {
    reg_[x] -= y;
  }

  void Mul(char x, long long y) {
    reg_[x] *= y;
    ++count_mul_;
  }

  bool Jnz(char x, long long y) {
    long long cmp;
    if ('1' <= x && x <= '9') {
      cmp = x - '0';
    } else if ('a' <= x && x <= 'z') {
      cmp = reg_[x];
    }
    if (cmp != 0) {
      pc_ += y;
      return true;
    }
    return false;
  }

 private:
  bool finished_;
  int count_mul_;
  long long pc_;
  queue<long long> q_;
  map<char, long long> reg_;
  const vector<char*>& in_;
};

class Cpu {
 public:
  Cpu(const vector<char*>& in) {
    p_ = new Process(in);
  }

  ~Cpu() {
    delete p_;
  }

  void Tick() {
    while (true) {
      if (p_->finished()) {
        printf("%d\n", p_->count_mul());
        break;
      }

      p_->Tick();
    }
  }

 private:
  Process* p_;
};

int main() {
  vector<char*> in;
  while (true) {
    char* buf = new char[16];
    if (scanf("%[^\n]\n", buf) == EOF) {
      delete[] buf;
      break;
    }
    in.push_back(buf);
  }

  Cpu cpu(in);
  cpu.Tick();

  for (size_t i = 0; i < in.size(); ++i) {
    delete[] in[i];
  }
  return 0;
}
