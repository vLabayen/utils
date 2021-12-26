#!/bin/python3

from data2latex import *
import pickle

print(basic_table(
	header = ['Temperatura', 'RTD', 'NTC'],
	data = [
		[0, 0, 0],
		[1, 10, 20],
		[2, 20, 40],
		[3, 30, 60]
	]
))

print(basic_table(
        header = ['Temperatura', 'RTD', 'NTC'],
        data = [
                [0, 0, 0],
                [1, 10, 20],
                [2, 20, 40],
                [3, 30, 60]
        ],
	orientation = 'h'
))

print(header_in_merged_rows_table(
	header = ['Valores reales', 'Valores medidos'],
	columns = [0, 100, 200, 300],
	data = [
		[38, 130, 230, 350],
		[40, 123, 235, 340],
		[50, 126, 240, 330]
	],
	width = "6.5cm"
))


with open('/media/shared/master/tvm/proyecto/final2/imgs/test/1607284763/params.pickle', 'rb') as f:
	d = pickle.load(f)['matcher']
	d['mode'] = 'HH'

print(basic_table(
	header = ['Parámetro'] + list(d.keys()),
	data = [['Valor'] + list(d.values())],
	orientation = 'h'
))

with open('/media/shared/master/tvm/proyecto/final2/imgs/test/1607289617/params.pickle', 'rb') as f:
	d = pickle.load(f)
	print(d)
