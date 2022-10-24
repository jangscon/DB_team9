import random

GENRE = [
    "Animation", "Beauty", "Makeup", "Comedy", "Critics", "Review", "DIY", "Education",
    "Fashion", "Muckbang", "Cooking", "Gaming", "Health", "Fitness", "Music", "News",
    "Podcaster", "Sports", "Technology", "Vlogger", "Science", "Dance"
]
GENRE_index = [i for i in range(1, len(GENRE)+1)]

EMAIL = ["naver", "gmail", "yahoo", "outlook", "nate", "korea", "daum"]

CHARACTER = ["Actor", "Comedian", "Animation character", "Singer", "Critics",
             "Guest", "Streamer", "Animal", "Virtual Human", "Athlete", "ProGamer"]


'''
INSERT 할 value들 생성 (랜덤)
'''


def GetRandomInt(min=10000, max=5000000, sbnum=1):
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
    if not isinstance(sbnum, int):
        return None
    elif sbnum <= 0:
        return None

    if sbnum == 1:
        return randrange(min, max+1)
    else:
        result = [randrange(min, max+1) for _ in range(sbnum)]
        return result


def GetRandomNumnericID(length=8, idnum=1):

    from string import digits
    from random import choice

    randDigits = digits

    if not isinstance(idnum, int):
        print("정수가 아닙니다.")
        return None
    elif idnum <= 0:
        print("0보다 작습니다.")
        return None

    if idnum == 1:
        return ''.join(choice(randDigits) for i in range(length))
    else:
        result = [''.join(choice(randDigits)
                          for i in range(length)) for _ in range(idnum)]
        while True:
            if len(set(result)) == idnum:
                break
            else:
                print("중복발생!!")
                result = list(set(result))
                result.extend([''.join(choice(randDigits) for i in range(
                    length)) for _ in range(idnum - len(result))])

        return result


def GetRandomNames(namenum=1, nametype="FULL", gender="male"):
    import names

    if not isinstance(namenum, int):
        print("정수가 아닙니다.")
        return None
    elif namenum <= 0:
        print("0보다 작습니다.")
        return None

    if nametype == "FULL":
        nameGenerator = names.get_full_name
    elif nametype == "FIRST":
        nameGenerator = names.get_first_name
    else:
        nameGenerator = names.get_last_name

    if namenum == 1:
        return nameGenerator()
    else:
        return [nameGenerator() for _ in range(namenum)]


def GetRandomChoice(valuelist, resultnum=1):
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

    if resultnum == 1:
        return random.choice(valuelist)
    else:
        return [random.choice(valuelist) for _ in range(resultnum)]


