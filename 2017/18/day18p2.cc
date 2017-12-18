#include <cstdio>
#include <cstring>
#include <map>
#include <queue>
#include <vector>

using namespace std;

class Process {
 public:
  Process(const vector<char*>& in, long long id)
      : finished_(false), waiting_(false), count_snd_(0), pc_(0), in_(in) {
    reg_['p'] = id;
  }

  bool finished() const {
    return finished_;
  }

  bool locked() const {
    return waiting_ && q_.empty();
  }

  int count_snd() const {
    return count_snd_;
  }

  void set_other(Process* other) {
    other_ = other;
  }

  void Tick() {
    if (pc_ < 0 || in_.size() <= pc_) {
      finished_ = true;
      return;
    }

    char cmd[4], x;
    sscanf(in_[pc_], "%s %c", cmd, &x);

    long long y = 0;
    if (strcmp(cmd, "snd") && strcmp(cmd, "rcv")) {
      char buf[16];
      sscanf(in_[pc_], "%*s %*c%s", buf);
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
      Rcv(x);
      if (waiting_) {
        --pc_;
      }
    } else if (!strcmp(cmd, "jgz")) {
      if (Jgz(x, y)) {
        --pc_;
      }
    }
    ++pc_;
  }

  void Insert(long long y) {
    q_.push(y);
  }

  void Snd(char x) {
    ++count_snd_;
    other_->Insert(reg_[x]);
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

  void Rcv(char x) {
    if (q_.empty()) {
      waiting_ = true;
    } else {
      waiting_ = false;
      reg_[x] = q_.front();
      q_.pop();
    }
  }

  bool Jgz(char x, long long y) {
    long long cmp;
    if ('1' <= x && x <= '9') {
      cmp = x - '0';
    } else if ('a' <= x && x <= 'z') {
      cmp = reg_[x];
    }
    if (cmp > 0) {
      pc_ += y;
      return true;
    }
    return false;
  }

 private:
  bool finished_;
  bool waiting_;
  int count_snd_;
  long long pc_;
  Process* other_;
  queue<long long> q_;
  map<char, long long> reg_;
  const vector<char*>& in_;
};

class Cpu {
 public:
  Cpu(const vector<char*>& in) {
    p0_ = new Process(in, 0);
    p1_ = new Process(in, 1);
    p0_->set_other(p1_);
    p1_->set_other(p0_);
  }

  void Tick() {
    while (true) {
      if ((p0_->locked() && p1_->locked()) ||
          (p0_->finished() && p1_->finished())) {
        printf("%d\n", p1_->count_snd());
        break;
      }

      p0_->Tick();
      p1_->Tick();
    }
  }

  ~Cpu() {
    delete p0_;
    delete p1_;
  }

 private:
  Process* p0_;
  Process* p1_;
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
