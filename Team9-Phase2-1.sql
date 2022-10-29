CREATE TABLE customer (
    customer_id     VARCHAR(20)     NOT NULL,
    password        VARCHAR(20)     NOT NULL,
    name            VARCHAR(15)     NOT NULL,
    nickname        VARCHAR(15)     NOT NULL,
    email           VARCHAR(40)     NOT NULL,
    
    PRIMARY KEY (customer_id)
);

CREATE TABLE youtuber (
    youtuber_id     NUMBER          NOT NULL,
    name            VARCHAR(15)     NOT NULL,
    
    PRIMARY KEY (youtuber_id)
);

CREATE TABLE performer (
    performer_id    NUMBER          NOT NULL,
    name            VARCHAR(15)     NOT NULL,
    character       VARCHAR(20)     NOT NULL,
    
    PRIMARY KEY (performer_id)
);

CREATE TABLE genre (
    genre_num       NUMBER          NOT NULL,
    genre_name      VARCHAR(15)     NOT NULL,
    
    PRIMARY KEY (genre_num)
);

CREATE TABLE channel (
    channel_id      CHAR(24)        NOT NULL,
    channel_name    VARCHAR(40)     NOT NULL,
    description     VARCHAR(400),
    total_views     NUMBER          NOT NULL,
    subscriber_num  NUMBER          NOT NULL,
    youtuber_id     NUMBER          NOT NULL,
    
    PRIMARY KEY (channel_id),
    FOREIGN KEY (youtuber_id) REFERENCES youtuber ON DELETE CASCADE
);

CREATE TABLE has (
    channel_id      CHAR(24)        NOT NULL,
    genre_num       NUMBER          NOT NULL,
    
    PRIMARY KEY (channel_id, genre_num),
    FOREIGN KEY (channel_id) REFERENCES channel ON DELETE CASCADE,
    FOREIGN KEY (genre_num) REFERENCES genre ON DELETE CASCADE
);

CREATE TABLE participation (
    channel_id      CHAR(24)        NOT NULL,
    performer_id    NUMBER          NOT NULL,
    
    PRIMARY KEY (channel_id, performer_id),
    FOREIGN KEY (channel_id) REFERENCES channel ON DELETE CASCADE,
    FOREIGN KEY (performer_id) REFERENCES performer ON DELETE CASCADE
);

CREATE TABLE comments (
    customer_id     VARCHAR(20)     NOT NULL,
    comment_id      NUMBER          NOT NULL,
    message         VARCHAR(400)    NOT NULL,
    channel_id      CHAR(24)        NOT NULL,
    
    PRIMARY KEY (comment_id),
    FOREIGN KEY (customer_id) REFERENCES customer ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES channel ON DELETE CASCADE
);

CREATE TABLE recommendation (
    customer_id     VARCHAR(20)     NOT NULL,
    comment_id      NUMBER          NOT NULL,
    
    PRIMARY KEY (customer_id, comment_id),
    FOREIGN KEY (customer_id) REFERENCES customer ON DELETE CASCADE,
    FOREIGN KEY (comment_id) REFERENCES comments ON DELETE CASCADE
);

CREATE TABLE rating (
    customer_id     VARCHAR(20)     NOT NULL,
    channel_id      CHAR(24)        NOT NULL,
    rating          NUMBER          NOT NULL,
    
    PRIMARY KEY (customer_id, channel_id, rating),
    FOREIGN KEY (customer_id) REFERENCES customer ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES channel ON DELETE CASCADE
);

COMMIT;