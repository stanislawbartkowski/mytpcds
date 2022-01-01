from typing import List
import urllib.request, os
from util.mytype import RUNRESULT, TPCRUN
import logging
import re

__BASEPATH = "https://raw.githubusercontent.com/stanislawbartkowski/mytpcds/master/img"
__RESNO = 99


def __readgitfile(url: str) -> List[str]:
    logging.info("Reading %s".format(url))
    response = urllib.request.urlopen(url, timeout=5)
    data = response.read()
    return data.decode('utf-8').splitlines()


def __critical(mess: str):
    logging.critical(mess)
    raise Exception(mess)


def __readraw(fname: str) -> List[str]:
    urlname = os.path.join(__BASEPATH, fname)
    res: List[str] = __readgitfile(urlname)
    return res


def __toTPCRUN(line: str) -> TPCRUN:
    fields = line.split("|")
    if len(fields) != 5:
        logging.critical(res[i])
        mess = "Line {0} number of columns wrong, got {1}, expected {2}".format(
            i, len(fields), 3)
        __critical(mess)
    query: str = fields[1].strip()
    querynos = re.findall(r'query(\d+)', query)[0]
    queryno = int(querynos)
    sec: int = int(fields[2].strip())
    result: str = fields[3].strip()
    return TPCRUN(queryno, sec, RUNRESULT(result))


def readtpcrun(fname: str) -> List[RUNRESULT]:
    res: List[str] = __readraw(fname)
    if len(res) != __RESNO + 1:
        mess = "Numer of lines in {0} {1} is different then expected {2}".format(
            fname, len(res), __RESNO + 1)
        __critical(mess)
    logging.info("Transform %d lines".format(len(res)))
    tpcres: List[RUNRESULT] = [__toTPCRUN(res[i]) for i in range(__RESNO - 1)]
    return tpcres
