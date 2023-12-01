import csv
import sys

def checkSeconds(count, prev, arr):
    if prev == 0:
        return count

    prev = prev.split(":")
    min = int(prev[0])
    sec = float(prev[1])

    current = arr[0]
    current = current.split(":")
    current = float(current[1])

    while current - sec > 0.1:

        sec = round(float(sec) + 0.050000, 6)

        if sec >= 60:
            sec = round(float(sec) - 60, 6)
            min += 1

        with open(name, 'a') as csv:
            # Set Row Names
            csv.write(f"{count},{min}:{sec},{arr[1]},{arr[12]},{0.0}\n")

        count += 1

    return count

#Create CSV File
name = sys.argv[1]
cnt, seconds, pid, command, cpu = 0, 0, 0, 0, 0

with open(name, 'w') as csv:
    # Set Row Names
    csv.write("CNT,SECONDS,PID,COMMAND,%CPU\n")

with open('outputs/cpu_usage.log', 'r') as log:
    lines = log.readlines()

    for line in lines:
        #Remove '\n' from the end of the line
        line = line.strip("\n")
        line = line.split(",")

        cnt += 1

        cnt = checkSeconds(cnt, seconds, line)

        seconds = line[0]
        pid = line[1]
        command = line[12]
        cpu = line[9]


        line = f"{cnt},{seconds},{pid},{command},{cpu}"

        with open(name, 'a') as csv:
            #Set Row Names
            csv.write(f"{line}\n")

