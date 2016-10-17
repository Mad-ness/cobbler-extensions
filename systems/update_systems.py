#!/usr/bin/env python

import os
import sys
import yaml
import subprocess

def load_yaml(filename): 
	result = {}
	with open(filename, 'r') as fd:
		result = yaml.load(fd)	
	return result





if __name__ == "__main__":
	y = load_yaml(sys.argv[1])
	print (y)
	pass

