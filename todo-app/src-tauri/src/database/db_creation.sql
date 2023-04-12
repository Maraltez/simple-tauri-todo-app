DROP TABLE todo_category;
DROP Table todo;
DROP TABLE category;

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS todo(
    todo_id integer primary key,
    name text not null,
    description text,
    creation_date text default CURRENT_TIMESTAMP not null,
    edit_date text default CURRENT_TIMESTAMP not null,
    target_date text,
    completed integer default 0 not null,
    priority integer
);

CREATE TABLE IF NOT EXISTS category(
    category_id integer primary key,
    name text not null
);

CREATE TABLE IF NOT EXISTS todo_category(
    todo_id integer,
    category_id integer,
    PRIMARY KEY(todo_id, category_id),
    FOREIGN KEY(todo_id) references todo(todo_id),
    FOREIGN KEY(category_id) references category(category_id)
);

CREATE TABLE IF NOT EXISTS todo_item(
    item_id integer,
    todo_id integer,
    name text not null,
    description text,
    creation_date text default CURRENT_TIMESTAMP not null,
    edit_date text default CURRENT_TIMESTAMP not null,
    completed integer default 0 not null,
    primary key (item_id, todo_id),
    foreign key (todo_id) references todo(todo_id)
)


