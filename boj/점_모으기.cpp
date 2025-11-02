#include <bits/stdc++.h>
using namespace std;
#define x first
#define y second
int main() {
    cin.tie(nullptr);
    ios_base::sync_with_stdio(false);
    int n, m;
    cin >> n >> m;
    vector<pair<int, int>> dots;
    vector<int> v_x, v_y;
    for (int i = 0; i < m; i++) {
        int a, b;
        cin >> a >> b;
        dots.push_back({ a, b });
        v_x.push_back(a);
        v_y.push_back(b);
    }
    sort(v_x.begin(), v_x.end());
    sort(v_y.begin(), v_y.end());
    int mid_x = v_x[m / 2], mid_y = v_y[m / 2];
    long long dist_sum = 0;
    for (auto dot : dots) {
        dist_sum += abs(mid_x - dot.x) + abs(mid_y - dot.y);
    }
    cout << dist_sum;
}