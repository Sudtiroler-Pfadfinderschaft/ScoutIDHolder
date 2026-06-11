CREATE DATABASE scout_id_holder
    WITH ENCODING = 'UTF8'
    LC_COLLATE = 'de_DE.UTF-8'
    LC_CTYPE = 'de_DE.UTF-8'
    TEMPLATE = template0;

\c scout_id_holder;

-- =========================
-- USER
-- =========================
CREATE TABLE "User" (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    uemail VARCHAR(255) NOT NULL,
    urole INT NOT NULL,
    upasswordhash TEXT NOT NULL,
    usecrettoken TEXT NOT NULL,
    ucreationdate TIMESTAMP NOT NULL
);

-- =========================
-- APPROVAL
-- =========================
CREATE TABLE "Approval" (
    aid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    uid INT NOT NULL,
    adate TIMESTAMP NOT NULL,
    CONSTRAINT fk_approval_user
        FOREIGN KEY (uid) REFERENCES "User"(uid)
        ON DELETE CASCADE
);

-- =========================
-- PARENT
-- =========================
CREATE TABLE "Parent" (
    pid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pfirstname VARCHAR(100) NOT NULL,
    plastname VARCHAR(100) NOT NULL,
    pphone VARCHAR(50) NOT NULL,
    pemail VARCHAR(255) NOT NULL
);

-- =========================
-- TRANSFER
-- =========================
CREATE TABLE "Transfer" (
    tid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tfilepath TEXT NOT NULL
);

-- =========================
-- GROUP
-- (reserved keyword -> quoted)
-- =========================
CREATE TABLE "Group" (
    gid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gname VARCHAR(255) NOT NULL
);

-- =========================
-- LEVEL
-- =========================
CREATE TABLE "Level" (
    lid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lname VARCHAR(255) NOT NULL,
    gid INT,
    CONSTRAINT fk_level_group
        FOREIGN KEY (gid) REFERENCES "Group"(gid)
        ON DELETE SET NULL
);

-- =========================
-- ROLE
-- =========================
CREATE TABLE "Role" (
    rlid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rlname VARCHAR(255) NOT NULL
);

-- =========================
-- EVENT
-- =========================
CREATE TABLE "Event" (
    eid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ename VARCHAR(255) NOT NULL,
    estart DATE NOT NULL,
    eend DATE NOT NULL,
    eregistrationend DATE NOT NULL
);

-- =========================
-- REQUEST
-- =========================
CREATE TABLE "Request" (
    rqid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    uid INT,
    rqfirstname VARCHAR(100) NOT NULL,
    rqlastname VARCHAR(100) NOT NULL,
    rqbirthdate DATE NOT NULL,
    rqresidence TEXT NOT NULL,
    rqstreet TEXT NOT NULL,
    rqhousenumber VARCHAR(20) NOT NULL,
    rqphone VARCHAR(50),
    rqemail VARCHAR(255),

    gid INT NOT NULL,
    lid INT NOT NULL,

    p1id INT,
    p2id INT,
    tid INT NOT NULL,

    CONSTRAINT fk_request_user
        FOREIGN KEY (uid) REFERENCES "User"(uid)
        ON DELETE SET NULL,

    CONSTRAINT fk_request_group
        FOREIGN KEY (gid) REFERENCES "Group"(gid),

    CONSTRAINT fk_request_level
        FOREIGN KEY (lid) REFERENCES "Level"(lid),

    CONSTRAINT fk_request_parent1
        FOREIGN KEY (p1id) REFERENCES "Parent"(pid),

    CONSTRAINT fk_request_parent2
        FOREIGN KEY (p2id) REFERENCES "Parent"(pid),

    CONSTRAINT fk_request_transfer
        FOREIGN KEY (tid) REFERENCES "Transfer"(tid)
);

-- =========================
-- USER SCOUT
-- composite key (sid + uid)
-- =========================
CREATE TABLE "UserScout" (
    sid INT NOT NULL,
    uid INT NOT NULL,
    usbirthplace VARCHAR(255) NOT NULL,
    aid INT,

    PRIMARY KEY (sid, uid),

    CONSTRAINT fk_userscout_user
        FOREIGN KEY (uid) REFERENCES "User"(uid)
        ON DELETE CASCADE,

    CONSTRAINT fk_userscout_approval
        FOREIGN KEY (aid) REFERENCES "Approval"(aid)
);

-- =========================
-- GROUP EVENTS
-- =========================
CREATE TABLE "GroupEvents" (
    eid INT NOT NULL,
    gid INT NOT NULL,

    PRIMARY KEY (eid, gid),

    CONSTRAINT fk_groupevents_event
        FOREIGN KEY (eid) REFERENCES "Event"(eid)
        ON DELETE CASCADE,

    CONSTRAINT fk_groupevents_group
        FOREIGN KEY (gid) REFERENCES "Group"(gid)
        ON DELETE CASCADE
);

-- =========================
-- REGISTRATION
-- =========================
CREATE TABLE "Registration" (
    sid INT NOT NULL,
    eid INT NOT NULL,
    tid INT NOT NULL,
    rgapproved BOOLEAN,

    PRIMARY KEY (sid, eid, tid),

    CONSTRAINT fk_registration_userscout
        FOREIGN KEY (sid) REFERENCES "UserScout"(sid),

    CONSTRAINT fk_registration_event
        FOREIGN KEY (eid) REFERENCES "Event"(eid),

    CONSTRAINT fk_registration_transfer
        FOREIGN KEY (tid) REFERENCES "Transfer"(tid)
);
