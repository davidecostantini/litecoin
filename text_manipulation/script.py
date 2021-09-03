from collections import Counter

filter_lst = []

with open("nginx_logs", "r") as a_file:
  for line in a_file:
    lst = line.split(" ")
    filter_lst.append(lst[8])

print(Counter(filter_lst))

