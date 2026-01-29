-- Add a table to persist theory/practical test progress for each player/license
CREATE TABLE IF NOT EXISTS vicroads_testprogress (
    identifier VARCHAR(64) NOT NULL,
    license VARCHAR(32) NOT NULL,
    theoryPassed BOOLEAN DEFAULT FALSE,
    practicalPassed BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (identifier, license)
);