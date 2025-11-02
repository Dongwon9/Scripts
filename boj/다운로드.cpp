#include <bits/stdc++.h>
using namespace std;
int main() {
    cin.tie(nullptr);
    ios_base::sync_with_stdio(false);
    int n;
    cin >> n;
    vector<int> length(n), dl(n);
    int waiting_time = 0;
    int dl_left = 0;
    for (int i = 0; i < n; ++i) {
        cin >> length[i] >> dl[i];
        dl_left += dl[i];
        if (dl_left > 0) {
            waiting_time += dl_left;
            dl_left = 0;
        }
        dl_left -= length[i];
    }
    cout << waiting_time;
}