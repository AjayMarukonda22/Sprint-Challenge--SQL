-- Create a new Database
CREATE DATABASE chat_system;
USE chat_system;

-- Create Tables
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

-- Insert data into tables

-- 1. Insert 0ne organization, Lambda School
INSERT INTO organization
     (name)
VALUES('Lambda School');

-- 2.Insert three users, Alice, Bob, and Chris.
INSERT INTO user
      (name)
VALUES ('Alice'), ('Bob'), ('Chris');

-- 3. Insert two channels, #general and #random
INSERT INTO channel
      (name, organization_id)
VALUES ('#general', (SELECT id FROM organization WHERE name = 'Lambda School')), ('#random', (SELECTid FROM organization WHERE name = 'Lambda School'));

-- 4. Insert the following:
-- Alice should be in #general and #random.
-- Bob should be in #general.
-- Chris should be in #random.
INSERT INTO user_channel
      (user_id, channel_id)
       VALUES 
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#general')),
((SELECT id FROM user WHERE name = 'Alice'), (SELECT id FROM channel WHERE name = '#random')),
((SELECT id FROM user WHERE name = 'Bob'), (SELECT id FROM channel WHERE name = '#general')), 
((SELECT id FROM user WHERE name = 'Chris'), (SELECT id FROM channel WHERE name = '#random'));

-- 5. Insert 10 messages (at least one per user, and at least one per channel).
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


-- Select Queries

-- 1. List all organization names.
SELECT name FROM organization;

-- 2. List all channel names.
SELECT name FROM channel;

-- 3. List all channels in a specific organization by organization name. ex : 'Lambda School' here
SELECT * 
FROM channel
WHERE organization_id = (SELECT id
			    FROM organization
                         WHERE name = 'Lambda School');

-- 4. List all messages in a specific channel by channel name #general in order of post_time, descending. 
-- (Hint: ORDER BY. Because your INSERTs might have all taken place at the exact same time, this might not return meaningful results. 
-- But humor us with the ORDER BY anyway.)
SELECT * 
FROM message
WHERE channel_id = (SELECT id 
                    FROM channel
                    WHERE name = '#general')
ORDER BY post_time DESC;            

-- 5.List all channels to which user Alice belongs.
SELECT name As channel_name
FROM channel
WHERE id IN (SELECT channel_id 
             FROM user_channel 
             WHERE user_id = (SELECT id
                               FROM user
                               WHERE name = 'Alice'));

-- 6. List all users that belong to channel #general.                               
SELECT * 
FROM user
WHERE id IN (SELECT user_id 
             FROM user_channel
             WHERE channel_id = (SELECT id 
                                 FROM channel
                                 WHERE name = "#general"));

-- 7. List all messages in all channels by user Alice.                                 
SELECT content AS alice_messages
FROM message
WHERE user_id = (SELECT id 
                 FROM user
                 WHERE name = 'Alice');

-- 8. List all messages in #random by user Bob.                 
SELECT content AS bob_messages_random
From message 
WHERE user_id = (SELECT id 
                 FROM user
                 WHERE name = 'Bob')
AND channel_id = (SELECT id 
                  FROM channel
                  WHERE name = '#random');

-- 9. List the count of messages across all channels per user. (Hint: COUNT, GROUP BY.)                  
SELECT u.name AS user_name, COUNT(m.id) AS message_count
FROM user u
JOIN message m
ON u.id = m.user_id
GROUP BY u.id
ORDER BY u.name DESC;  

-- 10.  List the count of messages per user per channel.
SELECT u.name AS user_name, c.name As channel_name, COUNT(m.id) AS message_count
FROM message m
JOIN user u
ON m.user_id = u.id
JOIN channel c
ON m.channel_id = c.id
GROUP BY u.name, c.name;   

-- Q. What SQL keywords or concept would you use if you wanted to automatically delete all messages by a user if that user were deleted from the user table?
-- The keywords  used are 'ON DELETE CASCADE'.
                 