#include <cstdio>
#include <cstring>
#include <map>
#include <vector>

using namespace std;

class Cpu {
 public:
  Cpu(vector<char*>* in) : pc_(0), in_(in) {
  }

  void Tick() {
    while (true) {
      //printf("%d\n", pc_);
      if (pc_ < 0 || in_->size() <= pc_) {
        break;
      }

      char cmd[4], x;
      sscanf((*in_)[pc_], "%s %c", cmd, &x);

      long long y = 0;
      if (strcmp(cmd, "snd") && strcmp(cmd, "rcv")) {
        char buf[16];
        sscanf((*in_)[pc_], "%*s %*c%s", buf);
        if ('a' <= buf[0] && buf[0] <= 'z') {
          y = reg_[buf[0]];
        } else {
          sscanf(buf, "%lld", &y);
        }
      }

      if (!strcmp(cmd, "snd")) {
        Snd(x);
      } else if (!strcmp(cmd, "set")) {
        Set(x, y);
      } else if (!strcmp(cmd, "add")) {
        Add(x, y);
      } else if (!strcmp(cmd, "mul")) {
        Mul(x, y);
      } else if (!strcmp(cmd, "mod")) {
        Mod(x, y);
      } else if (!strcmp(cmd, "rcv")) {
        if (Rcv(x)) {
          printf("%lld\n", rcv_freq_);
          break;
        }
      } else if (!strcmp(cmd, "jgz")) {
        if (Jgz(x, y)) {
          --pc_;
        }
      }
      ++pc_;
    }
  }

  void Snd(char x) {
    last_freq_ = reg_[x];
  }

  void Set(char x, long long y) {
    reg_[x] = y;
  }

  void Add(char x, long long y) {
    reg_[x] += y;
  }

  void Mul(char x, long long y) {
    reg_[x] *= y;
  }

  void Mod(char x, long long y) {
    reg_[x] %= y;
  }

  bool Rcv(char x) {
    if (reg_[x] != 0) {
      rcv_freq_ = last_freq_;
      return true;
    }
    return false;
  }

  bool Jgz(char x, long long y) {
    if (reg_[x] > 0) {
      pc_ += y;
      return true;
    }
    return false;
  }

 private:
  long long last_freq_;
  long long rcv_freq_;
  long long pc_;
  map<char, long long> reg_;
  vector<char*>* in_;
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

  Cpu cpu(&in);
  cpu.Tick();

  for (size_t i = 0; i < in.size(); ++i) {
    delete[] in[i];
  }
  return 0;
}
