create table users (
    id text primary key,
    name text not null
);
-- TODO: remove after testing
insert into users (id, name) values ('test', 'test');

-- TODO: add details (e.g. author, links, affiliate links)
create table books (
    id UUID primary key,
    name text unique not null
);

create table chapters (
    id UUID primary key,
    book_id UUID not null,
    name text not null,
    foreign key (book_id) references books (id)
);

create table quizzes (
    id UUID primary key,
    chapter_id UUID not null,
    name text not null,
    foreign key (chapter_id) references chapters (id)
);

-- only allows one correct answer
create table questions (
    id UUID primary key,
    quiz_id UUID not null,
    question text not null,
    -- the ID allows us to compare more securely (we can avoid hinting the frontend about the correct answer),
    -- while also allowing users to update the text
    correct_answer_id UUID not null,
    correct_answer text not null,
    foreign key (quiz_id) references quizzes (id)
);

-- a question can have multiple incorrect answers, we should validate there's at least one
create table incorrect_answers (
    id UUID primary key,
    question_id UUID not null,
    answer text not null,
    foreign key (question_id) references questions (id)
);

create table user_answers (
    user_id text not null,
    question_id UUID not null,
    -- if there's no incorrect answer, then the user answered correctly
    incorrect_answer UUID null,
    primary key (user_id, question_id),
    foreign key (user_id) references users (id),
    foreign key (question_id) references questions (id),
    foreign key (incorrect_answer) references incorrect_answers (id)
);
