import sys


def process(s: str):
    s = s.upper().strip()
    s = " ".join(s.split())
    for c in "()[]{}.,;:":
        s = s.replace(c + " ", c).replace(" " + c, c)
    for c in "[{":
        s = s.replace(c, "(")
    for c in "]}":
        s = s.replace(c, ")")
    s = s.replace(";", ",")

    return s


n = int(input())


for i in range(1, n + 1):
    print(f"Data Set {i}: ", end="")
    a = sys.stdin.readline()
    b = sys.stdin.readline()
    if process(a) == process(b):
        print("equal\n")
    else:
        print("not equal\n")
