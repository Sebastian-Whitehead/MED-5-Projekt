import csv

collecter = []
holder = []
with open('Saved_data.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')

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