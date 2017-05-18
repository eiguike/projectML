import csv
import statistics
import math

def isfloat(value):
    try:
        float(value)
        return True
    except ValueError:
        return False

database = {'age':[], 'job':[], 'marital':[], 'education':[], 'default':[], 'housing':[], 'loan':[], 'contact':[], 'month':[], 'day_of_week':[], 'duration':[], 'campaign':[], 'pdays':[], 'previous':[], 'poutcome':[], 'emp.var.rate':[], 'cons.price.idx':[], 'cons.conf.idx':[], 'euribor3m':[], 'nr.employed':[], 'y':[]}

vector = []

with open('bank-additional-full.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='"')
    count = 0
    for row in spamreader:
        if count == 0:
            for row2 in row:
                vector.append(row2)
                count = count + 1
        else:
            count = 0
            for row2 in row:
                # is integer
                if row2.isdigit():
                    database[vector[count]].append(int(row2))
                # is float
                elif isfloat(row2):
                    database[vector[count]].append(float(row2))
                # is string
                else:
                    database[vector[count]].append(row2)
                count = count + 1

print("Mínimo idade: ", min(database['age']))
print("Máximo idade: ", max(database['age']))
print("Média: ", statistics.mean(database['age']))
print("Variance: ", statistics.variance(database['age']))
print("Desvio Padrão: ", statistics.stdev(database['age']))
