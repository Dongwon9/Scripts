#include <bits/stdc++.h>
using namespace std;
int main() {
    cin.tie(nullptr);
    ios_base::sync_with_stdio(false);
    int y, x;cin >> y >> x;
    vector<string>mark(y);
    for (int i = 0;i < y;i++) {
        cin >> mark[i];
    }
    for (string s : mark) {
        for (int i = 0;i < x / 2;i++) {
            if (s[i] == 'B' || s[x - i - 1] == 'B') {
                s[i] = 'B';
                s[x - i - 1] = 'B';
            }
        }
    }
}