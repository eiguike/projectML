import csv
import statistics
import math

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

def transform(values):
    return

def main():
    with open('./result/bank_cleaned.csv', newline='') as csvfile:
        row_count = 0
        csv_reader = csv.reader(csvfile, delimiter=';')

        for row in csv_reader:

            if row_count == 0:
                row_count += 1
                continue

            column_count = 0
            for column in row:
                if column_count == 0:
                    if int(column) < 100:
                        print("bimba")
                elif (column_count == 9): # duration
                    column_count += 1
                    continue
                elif (column_count == 10): # campaign
                    column_count += 1
                    continue
                elif (column_count == 11): # pdays
                    column_count += 1
                    continue
                elif (column_count == 12): # previous
                    column_count += 1
                    continue
                elif (column_count == 13): # previous
                    column_count += 1
                    continue
                elif (column_count == 14): # previous
                    column_count += 1
                    continue
                elif (column_count == 15): # previous
                    column_count += 1
                    continue
                elif (column_count == 16): # previous
                    column_count += 1
                    continue
                elif (column_count == 17): # previous
                    column_count += 1
                    continue
                elif (column_count == 18): # previous
                    column_count += 1
                    continue
                elif (column_count == 19): # previous
                    column_count += 1
                    continue
                else:
                    print(column)
                    print(vector[column_count][column])
                    print("--------------------")

                column_count += 1
            row_count += 1


main()



