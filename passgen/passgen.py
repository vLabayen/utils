#!/bin/python3

from random import randint
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-l', '--length', help="Password length", default=30, type=int)
parser.add_argument('-a', '--alphabet', help="Password alphabet", default="qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!¡()?¿{}[]<>|@#$%&/=+*-_.:;,", type=str)
args = parser.parse_args()

print(''.join([args.alphabet[randint(0, len(args.alphabet) - 1)] for _ in range(args.length)]))
