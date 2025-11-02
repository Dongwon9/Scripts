#include "SORT.h"
#include <bits/stdc++.h>
using namespace std;
vector<int> vec;
void init(int T, int N)
{
	vec.resize(N);
	for (int i = 0; i < N; i++)
		vec[i] = i + 1;
}
void sorting()
{
	priority_queue<int, vector<int>, function<bool(int, int)>> pq(
		[](int x, int y)
		{ 
			if (x > y) {
				swap(x, y);
			}
			return compare(x, y); });

	for (int x : vec)
		pq.push(x);

	for (int i = 0; i < vec.size(); ++i)
	{
		vec[i] = pq.top();
		pq.pop();
	}
	for (int i = 0; i < vec.size(); ++i)
	{
		answer(i + 1, vec[i]);
	}
}
