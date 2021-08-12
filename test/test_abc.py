from pyswip import Prolog
import os
import shutil
from pathlib import Path
import pathlib

abc_sub_path = 'contrib/abc/ABC_Datalog'
# note that need to adjust .. according to the current file path
get_abc_abs_path = lambda p: pathlib.Path(__file__).parent.resolve().__str__() + '/../' + p
abc_path = get_abc_abs_path(abc_sub_path)
src_path = f'{abc_path}/code'
thy_path = rf'{abc_path}/evaluation theories'


def util_copy_theory_file(src_path: str, theory_path: str, theory_name: str):
    src_thy_path = f'{theory_path}/{theory_name}'
    dst_thy_path = f'{src_path}/{theory_name}'

    with open(dst_thy_path, 'wb') as dst_thy:
        pl_working_dir = f':- working_directory(_, \'{src_path}\').'
        dst_thy.write(str.encode(pl_working_dir+'\n'))
        with open(src_thy_path, 'rb') as src_thy:
            shutil.copyfileobj(src_thy, dst_thy)


def util_del_theory_file(src_path: str, theory_name: str):
    thy_file = f'{src_path}/{theory_name}'
    if os.path.exists(thy_file):
        os.remove(thy_file)
    else:
        print(f"File {thy_file} does not exist")


if __name__ == '__main__':
    if_clean_thy = False
    thy_name = 'familiesh.pl'
    abc_main_path = f'{src_path}/main'
    abc_thy_path = f'{src_path}/{thy_name}'
    q = 'abc'

    print(abc_main_path)
    prolog = Prolog()
    # prolog.consult(abc_main_path)
    # copy theory file to the source code path
    util_copy_theory_file(src_path, thy_path, thy_name)
    # create log dir if not exists
    Path(f'{src_path}/log').mkdir(parents=True, exist_ok=True)
    prolog.consult(abc_thy_path)
    r = prolog.query(q)

    print(f'|--query results for {q}:')
    for i in r:
        print(i)

    if if_clean_thy:
        util_del_theory_file(src_path, thy_name)

