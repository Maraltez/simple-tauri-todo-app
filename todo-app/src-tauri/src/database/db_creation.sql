DROP TABLE IF EXISTS todo_category;
DROP TABLE IF EXISTS todo_item;
DROP Table IF EXISTS todo;
DROP TABLE IF EXISTS category;
DROP TRIGGER IF EXISTS tr_todo_item_insert;
DROP TRIGGER IF EXISTS tr_todo_item_update_raise;
DROP TRIGGER IF EXISTS tr_todo_item_update;
DROP TRIGGER IF EXISTS tr_todo_item_delete;

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
    FOREIGN KEY(todo_id) references todo(todo_id) on delete cascade,
    FOREIGN KEY(category_id) references category(category_id) on delete cascade
);

CREATE TABLE IF NOT EXISTS todo_item(
    item_id integer primary key,
    todo_id integer,
    name text not null,
    description text,
    creation_date text default CURRENT_TIMESTAMP not null,
    edit_date text default CURRENT_TIMESTAMP not null,
    completed integer default 0 not null,
    unique (item_id, todo_id),
    foreign key (todo_id) references todo(todo_id) on delete cascade
);

CREATE TRIGGER IF NOT EXISTS tr_todo_item_insert BEFORE INSERT ON todo_item
    BEGIN
        UPDATE todo SET edit_date = CURRENT_TIMESTAMP WHERE todo.todo_id = new.todo_id;

        UPDATE todo
        SET completed = 0
        WHERE todo.todo_id = new.todo_id
          AND todo.completed + new.completed = 1;
    END;

CREATE TRIGGER IF NOT EXISTS tr_todo_item_update_raise BEFORE UPDATE OF todo_id ON todo_item WHEN old.todo_id != new.todo_id
    BEGIN
       SELECT RAISE (ABORT, 'Changing todo_id is not allowed!');
    END;

CREATE TRIGGER IF NOT EXISTS tr_todo_item_update AFTER UPDATE on todo_item
    BEGIN
        UPDATE todo SET edit_date = CURRENT_TIMESTAMP WHERE todo.todo_id = new.todo_id;
        UPDATE todo_item SET edit_date = CURRENT_TIMESTAMP WHERE todo_item.item_id = new.item_id AND new.edit_date IS NULL;

        UPDATE todo
        SET completed = 1
        WHERE todo.todo_id = new.todo_id AND completed = 0 AND 0 NOT IN (
            SELECT ifnull(DISTINCT completed, 0)
            FROM todo_item
            WHERE todo_item.todo_id = new.todo_id
            GROUP BY completed
        );

        UPDATE todo
        SET completed = 0
        WHERE todo.todo_id = new.todo_id AND completed = 1 AND 0 IN (
            SELECT ifnull(DISTINCT completed, 0)
            FROM todo_item
            WHERE todo_item.todo_id = new.todo_id
            GROUP BY completed
        );
    END;

CREATE TRIGGER IF NOT EXISTS tr_todo_item_delete AFTER DELETE on todo_item
    BEGIN
        UPDATE todo SET edit_date = CURRENT_TIMESTAMP WHERE todo.todo_id = old.todo_id;

        UPDATE todo
        SET completed = 1
        WHERE todo.todo_id = old.todo_id AND completed = 0 AND 0 NOT IN (
            SELECT ifnull(DISTINCT completed, 0)
            FROM todo_item
            WHERE todo_item.todo_id = old.todo_id
            GROUP BY completed
        );

        UPDATE todo
        SET completed = 0
        WHERE todo.todo_id = old.todo_id AND completed = 1 AND 0 IN (
            SELECT ifnull(DISTINCT completed, 0)
            FROM todo_item
            WHERE todo_item.todo_id = old.todo_id
            GROUP BY completed
        );
    END;

/*
INSERT INTO todo(name, priority)
VALUES ('test1', 0),
       ('test2', 0),
       ('test3', 0);

INSERT INTO todo_item(todo_id, name)
VALUES (1, 'todo1'),
       (1, 'todo2'),
       (1, 'todo3'),
       (2, 'todo1'),
       (2, 'todo2'),
       (2, 'todo3'),
       (3, 'todo1'),
       (3, 'todo2'),
       (3, 'todo3');

UPDATE todo_item SET todo_id = 1 WHERE item_id = 9;
UPDATE todo_item SET completed = 1 WHERE todo_id = 1;
INSERT INTO todo_item(todo_id, name, completed) VALUES (1,'todo4', 1);
INSERT INTO todo_item(todo_id, name, completed) VALUES (1,'todo4', 0);
UPDATE todo_item SET completed = 1 WHERE todo_id = 1;
UPDATE todo_item SET completed = 0 WHERE item_id = 1;
DELETE FROM todo_item WHERE item_id = 1;
DELETE FROM todo WHERE todo_id = 1;
*/


