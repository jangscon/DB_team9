

GENRE = [
    "Animation","Beuty and Makeup","Comedy","Critics","Review","DIY","Education",
    "Fashion","Food and Cooking","Gaming","Health and Fitness","Music","News",
    "Podcaster","Sports","Technology","Vlogger","Science","Lifestyle"
]

EMAIL = ["naver","gmail","yahoo","outlook","nate","korea","daum"]



'''
INSERT 할 value들 생성 (랜덤)
'''
def GetRandomInt(min=10000,max=5000000,sbnum=1) :
    '''
    랜덤한 구독자 수 생성하는 코드입니다.
    sbnum은 랜덤으로 생성할 숫자의 수 입니다.
    1명만 하고싶다 하면 sbnum=1 로 해서 단일 int 값 나올겁니다.
    10명만 하고싶다 하면 sbnum=10 으로 해서 리스트에 int값 10개 들어있는게 나올겁니다.
    -1 , 0 , 12.3 이렇게 양의 자연수 아니면 넣지 마세요

    min , max는 랜덤 돌릴때 최소,최대값 설정입니다.
    초기값은 각각 10000 , 5000000 입니다.
    '''

    from random import randrange
    if not isinstance(sbnum , int) :
        return None
    elif sbnum <= 0 :
        return None

    if sbnum == 1 :
        return randrange(min , max+1)
    else :
        result = [ randrange(min , max+1) for _ in range(sbnum)]
        return result

def GetRandomNumnericID(length=8,idnum=1) :

    from string import digits
    from random import choice

    randDigits = digits

    if not isinstance(idnum, int):
        print("정수가 아닙니다.")
        return None
    elif idnum <= 0:
        print("0보다 작습니다.")
        return None

    if idnum == 1 :
        return ''.join(choice(randDigits) for i in range(length))
    else :
        result = [''.join(choice(randDigits) for i in range(length)) for _ in range(idnum)]
        while True :
            if len(set(result)) == idnum :
                break
            else :
                print("중복발생!!")
                result = list(set(result))
                result.extend([''.join(choice(randDigits) for i in range(length)) for _ in range(idnum - len(result))])

        return result

def GetRandomNames(namenum=1 , nametype="FULL") :
    import names

    if not isinstance(namenum, int):
        print("정수가 아닙니다.")
        return None
    elif namenum <= 0:
        print("0보다 작습니다.")
        return None

    if nametype == "FULL" :
        nameGenerator = names.get_full_name
    elif nametype == "FIRST" :
        nameGenerator = names.get_first_name
    else :
        nameGenerator = names.get_last_name

    if namenum == 1 :
        return nameGenerator()
    else :
        return [nameGenerator() for _ in range(namenum)]

def GetRandomChoice(valuelist , resultnum=1) :
    '''
    값이 정해져 있는 리스트에서 무작위 값을 선택하고 싶을때 사용

    ex) input :
        valuelist = ['A' , 'B' , 'AB' , 'O']
        resultnum = 10
        10명에게 혈액형 속성을 무작위로 주고 싶을 때 사용하면

        output :
            ['AB', 'AB', 'B', 'AB', 'A', 'O', 'AB', 'O', 'AB', 'B']
        이렇게 무작위로 값들이 선택되어 나온다.
    '''

    import random

    if not isinstance(resultnum, int):
        print("정수가 아닙니다.")
        return None
    elif resultnum <= 0:
        print("0보다 작습니다.")
        return None

    if resultnum == 1 :
        return random.choice(valuelist)
    else :
        return [random.choice(valuelist) for _ in range(resultnum)]

def GetRandomPassword(minlen=8 , maxlen=20 , passnum=1) :
    import random

    alph = list('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@')

    if not isinstance(passnum, int):
        print("정수가 아닙니다.")
        return None
    elif passnum <= 0:
        print("0보다 작습니다.")
        return None

    if passnum == 1 :
        result = ""
        passlen = random.randrange(minlen, maxlen + 1)
        return "".join(random.choice(alph) for _ in range(passlen))
    else :
        result = []
        for _ in range(passnum) :
            passlen = random.randrange(minlen, maxlen + 1)
            temp = "".join(random.choice(alph) for _ in range(passlen))
            result.append(temp)

        return  result

def GetRandomNickname(nicknum=1) :
    from random_username.generate import generate_username

    if not isinstance(nicknum, int):
        print("정수가 아닙니다.")
        return None
    elif nicknum <= 0:
        print("0보다 작습니다.")
        return None

    if nicknum == 1 :
        return generate_username(1)[0]
    else :
        return generate_username(nicknum)

