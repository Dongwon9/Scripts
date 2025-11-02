#include <bits/stdc++.h>
using namespace std;
string action(string s) {
    int balance = 0, open_count = 0, close_count = 0;
    for (int i = 0;i < s.size();i++) {
        if (s[i] == '(') {
            balance++;
            open_count++;
        }
        else if (s[i] == ')') {
            balance--;
            close_count++;
        }
        else {
            string s1 = s, s2 = s;
            s1[i] = '(';
            s2[i] = ')';
            string ret = action(s1);
            return ret.size() > 0 ? ret : action(s2);
        }
        if (balance<0 || open_count>s.size() / 2 || close_count > s.size() / 2) {
            return "";
        }
    }
    return s;
}
int main() {
    cin.tie(nullptr);
    ios_base::sync_with_stdio(false);
    int n;
    cin >> n;
    string s;
    cin >> s;
    s[0] = '(';
    s[n - 1] = ')';
    cout << action(s);
}
