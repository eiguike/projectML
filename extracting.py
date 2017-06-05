import csv
import statistics
import math

def count_group(database, title):
    print(title.upper()+"------------------------------------")
    vector_group = {}
    for count in database[title]:
        if(count in vector_group):
            vector_group[count] += 1
        else:
            vector_group[count] = 1
    for count in vector_group:
        print(str(count)+": "+str(vector_group[count]))

def isfloat(value):
    try:
        float(value)
        return True
    except ValueError:
        return False

database = {'age':[], 'job':[], 'marital':[], 'education':[], 'default':[], 'housing':[], 'loan':[], 'contact':[], 'month':[], 'day_of_week':[], 'duration':[], 'campaign':[], 'pdays':[], 'previous':[], 'poutcome':[], 'emp.var.rate':[], 'cons.price.idx':[], 'cons.conf.idx':[], 'euribor3m':[], 'nr.employed':[], 'y':[]}
#database = {'age':[], 'job':[], 'marital':[], 'education':[], 'housing':[], 'loan':[], 'contact':[], 'month':[], 'day_of_week':[], 'duration':[], 'campaign':[], 'pdays':[], 'previous':[], 'poutcome':[], 'emp.var.rate':[], 'cons.price.idx':[], 'cons.conf.idx':[], 'euribor3m':[], 'nr.employed':[], 'y':[]}

vector = []
empty_attributes = {}
empty_lines = []

with open('./result/bank_clean.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='"')
    count = 0
    count2 = 1
    for row in spamreader:
        if count == 0:
            for row2 in row:
                vector.append(row2)
                count = count + 1
        else:
            count = 0
            for row2 in row:

                '''
                if(count == 4):
                    continue
                '''

                # is integer
                if row2.isdigit():
                    database[vector[count]].append(int(row2))
                # is float
                elif isfloat(row2):
                    database[vector[count]].append(float(row2))
                # is string
                else:
                    if(row2 == "unknown"):
                        if(count2 not in empty_lines) and (count != 4):
                            empty_lines.append(count2)

                        if(str(count2) in empty_attributes):
                            empty_attributes[str(count2)] += 1
                        else:
                            empty_attributes[str(count2)] = 1
                    else:
                        database[vector[count]].append(row2)
                count = count + 1
        count2 = count2 + 1

def create_new_csv(lines, columns):
    with open('./result/bank_clean.csv', newline='') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=";", quotechar='"')
        line_count = 1
        with open('./result/bank_cleaned.csv', 'w') as csvfile2:
            wr = csv.writer(csvfile2, delimiter=',', quotechar='"')
            for row in spamreader:
                vector = []
                column_count = 0

                if(line_count in lines):
                    line_count += 1
                    continue
                else:
                    for column in row:
                        if(column_count in columns):
                            column_count += 1
                            continue
                        vector.append(column)
                        column_count += 1

                    wr.writerow(vector)
                    line_count += 1
        with open('./result/bank_not_clean.csv', 'w') as csvfile2:
            wr = csv.writer(csvfile2, delimiter=',', quotechar='"')
            for row in spamreader:
                vector = []
                column_count = 0

                if(line_count not in lines):
                    line_count += 1
                    continue
                else:
                    for column in row:
                        if(column_count in columns):
                            column_count += 1
                            continue
                        vector.append(column)
                        column_count += 1

                    wr.writerow(vector)
                    line_count += 1

for empty_rows in empty_attributes:
    print(empty_rows+":"+str(empty_attributes[empty_rows]))
print("IDADE------------------------------------")
print("Mínimo idade: ", min(database['age']))
print("Máximo idade: ", max(database['age']))
print("Média: ", statistics.mean(database['age']))
print("Variance: ", statistics.variance(database['age']))
print("Desvio Padrão: ", statistics.stdev(database['age']))

for name in database:
    if(name != "age") and (name != "duration"):
        count_group(database, name)
print("-----------------------------------------")

create_new_csv(empty_lines,[4])
