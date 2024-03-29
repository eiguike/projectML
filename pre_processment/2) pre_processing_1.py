import csv
import math
import random

age_group = {}
jobs = {"admin.": 0,"blue-collar": 1,"entrepreneur": 2,"housemaid": 3,"management": 4,"retired": 5,"self-employed": 6,"services": 7,"student": 8,"technician": 9,"unemployed": 10}
marital = {"single": 0, "married": 1, "divorced": 2}
education = {"illiterate": 0, "basic.4y": 1, "basic.6y": 2, "basic.9y": 3, "high.school": 4, "university.degree": 5, "professional.course": 6}
contact = {"telephone": 0, "cellular": 1}
yes_no = {"no": 0, "yes": 1}
poutcome = {"nonexistent": 0, "failure": 1, "success": 2}
month = {"jan":0, "feb": 1, "mar": 2, "apr":3, "may": 4, "jun":5, "jul": 6, "aug": 7, "sep": 8, "oct": 9, "nov": 10, "dec": 11}
days_week = {"mon": 0, "tue":1, "wed": 2, "thu": 3, "fri": 4}

vector = [{},jobs, marital, education, yes_no, yes_no, contact, \
        month, days_week, {}, {}, {}, {}, poutcome, \
        {}, {}, {}, {},{}, yes_no]

vector_not_in = [0,9,10,11,12,14,15,16,17,18]

vector_empty = []

responses = {"yes":0, "no":0}

def getKey(item):
    return item[19]

def main():
    with open('bank_cleaned.csv') as csvfile:
        row_count = 0
        csv_reader = csv.reader(csvfile, delimiter=',')

        for row in csv_reader:
            if row_count == 0:
                row_count += 1
                continue

            new_vector = []
            column_count = 0
            for column in row:
                if column_count in vector_not_in:
                    new_vector.append(column)
                else:
                    new_vector.append(vector[column_count][column])
                    if (column_count == 19):
                        responses[column] += 1

                column_count += 1
            vector_empty.append(new_vector)
            row_count += 1

    with open('bank_cleaned_preprocessed.csv', 'w') as csvfile2:
        wr = csv.writer(csvfile2, delimiter=',', quotechar='"')
        row_count = 0
        for row in vector_empty:
            wr.writerow(row)
'''
    vector_empty_sorted = sorted(vector_empty,key=getKey)
    vector_no = vector_empty_sorted[0:responses["no"]-1]
    vector_yes = vector_empty_sorted[responses["no"]:-1]

    vector_no = random.sample(vector_no, responses["yes"])

    new_vector = random.sample(vector_no + vector_yes, (2*responses["yes"])-1)

    with open('./result/bank_cleaned_preprocessed_balanced.csv', 'w') as csvfile2:
        wr = csv.writer(csvfile2, delimiter=',', quotechar='"')
        row_count = 0
        for row in new_vector:
            wr.writerow(row)
'''



main()



