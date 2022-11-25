import csv

collecter = []
holder = []
with open('Saved_data.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')

    # Convert "0,0,0" data points
    for i, row in enumerate(spamreader):
        row = ' '.join(row)
        if "0,0,0" in row:
            print(row)
            print()

    if True: exit()

    for row in spamreader:
        row = ' '.join(row)
        if row == "New Participant,,":
            if len(holder) > 0:
                collecter.append(holder)
            holder = []
        elif len(row) > 0:
            holder.append(row)

    with open('oneLineLocations.csv', 'w') as f:
        writer = csv.writer(f, delimiter=',', escapechar=' ', quoting=csv.QUOTE_NONE)
        writer.writerows(collecter)
        print("Done")