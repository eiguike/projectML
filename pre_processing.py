import os
import pandas as pd

data_path = os.path.join(os.path.dirname(__file__), 'data', 'bank-additional-full.csv')


class Data:
    attributes_to_discard = ['duration']

    categorical_attributes = [
        'job', 'marital', 'education', 'default', 'housing', 'loan',
        'contact', 'month', 'day_of_week', 'poutcome'
    ]

    def __init__(self, data_path):
        self.frame = pd.read_csv(data_path, sep=';')

    def discard_attributes(self):
        for attr in self.attributes_to_discard:
            del self.frame[attr]

    def transform_class_attribute(self):
        self.frame['y'].replace(('yes', 'no'), (1, 0), inplace=True)

    def transform_categorical_attributes(self):
        self.dummies_frame = pd.get_dummies(self.frame)

    def export(self):
        self.dummies_frame.to_csv(
            os.path.join(os.path.dirname(__file__), 'data', 'processed_additional_full.csv'),
            sep=';', index=False)


if __name__ == '__main__':
    data = Data(data_path)

    data.discard_attributes()
    data.transform_class_attribute()
    data.transform_categorical_attributes()
    data.export()
