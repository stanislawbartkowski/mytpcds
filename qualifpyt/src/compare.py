import logging
import argparse
import sys
from decimal import Decimal
from decimal import InvalidOperation
import datetime

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.INFO)


def reportnotmatch(i, line1, line2, errmess):
    logging.info(line1)
    logging.info(line2)
    logging.info("Line number: {0} {1}".format(i, errmess))
    sys.exit(1)


def columnsnotmatch(i, line1, line2, j, col1, col2, errmess):
    reportnotmatch(i, line1, line2, "Columns: {0} does not match {1} => {2} {3}".format(
        j, col1, col2, errmess))


def decimalnotmatch(d1, d2):
    d = abs(d1 - d2)
    # be merciful for difference less then 0.5
    return d >= Decimal(0.5)


def isdecimal(s):
    try:
        d = Decimal(s)
        return (True, d)
    except InvalidOperation:
        return (False, None)


def isdate(s):
    try:
        d = datetime.datetime.strptime(s, '%Y-%m-%d')
        return (True, d)
    except ValueError:
        pass
    try:
        d = datetime.datetime.strptime(s, '%Y-%m')
        return (True, d)
    except ValueError:
        return (False, None)


def datenotmatch(d1, d2):
    return d1.year != d2.year or d1.month != d2.month

def equalnull(col1,col2) :
    if col1 == "NULL" and col2 == "0": return True
    if col1 == "0" and col2 == "NULL": return True
    return col1 == "NULL" and col2 == "NULL"

def compare(file1, file2):
    with open(file1, 'r') as f1, open(file2, "r") as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

    if len(lines1) != len(lines2):
        logging.info("Number of lines does not match {0} => {1}".format(
            len(lines1), len(lines2)))
        sys.exit(1)

    for i in range(len(lines1)):
        line1 = lines1[i]
        line2 = lines2[i]
        fields1 = line1.split("|")
        fields2 = line2.split("|")
        if len(fields1) != len(fields2):
            reportnotmatch(i, line1, line2, "Number of columns does not match {0} => {1}".format(
                len(fields1), len(fields2)))
        for j in range(len(fields1)):
            col1 = fields1[j].strip()
            col2 = fields2[j].strip()

            if equalnull(col1,col2) : continue

            (isdecimal1, d1) = isdecimal(col1)
            (isdecimal2, d2) = isdecimal(col2)
            if isdecimal1:
                if isdecimal2:
                    if decimalnotmatch(d1, d2):
                        columnsnotmatch(
                            i, line1, line2, j, col1, col2, " Numeric values does not match {0} => {1}".format(d1, d2))
                    continue
                columnsnotmatch(i, line1, line2, j, col1, col2,
                                "First columns is numeric, the second not")
                continue
            if isdecimal2:
                columnsnotmatch(i, line1, line2, j, col1, col2,
                                "Second columns is numeric, the first not")

            (isdate1, dd1) = isdate(col1)
            (isdate2, dd2) = isdate(col2)
            if isdate1:
                if isdate2:
                    if datenotmatch(dd1, dd2):
                        columnsnotmatch(
                            i, line1, line2, j, col1, col2, " Date values does not match {0} => {1}".format(dd1, dd2))
                    continue
                columnsnotmatch(i, line1, line2, j, col1, col2,
                                "First columns is date, the second not")
                continue
            if isdate2:
                columnsnotmatch(i, line1, line2, j, col1, col2,
                                "Second columns is date, the first not")

            if col1 != col2:
                reportnotmatch(
                    i, line1, line2, "Columns: {0} does not match {1} => {2}".format(j, col1, col2))


def args():
    parser = argparse.ArgumentParser("compare")
    parser.add_argument('file1', nargs=1, help='First file to compare')
    parser.add_argument('file2', nargs=1, help='Second file to compare')
#    args = parser.parse_args(
#        ['/home/sbartkowski/work/mytpcds/qualifres/query51.res', '/tmp/tpcds/oracleresult0/query51.res'])
#        ['/home/sbartkowski/work/mytpcds/qualifres/query1.res', '/tmp/tpcds/db2result0/query1.res'])
    args = parser.parse_args()
    file1 = args.file1[0]
    file2 = args.file2[0]
    return (file1, file2)


if __name__ == "__main__":
    (file1, file2) = args()
    logging.info("Comparing {0} => {1}".format(file1, file2))
    compare(file1, file2)
    logging.info("OK, matches")