''' jkas1234 <= 이런식으로 ID 만들어 줌 '''
def GetRandomMixID(alphabetnum=4,digitnum=4 , idnum=1) :
    import random
    import string

    if not isinstance(idnum, int):
        print("정수가 아닙니다.")
        return None
    elif idnum <= 0:
        print("0보다 작습니다.")
        return None

    if idnum == 1 :
        ap = ''.join(random.choice(string.ascii_letters) for _ in range(alphabetnum))
        dg = ''.join(str(random.randrange(1,10)) for _ in range(digitnum))
        return ap + dg
    else :
        result = []
        for _ in range(idnum) :
            ap = ''.join(random.choice(string.ascii_letters) for _ in range(alphabetnum))
            dg = ''.join(str(random.randrange(1, 10)) for _ in range(digitnum))
            result.append(ap+dg)
        while True :
            if len(set(result)) == idnum :
                break
            else :
                print("중복발생!!")
                result = list(set(result))
                for _ in range(idnum - len(result)) :
                    ap = ''.join(random.choice(string.ascii_letters) for _ in range(alphabetnum))
                    dg = ''.join(str(random.randrange(1, 10)) for _ in range(digitnum))
                    result.append(ap+dg)
        return result

def GetEmailByNames(namelist) :
    import random

    if isinstance(namelist , list) :
        result = []
        for i in namelist :
            result.append(f"{i}@{random.choice(EMAIL)}.com")
        return result



'''
SQL문 형식 설정 
'''
def StringWithQuotes(obj) :
    '''
    그냥 문자열에 ' < 이거로 감싸주는 거
    '''
    if obj is str :
        return f"\'{obj}\'"
    else :
        return obj

def GetValuesToString(value_tuple) :
    '''
    tuple의 value들 INSERT 문에 알맞은 형식으로 바꿔주는 기능입니다.
    아래  GetInsertSQLSentence 참고
    '''
    result = ""
    for i,v in enumerate(value_tuple) :
        result += f"{v}" if not isinstance(v,str) else f"\'{v}\'"
        result += ", " if i != len(value_tuple)-1 else " "
    return  result


'''
SQL문 생성 및 저장 
'''
def GetInsertSQLSentence(table_name , input_list) :
    '''
    주어진 정보로 SQL의 INSERT문 커맨드의 문자열들을 인자로 가지는 리스트를 반환합니다.

    ex)
    input :
        table_name = "employee"
        input_list = [
            # 순서 중요!!
            (1 , "jack" , "apple" , 220000),
            (2 , "bob" , "banana" , 300000),
            (3 , "jim" , "grape" , 120000)
        ]

        =>
    output :
        [
            "INSERT INTO EMPLOYEE VALUES (1 , 'jack' , 'apple' , 220000)",
            "INSERT INTO EMPLOYEE VALUES (2 , 'bob' , 'banana' , 300000)",
            "INSERT INTO EMPLOYEE VALUES (3 , 'jim' , 'grape' , 120000)"
        ]
    '''

    result = []

    for i in input_list :
        result.append(f"INSERT INTO {table_name.upper()} VALUES ({GetValuesToString(i)})")

    return result

def SQLsentenceToFile(result_list , filename="test.sql" ) :
    with open(filename , 'w') as f :
        for result in result_list :
            f.write(result+"\n")
        f.write("\n")

def USER_tuples(n=50) :
    user_id = GetRandomMixID(8,8,idnum=n)
    user_password = GetRandomPassword(passnum=n)
    name = GetRandomNames(namenum=n,nametype="FIRST")
    nickname = GetRandomNickname(nicknum=n )
    email = GetEmailByNames(namelist=name)

    return [pair for pair in zip(user_id , user_password , name , nickname , email)]



'''
테스트 코드
'''
def test_SQL() :
    input = USER_tuples()
    print("< 테스트용 입력 데이터들입니다. >")
    print(input)

    table_name = "employee"
    print("\n< GetInsertSQLSentence 함수 작동중입니다. >\n")
    result_list = GetInsertSQLSentence(table_name, input)
    print("< 결과값입니다. >")
    for i in result_list :
        print(i)
    print("\n< test.sql 작성 완료했습니다. 확인해보세요 >")
    SQLsentenceToFile(result_list=result_list)

test_SQL()