def GetRandomPassword(minlen=8, maxlen=20, passnum=1):
    import random

    alph = list(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@')

    if not isinstance(passnum, int):
        print("정수가 아닙니다.")
        return None
    elif passnum <= 0:
        print("0보다 작습니다.")
        return None

    if passnum == 1:
        result = ""
        passlen = random.randrange(minlen, maxlen + 1)
        return "".join(random.choice(alph) for _ in range(passlen))
    else:
        result = []
        for _ in range(passnum):
            passlen = random.randrange(minlen, maxlen + 1)
            temp = "".join(random.choice(alph) for _ in range(passlen))
            result.append(temp)

        return result


def GetRandomNickname(nicknum=1):
    from random_username.generate import generate_username

    if not isinstance(nicknum, int):
        print("정수가 아닙니다.")
        return None
    elif nicknum <= 0:
        print("0보다 작습니다.")
        return None

    if nicknum == 1:
        return generate_username(1)[0]
    else:
        return generate_username(nicknum)


''' jkas1234 <= 이런식으로 ID 만들어 줌 '''


def GetRandomMixID(alphabetnum=4, digitnum=4, idnum=1):
    import random
    import string

    if not isinstance(idnum, int):
        print("정수가 아닙니다.")
        return None
    elif idnum <= 0:
        print("0보다 작습니다.")
        return None

    if idnum == 1:
        ap = ''.join(random.choice(string.ascii_letters)
                     for _ in range(alphabetnum))
        dg = ''.join(str(random.randrange(1, 10)) for _ in range(digitnum))
        return ap + dg
    else:
        result = []
        for _ in range(idnum):
            ap = ''.join(random.choice(string.ascii_letters)
                         for _ in range(alphabetnum))
            dg = ''.join(str(random.randrange(1, 10)) for _ in range(digitnum))
            result.append(ap+dg)
        while True:
            if len(set(result)) == idnum:
                break
            else:
                print("중복발생!!")
                result = list(set(result))
                for _ in range(idnum - len(result)):
                    ap = ''.join(random.choice(string.ascii_letters)
                                 for _ in range(alphabetnum))
                    dg = ''.join(str(random.randrange(1, 10))
                                 for _ in range(digitnum))
                    result.append(ap+dg)
        return result


def GetEmailByNames(namelist):
    import random

    if isinstance(namelist, list):
        result = []
        for i in namelist:
            result.append(f"{i}@{random.choice(EMAIL)}.com")
        return result


def GetRandomGenre(genrenum=1):
    import random
    if genrenum == 1:
        return random.choice(GENRE)
    else:
        return [random.choice(GENRE) for _ in range(genrenum)]


def GetRandomGenres(chgenremin=1, chgenremax=3, genrenum=1):
    import random
    if genrenum == 1:
        return random.sample(GENRE_index, random.randrange(chgenremin, chgenremax+1))
    else:
        return [random.sample(GENRE_index, random.randrange(chgenremin, chgenremax+1)) for _ in range(genrenum)]


def GetChannelName(genrelist, namelist, spacechar=" "):
    result = []
    for genre, name in zip(genrelist, namelist):
        result.append(f"{genre}{spacechar}{name}" if isinstance(
            genre, str) else f"{genre[0]}{spacechar}{name}")
    return result


'''
SQL문 형식 설정 
'''


def StringWithQuotes(obj):
    '''
    그냥 문자열에 ' < 이거로 감싸주는 거
    '''
    if obj is str:
        return f"\'{obj}\'"
    else:
        return obj


def GetValuesToString(value_tuple):
    '''
    tuple의 value들 INSERT 문에 알맞은 형식으로 바꿔주는 기능입니다.
    아래  GetInsertSQLSentence 참고
    '''
    result = ""
    for i, v in enumerate(value_tuple):
        result += f"{v}" if not isinstance(v, str) else f"\'{v}\'"
        result += ", " if i != len(value_tuple)-1 else " "
    return result


'''
SQL문 생성 및 저장 
'''


def GetInsertSQLSentence(table_name, input_list):
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

    for i in input_list:
        result.append(
            f"INSERT INTO {table_name.upper()} VALUES ({GetValuesToString(i)})")

    return result


def SQLsentenceToFile(result_list, filename="test.sql"):
    with open(filename, 'a', encoding="utf-8") as f:
        for result in result_list:
            f.write(result+"\n")
        f.write("\n")
        f.write("COMMIT;")
        f.write("\n\n")


def USER_tuples(n=50, FK=True):
    print("<USER>")
    user_id = GetRandomMixID(8, 8, idnum=n)
    user_password = GetRandomPassword(passnum=n)
    name = GetRandomNames(namenum=n, nametype="FIRST", gender="male")
    nickname = GetRandomNickname(nicknum=n)
    email = GetEmailByNames(namelist=name)

    result = [pair for pair in zip(
        user_id, user_password, name, nickname, email)]

    return result, user_id if FK else result


def COMMENT_tuples(user_id_list, channel_id_list, min=0, max=10, FK=True):
    import random
    from essential_generators import DocumentGenerator

    print("<COMMENT>")
    print("\t- comment 작성 중... => 시간이 좀 걸립니다.")

    comment_id = 1
    result = []

    for channel_id in channel_id_list:
        r = random.randrange(min, max)
        if r == 0:
            continue
        random_user_id_list = random.sample(user_id_list, r)
        doc = DocumentGenerator()
        for j in random_user_id_list:
            result.append((j, comment_id, doc.sentence(), channel_id))
            comment_id += 1

    return result, [i for i in range(1, comment_id)] if FK else result


def RATING_tuples(user_id_list, channel_id_list, min=1, max=30):
    import random

    print("<RATING>")

    result = []

    for i in range(channel_id_list):
        r = random.randrange(min, max)
        if r == 0:
            continue
        rnd_user = random.choice(user_id_list, r)
        result.extend((j, random.randrange(1, 11), i) for j in rnd_user)
    return result


def YOUTUBER_tuples(n=50, FK=True):
    print("<YOUTUBER>")
    youtuber_id = [i for i in range(1, n+1)]
    youtuber_name = GetRandomNames(
        namenum=n, nametype="FIRST", gender="female")

    result = [pair for pair in zip(youtuber_id, youtuber_name)]

    return result, youtuber_id if FK else result


def PERFORMER_tuples(n=50, FK=True):
    print("<PERFORMER>")
    performer_id = [i for i in range(1, n+1)]
    performer_name = GetRandomNames(namenum=n, nametype="FIRST")
    performer_char = GetRandomChoice(valuelist=CHARACTER, resultnum=n)

    result = [pair for pair in zip(
        performer_id, performer_name, performer_char)]

    return result, performer_id if FK else result


def GENRE_tuples(FK=True):
    print("<GENRE>")
    genre_num = GENRE_index
    genre_name = GENRE

    result = [pair for pair in zip(genre_num, genre_name)]

    return result, genre_num if FK else result


def HAS_tuples(channel_id_list):
    print("<HAS>")
    channel_id = channel_id_list
    genre_id = GetRandomGenres(genrenum=len(channel_id))
    result = []
    for pair in zip(channel_id, genre_id):
        for i in pair[1]:
            result.append((pair[0], i))
    print(len(result))
    return result


def RECOMMENDATION_tuples(user_id_list, comment_id):
    print("<RECOMMENDATION>")
    import random
    result = []
    for c in comment_id:
        num = random.randrange(0, 30)
        if num != 0:
            A = random.sample(user_id_list, num)
            result.extend([(i, c) for i in A])
        else:
            continue
    return result


def PARTICIPATION_tuples(channel_id_list, performer_id_list):
    print("<PARTICIPATION>")
    result = []
    for i in channel_id_list:
        num = random.randrange(1, 5)
        A = random.sample(performer_id_list, num)
        result.extend([(i, j) for j in A])
    return result


def CHANNEL_tuples(youtuber_id_list, filename="input.txt", FK=True):
    print("<CHANNEL>")

    import sys
    from googleapiclient.discovery import build

    YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'
    DEVELOPER_KEY = sys.argv[1]

    youtube = build(YOUTUBE_API_SERVICE_NAME,
                    YOUTUBE_API_VERSION, developerKey=DEVELOPER_KEY)

    def get_snippet(title):
        response = youtube.search().list(
            q=title,
            order="relevance",
            part="snippet",
            maxResults=1
        ).execute()
        id = response["items"][0]["snippet"]["channelId"].replace("\'", "\'\'")
        title = title.replace("\'", "\'\'")
        description = response["items"][0]["snippet"]["description"].replace("\'", "\'\'")
        return id, title, description

    def get_statistics(channel_id):
        response = youtube.channels().list(
            part="statistics",
            id=channel_id
        ).execute()
        view_count = response["items"][0]["statistics"]["viewCount"]
        subscriber_count = response["items"][0]["statistics"]["subscriberCount"]
        return view_count, subscriber_count

    channel_tuple_list = []
    has_tuple_list = []
    channel_id_list = []

    f = open(filename, "r", encoding="utf-8")
    lines = f.readlines()
    index = 0

    for line in lines:
        title, genre_id = line.strip().split(",")
        id, title, description = get_snippet(title)
        view_count, subscriber_count = get_statistics(id)
        if index < len(youtuber_id_list):
            youtuber_id = youtuber_id_list[index]
            index += 1
        else:
            youtuber_id = random.choice(youtuber_id_list)
        channel_tuple_list.append([str(id), str(title), str(description), int(
            view_count), int(subscriber_count), int(youtuber_id)])
        has_tuple_list.append([str(id), int(genre_id)])
        channel_id_list.append(str(id))

    f.close()
    return (channel_tuple_list, has_tuple_list, channel_id_list) if FK else (channel_tuple_list, has_tuple_list)


def MakeSQL():
    print("데이터 생성 중입니다...")

    user, userID = USER_tuples(50, FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("USER", user))

    youtuber, youtuberID = YOUTUBER_tuples(50, FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("YOUTUBER", youtuber))

    performer, performerID = PERFORMER_tuples(50, FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("PERFORMER", performer))

    genre, genreID = GENRE_tuples(FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("GENRE", genre))

    channel, has, channelID = CHANNEL_tuples(
        youtuberID, filename="input.txt", FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("CHANNEL", channel))
    SQLsentenceToFile(result_list=GetInsertSQLSentence("HAS", has))

    comment, commentID = COMMENT_tuples(
        userID, channelID, min=0, max=10, FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("COMMENT", comment))

    participation = PARTICIPATION_tuples(channelID, performerID)
    SQLsentenceToFile(result_list=GetInsertSQLSentence(
        "PARTICIPATION", participation))

    recommendation = RECOMMENDATION_tuples(userID, commentID)
    SQLsentenceToFile(result_list=GetInsertSQLSentence(
        "RECOMMENDATION", recommendation))

    has = HAS_tuples(channelID)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("HAS", has))

    print("< test.sql 작성 완료했습니다. 확인해보세요 >")


