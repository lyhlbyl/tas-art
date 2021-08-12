from pyswip import Prolog

if __name__ == '__main__':
    print('test calling prolog from python')
    prolog = Prolog()
    prolog.consult('family')
    q1 = 'female(X)'
    q2 = 'mother(X, harry)'

    ret = prolog.query(q1)

    print(f'|--query results for {q1}:')
    for r in ret:
        print(r)
