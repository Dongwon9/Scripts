y, x = map(int, input().split())
mark: list[str] = []
for _ in range(y):
    mark.append(input())
for s in mark:
    for i in range(len(s) // 2):
        if s[i] == "B" or s[-i - 1] == "B":
            s[i] = "B"
            s[-i - 1] = "B"
print(mark)
