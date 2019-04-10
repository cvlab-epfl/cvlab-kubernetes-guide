 
import os, time
from datetime import datetime
from pathlib import Path

print('Starting an example job!')
print(f'We are in {os.getcwd()}')

out_file_path = Path('/cvlabdata2/home/lis/kubernetes_example/job_result_' + datetime.now().isoformat())

print('Writing to file', out_file_path)

with out_file_path.open('w') as f_out:
	for step in range(5):
		time.sleep(1)
		msg = f'step {step} at {datetime.now().isoformat()}'
		print(msg)
		f_out.write(msg + '\n')

print('Job finished')
