create table if not exists users (
    id blob primary key,
    username text not null,
    password text not null,
    created_at integer default (strftime('%s', 'now'))
);
