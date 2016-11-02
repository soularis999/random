----------
-- eXcellence Awards database creation script
-- DB2 7.2
----------

-- need to run DB2 commands with a correctly set environment: use db2inst1 user
su - db2inst1
db2 -t;

----------
-- connect as the right user
connect to awards user exadmin using xxx;

----------
-- create initial data
----------

----------
-- insert judge table data

insert into judges values ('admin','xxx', 1, 'timothy_dyck@ziffdavis.com');
commit;

----------
-- credit card table data

insert into exadmin.creditcards values ('VISA', 'VISA');
insert into exadmin.creditcards values ('MC', 'MasterCard');
insert into exadmin.creditcards values ('AMEX', 'American Express');
commit;

----------
-- categories table data

insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Server and Desktop Hardware', 'servers, PCs, storage, handhelds, phones', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Networking and Management Tools', 'all networking hardware, all network management, VoIP', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Security', 'firewalls, IDS, antivirus, pentration testing, OS addons', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Personal Productivity', 'desktop apps, e-mail clients, anything with desktop component or used by end users', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Developer', 'development tools, web site creation', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Server Software', 'e-mail servers, databases, app servers, CRM, ERP, Financial', '(no criteria)', 'N');
insert into categories values (DEFAULT, 'Preliminary Category', 1.0, 'Other', 'other', '(no criteria)', 'N');
commit;

----------
-- rankings table data

insert into exadmin.rankings values (DEFAULT, 0, 'Difficult to categorize', '');
insert into exadmin.rankings values (DEFAULT, 1, 'Has some promise', '');
insert into exadmin.rankings values (DEFAULT, 2, 'Potential Top 10', '');
insert into exadmin.rankings values (DEFAULT, 3, 'Top 10', '');
insert into exadmin.rankings values (DEFAULT, 4, 'Finalist', '');
insert into exadmin.rankings values (DEFAULT, 5, 'Winner', '');
commit;

----------
-- states/provinces table data

-- US states
insert into exadmin.states values ('USA', 1.0, 'AL', 'Alabama');
insert into exadmin.states values ('USA', 1.0, 'AK', 'Alaska');
insert into exadmin.states values ('USA', 1.0, 'AZ', 'Arizona');
insert into exadmin.states values ('USA', 1.0, 'AR', 'Arkansas');
insert into exadmin.states values ('USA', 1.0, 'CA', 'California');
insert into exadmin.states values ('USA', 1.0, 'CO', 'Colorado');
insert into exadmin.states values ('USA', 1.0, 'CT', 'Connecticut');
insert into exadmin.states values ('USA', 1.0, 'DC', 'D.C.');
insert into exadmin.states values ('USA', 1.0, 'DE', 'Delaware');
insert into exadmin.states values ('USA', 1.0, 'FL', 'Florida');
insert into exadmin.states values ('USA', 1.0, 'GA', 'Georgia');
insert into exadmin.states values ('USA', 1.0, 'HI', 'Hawaii');
insert into exadmin.states values ('USA', 1.0, 'ID', 'Idaho');
insert into exadmin.states values ('USA', 1.0, 'IL', 'Illinois');
insert into exadmin.states values ('USA', 1.0, 'IN', 'Indiana');
insert into exadmin.states values ('USA', 1.0, 'IA', 'Iowa');
insert into exadmin.states values ('USA', 1.0, 'KS', 'Kansas');
insert into exadmin.states values ('USA', 1.0, 'KY', 'Kentucky');
insert into exadmin.states values ('USA', 1.0, 'LA', 'Louisiana');
insert into exadmin.states values ('USA', 1.0, 'ME', 'Maine');
insert into exadmin.states values ('USA', 1.0, 'MD', 'Maryland');
insert into exadmin.states values ('USA', 1.0, 'MA', 'Massachusetts');
insert into exadmin.states values ('USA', 1.0, 'MI', 'Michigan');
insert into exadmin.states values ('USA', 1.0, 'MN', 'Minnesota');
insert into exadmin.states values ('USA', 1.0, 'MS', 'Mississippi');
insert into exadmin.states values ('USA', 1.0, 'MO', 'Missouri');
insert into exadmin.states values ('USA', 1.0, 'MT', 'Montana');
insert into exadmin.states values ('USA', 1.0, 'NE', 'Nebraska');
insert into exadmin.states values ('USA', 1.0, 'NV', 'Nevada');
insert into exadmin.states values ('USA', 1.0, 'NH', 'New Hampshire');
insert into exadmin.states values ('USA', 1.0, 'NJ', 'New Jersey');
insert into exadmin.states values ('USA', 1.0, 'NM', 'New Mexico');
insert into exadmin.states values ('USA', 1.0, 'NY', 'New York');
insert into exadmin.states values ('USA', 1.0, 'NC', 'North Carolina');
insert into exadmin.states values ('USA', 1.0, 'ND', 'North Dakota');
insert into exadmin.states values ('USA', 1.0, 'OH', 'Ohio');
insert into exadmin.states values ('USA', 1.0, 'OK', 'Oklahoma');
insert into exadmin.states values ('USA', 1.0, 'OR', 'Oregon');
insert into exadmin.states values ('USA', 1.0, 'PA', 'Pennsylvania');
insert into exadmin.states values ('USA', 1.0, 'RI', 'Rhode Island');
insert into exadmin.states values ('USA', 1.0, 'SC', 'South Carolina');
insert into exadmin.states values ('USA', 1.0, 'SD', 'South Dakota');
insert into exadmin.states values ('USA', 1.0, 'TN', 'Tennessee');
insert into exadmin.states values ('USA', 1.0, 'TX', 'Texas');
insert into exadmin.states values ('USA', 1.0, 'UT', 'Utah');
insert into exadmin.states values ('USA', 1.0, 'VT', 'Vermont');
insert into exadmin.states values ('USA', 1.0, 'VA', 'Virginia');
insert into exadmin.states values ('USA', 1.0, 'WA', 'Washington');
insert into exadmin.states values ('USA', 1.0, 'WV', 'West Virginia');
insert into exadmin.states values ('USA', 1.0, 'WI', 'Wisconsin');
insert into exadmin.states values ('USA', 1.0, 'WY', 'Wyoming');

-- Canadian provinces
insert into exadmin.states values ('Canada', 2.0, 'AB', 'Alberta');
insert into exadmin.states values ('Canada', 2.0, 'BC', 'British Columbia');
insert into exadmin.states values ('Canada', 2.0, 'MB', 'Manitoba');
insert into exadmin.states values ('Canada', 2.0, 'NB', 'New Brunswick');
insert into exadmin.states values ('Canada', 2.0, 'NF', 'Newfoundland and Labrador');
insert into exadmin.states values ('Canada', 2.0, 'NT', 'Northwest Territory');
insert into exadmin.states values ('Canada', 2.0, 'NS', 'Nova Scotia');
insert into exadmin.states values ('Canada', 2.0, 'NU', 'Nunavut');
insert into exadmin.states values ('Canada', 2.0, 'ON', 'Ontario');
insert into exadmin.states values ('Canada', 2.0, 'PE', 'Prince Edward Island');
insert into exadmin.states values ('Canada', 2.0, 'QC', 'Quebec');
insert into exadmin.states values ('Canada', 2.0, 'SK', 'Saskatchewan');
insert into exadmin.states values ('Canada', 2.0, 'YT', 'Yukon Territory');

-- other
insert into exadmin.states values ('Other', 10.0, 'NA','(Not Applicable)');

commit;
