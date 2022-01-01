from enum import Enum

class RUNRESULT(str,Enum) :

    PASSED = "PASSED",
    FAILED = "FAILED",
    TIMEOUT = "TIMEOUT"

class TPCRUN :

    def __init__(self,querynum : int,sec : int, result : RUNRESULT) :
        self.querynum = querynum
        self.sec = sec
        self.result = result