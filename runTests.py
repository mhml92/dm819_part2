from inspect import getmembers
from pprint import pprint
import os

def var_dump(*x):
    for e in x:
        pprint(e)
        print("---------------")


def testTree(folder):
    for dirname, dirnames, filenames in os.walk('tests'):
        for subdirname in dirnames:
            for sub_dirname,sub_dirnames,sub_filenames in os.walk(os.path.join(dirname,subdirname)):
                for f in sub_filenames:
                    testData = f.split("_")
                    n = None
                    d = None
                    r = None
                    s = None
                    for i in range(len(testData)):

                        if testData[i] == "n":
                           n = testData[i+1]
                        elif testData[i] == "d":
                           d = testData[i+1]
                        elif testData[i] == "r":
                           r = testData[i+1]
                        elif testData[i] == "s":
                           s = testData[i+1].split(".")[0]

                    os.chdir(folder)

                    command = "lua test.lua " + os.path.join("..",dirname, subdirname,f) + " -R"
                    os.system(command)
                    os.chdir("..")

testTree("rangeTree")
