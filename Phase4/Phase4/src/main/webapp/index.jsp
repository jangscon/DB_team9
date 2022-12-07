<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TUBE FINDER</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>
        body {
            min-height: 75rem;
            padding-top: 8rem;
        }

        .form-collapse {
            margin-left: 8rem;
            margin-right: 8rem;
            margin-top: 8rem;
        }
    </style>
</head>
<body>

<header>
    <nav class="navbar navbar-expand-md fixed-top bg-white flex-column border-bottom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">TUBE FINDER</a>
            <div class="d-flex">
                <button type="button" class="btn btn-outline-primary me-2">Login</button>
                <button type="button" class="btn btn-primary">Sign-up</button>
            </div>
        </div>
        <div class="container-fluid flex-row mt-3">
            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="collapse"
                    data-bs-target="#collapseExample"
                    aria-expanded="false" aria-controls="collapseExample">
                Search channel
            </button>
            <div class="d-flex align-items-center">
                <label style="white-space: nowrap">Order by:</label>
                <select class="form-select ms-2" id="exampleSelect1">
                    <option value="1" selected>Channel name</option>
                    <option value="2">Number of subscribers</option>
                    <option value="3">Total views</option>
                </select>
            </div>
        </div>
    </nav>

    <div class="collapse fixed-top form-collapse" id="collapseExample">
        <div class="card card-body">
            <form>
                <div class="mb-3">
                    <label for="inputKeywords" class="form-label">Keywords</label>
                    <input type="text" class="form-control" id="inputKeywords" aria-describedby="keywordsHelp">
                    <div id="keywordsHelp" class="form-text">Separated by spaces. Up to 2. Search keywords from channel
                        name and description.
                    </div>
                </div>
                <div class="mb-3">
                    <label for="subscriberNumOver" class="form-label">Number of subscribers over: <span
                            class="span1">0</span></label>
                    <input type="range" class="form-range" min="0" max="25700000" value="0" step="100000"
                           id="subscriberNumOver" onchange="range_change('span1', this)">
                </div>
                <div class="mb-3">
                    <label for="subscriberNumUnder" class="form-label">Number of subscribers under: <span class="span2">25700000</span></label>
                    <input type="range" class="form-range" min="0" max="25700000" value="25700000" step="100000"
                           id="subscriberNumUnder" onchange="range_change('span2', this)">
                </div>
                <div class="mb-3">
                    <label for="totalViewsOver" class="form-label">Total views over: <span
                            class="span3">0</span></label>
                    <input type="range" class="form-range" min="0" max="12000000000" value="0" step="10000000"
                           id="totalViewsOver" onchange="range_change('span3', this)">
                </div>
                <div class="mb-3">
                    <label for="totalViewsUnder" class="form-label">Total views under: <span
                            class="span4">12000000000</span></label>
                    <input type="range" class="form-range" min="0" max="12000000000" value="12000000000" step="10000000"
                           id="totalViewsUnder" onchange="range_change('span4', this)">
                </div>
                <div class="mb-3">
                    <label for="inputGenreNames" class="form-label">Genre names</label>
                    <input type="text" class="form-control" id="inputGenreNames" aria-describedby="genreNamesHelp">
                    <div id="genreNamesHelp" class="form-text">Separated by spaces. Up to 2.</div>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>
    </div>
</header>

<main>
    <div class="container-fluid">
        <div class="row">
            <div class="col">
                <h2 class="mx-3">Animation</h2>
            </div>
        </div>
        <div class="row">
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <img src="https://yt3.ggpht.com/ikoBSvkW5k5z9Att2kLh02ALcjN-uNM17GUf-kwW4tNZNZ9EClXFnCuGQHu4ZRK5GkRN571K3w=s240-c-k-c0x00ffffff-no-rj">
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col">
                <h2 class="mx-3">Animation</h2>
            </div>
        </div>
        <div class="row">
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <svg class="bd-placeholder-img card-img-top" width="100%" height="150"
                         xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail"
                         preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title>
                        <rect width="100%" height="100%" fill="#55595c"/>
                        <text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text>
                    </svg>
                    <div class="card-body">
                        <p class="card-text">채널 이름</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">123456<br>subscribers</small>
                            <small class="text-muted" style="text-align: right">123456<br>time watched</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    function range_change(target, obj) {
        let x = document.getElementsByClassName(target)[0];
        x.innerText = obj.value;
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
</body>
</html>