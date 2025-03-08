--Create a new Database
CREATE DATABASE chat_system;
USE chat_system;

--Create Tables
CREATE TABLE organization(
       id INT PRIMARY KEY AUTO_INCREMENT,
       name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE channel(
       id INT PRIMARY KEY AUTO_INCREMENT,
       name VARCHAR(100) NOT NULL,
       organization_id INT,
       FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE
);

CREATE TABLE user(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE user_channel(
       user_id INT,
       channel_id INT,
       PRIMARY KEY (user_id, channel_id),
       FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
       FOREIGN KEY (channel_id) REFERENCES channel(id) ON DELETE CASCADE
);

CREATE TABLE message(
       id INT PRIMARY KEY AUTO_INCREMENT,
       user_id INT,
       channel_id INT, 
       content TEXT NOT NULL,
       post_time DATETIME DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
       FOREIGN KEY (channel_id) REFERENCES channel(id) ON DELETE CASCADE
);

--Insert data into tables

--1. Insert 0ne organization, Lambda School
INSERT INTO organization
     (name)
VALUES('Lambda School');

--2.Insert three users, Alice, Bob, and Chris.
INSERT INTO user
      (name)
VALUES ('Alice'), ('Bob'), ('Chris');

--3. Insert two channels, #general and #random
INSERT INTO channel
      (name, organization_id)
VALUES ('#general', (SELECT id FROM organization WHERE name = 'Lambda School')), ('#random', (SELECT id FROM organization WHERE name = 'Lambda School'));

--4. Insert the following:
--Alice should be in #general and #random.
--Bob should be in #general.
--Chris should be in #random.
INSERT INTO user_channel
      (user_id, channel_id)
       VALUES 
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#general')),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#random')),
((SELECT id FROM user WHERE name = 'Bob'), (SELECT id FROM channel WHERE name = '#general')), 
((SELECT id FROM user WHERE name = 'Chris'), (SELECT id FROM channel WHERE name = '#random'));

--5. Insert 10 messages (at least one per user, and at least one per channel).
INSERT INTO message
       (user_id, channel_id, content)
        VALUES
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#general'), "Hey guys! I'm Alice"),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#random'), "Hello buddies! I'm Alice"),  
((SELECT id FROM user WHERE name = 'Bob'), (SELECT id FROM channel WHERE name = '#general'), "Hey guys! I'm Bob"),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#general'), "Hello Bob!"), 
((SELECT id FROM user WHERE name = 'Chris'), (SELECT id FROM channel WHERE name = '#random'), "Hey guys! I'm Chris"),   
((SELECT id FROM user WHERE name = 'Bob'), (SELECT id FROM channel WHERE name = '#general'), "That's Great!"),  
((SELECT id FROM user WHERE name = 'Chris'), (SELECT id FROM channel WHERE name = '#random'), "Let's play a game"),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#random'), "I think playing online games is boring"),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#general'), "Yeah! we shall meet today af Cafe Coffee Day"),
((SELECT id FROM user WHERE name = 'Bob'), (SELECT id FROM channel WHERE name = '#general'), "Okay!");
