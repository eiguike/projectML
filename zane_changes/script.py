import csv

rows = []

def codeToMany(codeStr, total):
	code = int(codeStr)

	output = ""
	for i in range(code):
		output += "0,"

	output += "1,"

	for i in range(total - code - 1):
		output += "0,"

	return output[:-1]

def pdays(days):
	if (days == "999"):
		return "50"
	return days

class Amostra():
	def __init__(self, row):
		self.age = 				row[0]
		self.job = 				codeToMany(row[1], 11)
		self.marital = 			codeToMany(row[2], 3)
		self.education = 		row[3]
		self.housing = 			row[4]
		self.loan = 			row[5]
		self.contact = 			row[6]
		self.month = 			row[7]
		self.day_of_week = 		row[8]
		self.duration = 		row[9]
		self.campaign = 		row[10]
		self.pdays = 			pdays(row[11])
		self.previous = 		row[12]
		self.poutcome = 		codeToMany(row[13], 3)
		self.empvarrate = 		row[14]
		self.conspriceidx = 	row[15]
		self.consconfidx = 		row[16]
		self.euribor = 			row[17]
		self.nremployed = 		row[18]
		self.classe = 			row[19]

	def toRow(self):
		row = ""

		row += self.age + ","
		row += self.job + ","
		row += self.marital + ","
		row += self.education + ","
		row += self.housing + ","
		row += self.loan + ","
		row += self.contact + ","
		row += self.month + ","
		row += self.day_of_week + ","
		row += self.duration + ","
		row += self.campaign + ","
		row += self.pdays + ","
		row += self.previous + ","
		row += self.poutcome + ","
		row += self.empvarrate + ","
		row += self.conspriceidx + ","
		row += self.consconfidx + ","
		row += self.euribor + ","
		row += self.nremployed + ","
		row += self.classe + "\n"

		return row


with open('base.csv') as csvfile:
	csv_reader = csv.reader(csvfile, delimiter=',')
	f = open('basefinal.csv', 'a')
	f.write("age,bool_admin,bool_blue, bool_entrep, bool_housemaid,bool_management,bool_retired,")
	f.write("bool_self, bool_services,bool_student, bool_tech, bool_unempl, bool_single, bool_married, bool_divorced,")
	f.write("education, housing, loan, contact, month, day_of_week, duration, campaign, pdays, previous, ")
	f.write("bool_nonexistant, bool_fail, bool_success, empvarrate, conspriceidx, consconfidx, euribor, nremployed, class\n")
	for row in csv_reader:
		x = Amostra(row).toRow()
		f.write(x)
	f.close()

c = raw_input()