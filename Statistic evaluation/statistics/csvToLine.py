import csv

collecter = []
holder = []

path = "..\..\VR 2 trying again\Assets\CSV\Saved_data.csv"
path = "data_-_Copy_NormalisedOnly.csv"
path = "data.csv"

saveFile = 'oneLineLocations_non-normalized.csv'

with open(path, newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')

    for row in spamreader:
        row = ' '.join(row)
        if row == "New Participant,,":
            if len(holder) > 0:
                collecter.append(holder)
            holder = []
        elif len(row) > 0:
            holder.append(row)

    with open(saveFile, 'w') as f:
        writer = csv.writer(f, delimiter=',', escapechar=' ', quoting=csv.QUOTE_NONE)
        writer.writerows(collecter)
        print("Done", len(collecter))