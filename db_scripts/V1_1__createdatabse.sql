--- Using uuid() for postgresql needs below extension ---
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Creating Tables
DROP TABLE IF EXISTS automationtemplate;
DROP TABLE IF EXISTS rules;
DROP TABLE IF EXISTS assistanttemplaterelation;
DROP TABLE IF EXISTS templatestatistics;
DROP TABLE IF EXISTS assistantrulerelation;
DROP TABLE IF EXISTS automationassistant;
DROP TABLE IF EXISTS automationinstance;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS emailreview;

CREATE TYPE TEMPLATESTATUS AS ENUM ('Draft', 'Active');

CREATE TABLE automationtemplate (
  templateid VARCHAR(255) PRIMARY KEY UNIQUE,
  companyid VARCHAR(255) UNIQUE,
  template JSONB,
  createdBy VARCHAR(255),
  createdAt TIMESTAMP without time zone,
  modifiedBy VARCHAR(255),
  modifiedAt TIMESTAMP without time zone,
  templatename VARCHAR(255),
  description VARCHAR(255),
  categoryid VARCHAR(255),
  status TEMPLATESTATUS
);

CREATE INDEX idx_companyid_templateid  ON automationtemplate(companyid, templateid);

CREATE TABLE rules (
  ruleid VARCHAR(255) PRIMARY KEY UNIQUE,
  rule JSONB,
  createdBy VARCHAR(255),
  createdAt TIMESTAMP without time zone,
  modifiedBy VARCHAR(255),
  modifiedAt TIMESTAMP without time zone
);

CREATE TABLE assistanttemplaterelation (
  assistantid VARCHAR(255),
  templateid VARCHAR(255)
);

CREATE TABLE templatestatistics (
  templateid VARCHAR(255) PRIMARY KEY UNIQUE,
  sent INT,
  opened INT,
  responded INT,
  booked INT
);

CREATE TABLE assistantrulerelation (
  assistantid VARCHAR(255) PRIMARY KEY UNIQUE,
  ruleid VARCHAR(255)
);

CREATE TABLE automationassistant (
  companyid VARCHAR(255),
  assistantid VARCHAR(255) UNIQUE,
  email VARCHAR(255),
  metadata JSONB
);

CREATE TABLE automationinstance (
  messageid VARCHAR(255) PRIMARY KEY UNIQUE,
  templateid VARCHAR(255),
  emailinfo JSONB,
  rootmessageid VARCHAR(255),
  replytomessageid VARCHAR(255)
);

CREATE TABLE category (
  categoryid VARCHAR(255) PRIMARY KEY UNIQUE,
  metadata JSONB,
  categoryname VARCHAR(255),
  description VARCHAR(255),
  createdBy VARCHAR(255),
  createdAt TIMESTAMP without time zone,
  modifiedBy VARCHAR(255),
  modifiedAt TIMESTAMP without time zone
);

CREATE TYPE EMAILSTATUS AS ENUM ('Draft', 'Edit & Send', 'Sent');

CREATE TABLE emailreview (
  replytomessageid VARCHAR(255),
  generatedreply JSONB,
  status EMAILSTATUS
);


ALTER TABLE templatestatistics
DROP CONSTRAINT IF EXISTS templatestatistics_automationtemplate_fkey,
ADD CONSTRAINT templatestatistics_automationtemplate_fkey FOREIGN KEY(templateid) REFERENCES automationtemplate(templateid);

ALTER TABLE assistanttemplaterelation
DROP CONSTRAINT IF EXISTS assistanttemplaterelation_automationtemplate_fkey,
ADD CONSTRAINT assistanttemplaterelation_automationtemplate_fkey FOREIGN KEY(templateid) REFERENCES automationtemplate(templateid);

ALTER TABLE assistanttemplaterelation
DROP CONSTRAINT IF EXISTS assistanttemplaterelation_automationassistant_fkey,
ADD CONSTRAINT assistanttemplaterelation_automationassistant_fkey FOREIGN KEY(assistantid) REFERENCES automationassistant(assistantid);

ALTER TABLE automationassistant
DROP CONSTRAINT IF EXISTS automationassistant_automationtemplate_fkey,
ADD CONSTRAINT automationassistant_automationtemplate_fkey FOREIGN KEY(companyid) REFERENCES automationtemplate(companyid);

ALTER TABLE assistantrulerelation
DROP CONSTRAINT IF EXISTS rules_assistantrulerelation_fkey,
ADD CONSTRAINT rules_assistantrulerelation_fkey FOREIGN KEY(ruleid) REFERENCES rules(ruleid);

ALTER TABLE assistantrulerelation
DROP CONSTRAINT IF EXISTS automationassistant_assistantrulerelation_fkey,
ADD CONSTRAINT automationassistant_assistantrulerelation_fkey FOREIGN KEY(assistantid) REFERENCES automationassistant(assistantid);

ALTER TABLE automationinstance
DROP CONSTRAINT IF EXISTS automationinstance_automationtemplate_fkey,
ADD CONSTRAINT automationinstance_automationtemplate_fkey FOREIGN KEY(templateid) REFERENCES automationtemplate(templateid);

ALTER TABLE automationtemplate
DROP CONSTRAINT IF EXISTS automationtemplate_category_fkey,
ADD CONSTRAINT automationtemplate_category_fkey FOREIGN KEY(categoryid) REFERENCES category(categoryid);

ALTER TABLE emailreview
DROP CONSTRAINT IF EXISTS emailreview_automationinstance_fkey,
ADD CONSTRAINT emailreview_automationinstance_fkey FOREIGN KEY(replytomessageid) REFERENCES automationinstance(messageid);