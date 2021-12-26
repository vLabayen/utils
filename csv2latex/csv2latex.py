#!/bin/python3

import argparse
import sys
import os

sys.path.insert(0, os.path.abspath('src'))
from doc import doc_str, repo, usage_examples

parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter, epilog=usage_examples)
parser.add_argument('csv', help="Csv input file")
parser.add_argument('latex', help="Latex output file")
parser.add_argument('-s', '--separator', help="Csv separator character(s)", default=';')
parser.add_argument('-c', '--caption', help="Table caption", default="Caption")
parser.add_argument('-l', '--label', help="Table label", default="Label")
parser.add_argument('-o', '--orientation', help="Table orientation", default="v", choices=['v', 'h', 'vertical', 'horizontal'])
parser.add_argument('-f', '--table-format', help="Type of table to generate", default="basic", choices=['basic'])
parser.add_argument('-v', '--verbose', help="Display generated latex in stdout", default=False, action='store_true')
parser.add_argument('-d', '--doc', help="Display extended documentation", default=False, action='store_true')
args = parser.parse_args()

if args.doc:
	print(doc_str)
	print(usage_examples)
	sys.exit()

#Normalize orientation options
if args.orientation == 'vertical': args.orientation = 'v'
if args.orientation == 'horizontal': args.orientation = 'h'

#Write table handler
def write_table(header, data, args):
	if args.table_format == 'basic' : return write_basic_table(header, data, args)

#Write table types
def write_basic_table(header, data, args):
	common_header = ['\\begin{table}[H]\n', '\\setlength{\\tabcolsep}{18pt}\n', '\\centering\n']
	common_tail = ['\\end{tabular}\n', '\\caption{}{}{}\n'.format('{', args.caption, '}'), '\\label{}{}{}\n'.format('{', 'tab:{}'.format(args.label), '}'), '\\end{table}\n']

	if args.orientation == 'v': return common_header + [
		'\\begin{tabular}{ c | '+ ' '.join('c'*(len(header) - 1)) +' }\n',
		'{} \\\\\n'.format(' & '.join(header)),
		'\\hline\n'
	] + ['{} \\\\\n'.format(' & '.join(str(v) for v in d)) for d in data] + common_tail

	h = [header[0]] + [d[0] for d in data]
	l = [([header[i]] + [d[i] for d in data]) for i in range(1, len(header))]
	return common_header + [
		'\\begin{tabular}{ c | '+ ' '.join('c'*(len(h) - 1)) +' }\n',
		'{} \\\\\n'.format(' & '.join(h)),
		'\\hline\n'
	] + ['{} \\\\\n'.format(' & '.join(str(v) for v in d)) for d in l] + common_tail

#Read csv
with open(args.csv, 'r') as f:
	header = f.readline()[:-1].split(args.separator)
	data = [line[:-1].split(args.separator) for line in f]

#Generate table
table = ''.join(write_table(header, data, args))

#Show table if verbose
if args.verbose: print(table, end="")

#Write table
with open(args.latex, 'w') as f: f.write(table)