def MakeSQL_channel():
    print("데이터 생성 중입니다...")

    youtuber, youtuberID = YOUTUBER_tuples(50, FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("YOUTUBER", youtuber))

    channel, has, channelID = CHANNEL_tuples(
        youtuberID, filename="input.txt", FK=True)
    SQLsentenceToFile(result_list=GetInsertSQLSentence("CHANNEL", channel))
    SQLsentenceToFile(result_list=GetInsertSQLSentence("HAS", has))

    print("< test.sql 작성 완료했습니다. 확인해보세요 >")


'''
테스트 코드
'''
ytb_ids = [
    'UCRuSxVu4iqTK5kCh90ntAgA',
    'UChbE5OZQ6dRHECsX0tEPEZQ',
    'UCB8Fets2QTgay4SrwyHOzpA',
    'UCszFjh7CEfwDb7UUGb4RzCQ',
    'UCIZ5rCTYJ0s16FgT7OetVEQ',
    'UCzPhd4orXg5TWhM1u2RV-cw',
    'UCkOWueVolZTPOMaa5ZIYrxw',
    'UCoJ_56-OMSe_jrp42ClhODA',
    'UCnFFOjljp1_sacTz7PfIIyg',
    'UC9kmlDcqksaOnCkC_qzGacA',
    'UCuZu8NrpBG4WPXRi-hPBl-A',
    'UCnekLiljel-Px4ClMC7b3mg',
    'UC1B6SalAoiJD7eHfMUA9QrA',
    'UCGX5sP4ehBkihHwt5bs5wvg',
    'UC5xLohcPE65Y-U62X6snmRQ',
    'UCYtjW8dGkaeHwrMiB01Xa_Q',
    'UClErHbdZKUnD1NyIUeQWvuQ',
    'UCsJ6RuBiTVWRX156FVbeaGg',
    'UCgheNMc3gGHLsT-RISdCzDQ',
    'UCF8AeLlUbEpKju6v1H6p8Eg',
    'UC79hJz6y1EEiIkwfHOuWC4w',
    'UCaHGOzOyeYzLQeKsVkfLEGA',
    'UCMguxwveCsLVpyKrLz-EFTg',
    'UCpCiIDf9UrfRqte55FHWlYQ',
    'UCd4FmcWIVdWAy0-Q8OJBloQ',
    'UCPBvwGeynLRFTgjqnlKyotw',
    'UCp94pzrtA5wPyZazbDq0CXA',
    'UCuPeQ50gyXAl_70p0UT7WAQ',
    'UCc8-vc45vK1-kUFZvii7s5g',
    'UCFCtZJTuJhE18k8IXwmXTYQ',
    'UC7A6GVOKGkD2CeUPW_l41Bg',
    'UCcYk_KPZZMLv_bcaSAWSSxA',
    'UCbOwqHbQf0uspeRe7lY8e6Q',
    'UCcSepD5GRKpskptBW2TSKGg',
    'UCw-kXdzxMdMdLNI0ZlFFbmA',
    'UC8a6z7i9qypp9PqJ_0HhBrw',
    'UCPKNKldggioffXPkSmjs5lQ',
    'UCfpaSruWW3S4dibonKXENjA',
    'UCA6KBBX8cLwYZNepxlE_7SA',
    'UC-i2ywiuvjvpTy2zW-tXfkw',
    'UCZTavrg2A43lQMWxiK3yu7g',
    'UCL01un1rw1MU3wj7-oEELQQ',
    'UCr5Kww9xqzPmSJTHyXl58YQ',
    'UC0htUSwcxfSGNfK_5Q28JkA',
    'UCt15X5eHLwyP8PpNtQTkuDQ',
    'UCD2YO_A_PVMgMDN9jpRrpVA',
    'UCJpAwvQaZyCI5spAz7tipGA',
    'UCDBAVzfX3yZ1hah0FHnOoaA',
    'UCuFGPhfJlIngZaC2BjLaJdQ',
    'UCF9vbHlZpz7FbOAky3fnYxw',
    'UCVfLNEch9YxD4tX1L-crkMQ',
    'UCnLrunxy9Ex0JWvm9HHa71w',
    'UCYJDUekoQz0-bo8al1diLWQ',
    'UCoe-0EVDJnjlSoPK8ygcGwQ',
    'UCdtRAcd3L_UpV4tMXCw63NQ',
    'UCQ4eZwsMew7ZaV_HKXnQLGg',
    'UCe52oeb7Xv_KaJsEzcKXJJg',
    'UCeLPm9yH_a_QH8n6445G-Ow',
    'UCS_hnpJLQTvBkqALgapi_4g',
    'UCepUWUpH45hRTi-QePdq1Bg',
    'UCcQTRi69dsVYHN3exePtZ1A',
    'UCkinYTS9IHqOEwR1Sze2JTw',
    'UCsU-I-vHLiaMfV_ceaYz5rQ',
    'UChlgI3UHCOnwUGzWzbJ3H5w',
    'UCq0pVPNYdDWQk1iTS4jTk2w',
    'UCG1yCJ0i5iAH1lixElahYUw',
    'UCAmff0euQRf6RwVlbB8PLMw',
    'UCwRljhjVWtLqAKbsWGPU_OA',
    'UCnXNukjRxXGD8aeZGRV-lYg',
    'UC2emKV0kcPDKNl9EtDm4Ubg',
    'UCdTDdygpZKdDew2s1s419iw',
    'UCtm_QoN2SIxwCE-59shX7Qg',
    'UCdUcjkyZtf-1WJyPPiETF1g',
    'UCFX6adXoyQKxft933NB3rmA',
    'UC_0oo0GPlDUU88ubLDnJkSQ',
    'UCJiv3w22pf4Cgpwxo70MbhQ',
    'UC3SyT4_WLHzN7JmHQwKQZww',
    'UCoQy2wS5aiKCk-rUXiLS-vQ',
    'UC8TxOmxwC8QpHRZra7sOFig',
    'UCj-durTg1W7uWsB8oq0u7kA',
    'UC7F6UDq3gykPZHWRhrj_BDw',
    'UCMc4EmuDxnHPc6pgGW-QWvQ',
    'UCrBpV_pG2kyMMEHCMTNzjAQ',
    'UCIk1-yPCTnFuzfgu4gyfWqw',
    'UCw8ZhLPdQ0u_Y-TLKd61hGA',
    'UC3LIEPioeH0CmVCmCn4JS1g',
    'UC2KEmFk5uE9bYvxoHuUFH5g',
    'UC2jHhn8GMouSKUiauOsiR3w'
]


def test_SQL():
    input = USER_tuples()
    print("< 테스트용 입력 데이터들입니다. >")
    print(input)

    table_name = "employee"
    print("\n< GetInsertSQLSentence 함수 작동중입니다. >\n")
    result_list = GetInsertSQLSentence(table_name, input)
    print("< 결과값입니다. >")
    for i in result_list:
        print(i)
    print("\n< test.sql 작성 완료했습니다. 확인해보세요 >")
    SQLsentenceToFile(result_list=result_list)


def main():
    # MakeSQL()
    # A = HAS_tuples(ytb_ids)
    # B = GetInsertSQLSentence("HAS", A)
    # for i in B:
    #     print(i)
    MakeSQL_channel()


if __name__ == "__main__":
    main()
