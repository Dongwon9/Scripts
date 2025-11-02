#include <bits/stdc++.h>
using namespace std;
const set<char> open = { '(','[','{' };
const set<char> closing = { ')',']','}' };
const set<char> colons = { ',',';' };
char upper(char a) {
    return a >= 'A' && a <= 'Z' ? a : a - ('a' - 'A');
}

bool format_check(char a, char b) {
    return ((open.contains(a) && open.contains(b)) ||
        (closing.contains(a) && closing.contains(b)) ||
        colons.contains(a) && colons.contains(b) ||
        a == b ||
        upper(a) == upper(b));
}
int main() {
    cin.tie(nullptr);
    ios_base::sync_with_stdio(false);
    int n;cin >> n;
    cin.ignore();
    for (int i = 1;i <= n;i++) {
        bool equal = true;
        cout << "Data set " << i << ": ";
        string a, b;
        getline(cin, a);
        getline(cin, b);
        int i_a = 0, i_b = 0;
        while (a[i_a] == ' ') {
            i_a++;
        }
        while (b[i_b] == ' ') {
            i_b++;
        }
        while (i_a < a.size() && i_b < b.size()) {
            if (!format_check(a[i_a], b[i_b])) {
                equal = false;
                break;
            }
            if (a[i_a] == ' ' && b[i_b] == ' ') {
                while (a[i_a] == ' ') {
                    i_a++;
                }
                while (b[i_b] == ' ') {
                    i_b++;
                }
            }
            else {
                i_a++;
                i_b++;
            }
        }
        if (equal) {
            cout << "equal\n\n";
        }
        else {
            cout << "not equal\n\n";
        }

    }

}