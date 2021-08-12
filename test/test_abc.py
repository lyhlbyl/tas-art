from pyswip import Prolog
import os

abc_path = '../contrib/abc/ABC_Datalog/'
abc_main_path = f'{abc_path}/code/main'
theory_path = rf'{abc_path}/evaluation theories/familiesh'

if __name__ == '__main__':
    # with open(theory_path+'.pl') as f:
    #     for l in f:
    #         print(l)

    prolog = Prolog()
    prolog.consult(theory_path)
    prolog.consult(abc_main_path)


