def basic_table(header, data, orientation="v", caption="caption", label="label"):
	common_header = ['\\begin{table}[H]\n', '\\setlength{\\tabcolsep}{18pt}\n', '\\centering\n']
	common_tail = ['\\end{tabular}\n', '\\caption{}{}{}\n'.format('{', caption, '}'), '\\label{}{}{}\n'.format('{', 'tab:{}'.format(label), '}'), '\\end{table}\n']

	if orientation == 'v':
		table_text = common_header + [
			'\\begin{tabular}{ c | '+ ' '.join('c'*(len(header) - 1)) +' }\n',
			'{} \\\\\n'.format(' & '.join(header)),
			'\\hline\n'
		] + ['{} \\\\\n'.format(' & '.join(str(v) for v in d)) for d in data] + common_tail

	else:
		head = [header[0]] + [d[0] for d in data]
		cells = [([header[i]] + [d[i] for d in data]) for i in range(1, len(header))]
		table_text = common_header + [
			'\\begin{tabular}{ c | '+ ' '.join('c'*(len(head) - 1)) +' }\n',
			'{} \\\\\n'.format(' & '.join(str(h) for h in head)),
			'\\hline\n'
		] + ['{} \\\\\n'.format(' & '.join(str(v) for v in d)) for d in cells] + common_tail

	return ''.join(table_text)

def header_in_merged_rows_table(header, columns, data, width, caption="caption", label="label"):
	table_header = [
		'\\begin{table}[H]\n',
		'\\centering\n',
		'\\begin{tabularx}{'+str(width)+'}{ c | '+' '.join('c'*len(columns))+' }\n',
		'\\shortstack{'+header[0]+'} & ' + ' & '.join(str(c) for c in columns) + ' \\\\\n'
		'\\hline\n'
	]
	first_row = '\\multirow{'+str(len(data))+'}{*}{\\shortstack{'+header[1]+'}} & ' + ' & '.join(str(v) for v in data[0]) + ' \\\\\n'
	other_rows = ['& ' + ' & '.join(str(v) for v in d) + ' \\\\\n' for d in data[1:]]
	table_tail = [
		'\\end{tabularx}\n',
		'\\caption{'+caption+'}\n',
		'\\label{tab:'+label+'}\n',
		'\\end{table}\n'
	]

	table_text = table_header + [first_row] + other_rows + table_tail
	return ''.join(table_text)
