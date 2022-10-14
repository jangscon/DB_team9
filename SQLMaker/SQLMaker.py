
'''
INSERT 할 value들 생성 (랜덤)
'''
def GetRandomSubscriber(min=10000,max=5000000,sbnum=1) :
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



'''
테스트 코드
'''
def test_SQL() :
    input = [
        (1, "jack", "apple", 220000),
        (2, "bob", "banana", 300000),
        (3, "jim", "grape", 120000)
    ]
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


