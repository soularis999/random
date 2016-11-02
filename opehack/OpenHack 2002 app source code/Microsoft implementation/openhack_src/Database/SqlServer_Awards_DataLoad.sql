use Awards;

-- Admins
insert into adminusers values ('admin','bugsy4daisy', 1, 'timothy_dyck@ziffdavis.com', getdate(), getdate());

-- CreditCards
insert into creditcards values ('VISA', 'VISA');
insert into creditcards values ('MC', 'MasterCard');
insert into creditcards values ('AMEX', 'American Express');

-- Categories
insert into categories values ('Preliminary Category', 1.0, 'Server and Desktop Hardware', 'servers, PCs, storage, handhelds, phones', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Networking and Management Tools', 'all networking hardware, all network management, VoIP', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Security', 'firewalls, IDS, antivirus, pentration testing, OS addons', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Personal Productivity', 'desktop apps, e-mail clients, anything with desktop component or used by end users', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Developer', 'development tools, web site creation', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Server Software', 'e-mail servers, databases, app servers, CRM, ERP, Financial', '(no criteria)', null, null, 'N', getdate(), getdate());
insert into categories values ('Preliminary Category', 1.0, 'Other', 'other', '(no criteria)', null, null, 'N', getdate(), getdate());

-- Rankings
insert into rankings values (0, 'Difficult to categorize', '');
insert into rankings values (1, 'Has some promise', '');
insert into rankings values (2, 'Potential Top 10', '');
insert into rankings values (3, 'Top 10', '');
insert into rankings values (4, 'Finalist', '');
insert into rankings values (5, 'Winner', '');

-- US states
insert into states values ('USA', 1.0, 'AL', 'Alabama');
insert into states values ('USA', 1.0, 'AK', 'Alaska');
insert into states values ('USA', 1.0, 'AZ', 'Arizona');
insert into states values ('USA', 1.0, 'AR', 'Arkansas');
insert into states values ('USA', 1.0, 'CA', 'California');
insert into states values ('USA', 1.0, 'CO', 'Colorado');
insert into states values ('USA', 1.0, 'CT', 'Connecticut');
insert into states values ('USA', 1.0, 'DC', 'D.C.');
insert into states values ('USA', 1.0, 'DE', 'Delaware');
insert into states values ('USA', 1.0, 'FL', 'Florida');
insert into states values ('USA', 1.0, 'GA', 'Georgia');
insert into states values ('USA', 1.0, 'HI', 'Hawaii');
insert into states values ('USA', 1.0, 'ID', 'Idaho');
insert into states values ('USA', 1.0, 'IL', 'Illinois');
insert into states values ('USA', 1.0, 'IN', 'Indiana');
insert into states values ('USA', 1.0, 'IA', 'Iowa');
insert into states values ('USA', 1.0, 'KS', 'Kansas');
insert into states values ('USA', 1.0, 'KY', 'Kentucky');
insert into states values ('USA', 1.0, 'LA', 'Louisiana');
insert into states values ('USA', 1.0, 'ME', 'Maine');
insert into states values ('USA', 1.0, 'MD', 'Maryland');
insert into states values ('USA', 1.0, 'MA', 'Massachusetts');
insert into states values ('USA', 1.0, 'MI', 'Michigan');
insert into states values ('USA', 1.0, 'MN', 'Minnesota');
insert into states values ('USA', 1.0, 'MS', 'Mississippi');
insert into states values ('USA', 1.0, 'MO', 'Missouri');
insert into states values ('USA', 1.0, 'MT', 'Montana');
insert into states values ('USA', 1.0, 'NE', 'Nebraska');
insert into states values ('USA', 1.0, 'NV', 'Nevada');
insert into states values ('USA', 1.0, 'NH', 'New Hampshire');
insert into states values ('USA', 1.0, 'NJ', 'New Jersey');
insert into states values ('USA', 1.0, 'NM', 'New Mexico');
insert into states values ('USA', 1.0, 'NY', 'New York');
insert into states values ('USA', 1.0, 'NC', 'North Carolina');
insert into states values ('USA', 1.0, 'ND', 'North Dakota');
insert into states values ('USA', 1.0, 'OH', 'Ohio');
insert into states values ('USA', 1.0, 'OK', 'Oklahoma');
insert into states values ('USA', 1.0, 'OR', 'Oregon');
insert into states values ('USA', 1.0, 'PA', 'Pennsylvania');
insert into states values ('USA', 1.0, 'RI', 'Rhode Island');
insert into states values ('USA', 1.0, 'SC', 'South Carolina');
insert into states values ('USA', 1.0, 'SD', 'South Dakota');
insert into states values ('USA', 1.0, 'TN', 'Tennessee');
insert into states values ('USA', 1.0, 'TX', 'Texas');
insert into states values ('USA', 1.0, 'UT', 'Utah');
insert into states values ('USA', 1.0, 'VT', 'Vermont');
insert into states values ('USA', 1.0, 'VA', 'Virginia');
insert into states values ('USA', 1.0, 'WA', 'Washington');
insert into states values ('USA', 1.0, 'WV', 'West Virginia');
insert into states values ('USA', 1.0, 'WI', 'Wisconsin');
insert into states values ('USA', 1.0, 'WY', 'Wyoming');

-- Canadian provinces
insert into states values ('Canada', 2.0, 'AB', 'Alberta');
insert into states values ('Canada', 2.0, 'BC', 'British Columbia');
insert into states values ('Canada', 2.0, 'MB', 'Manitoba');
insert into states values ('Canada', 2.0, 'NB', 'New Brunswick');
insert into states values ('Canada', 2.0, 'NF', 'Newfoundland and Labrador');
insert into states values ('Canada', 2.0, 'NT', 'Northwest Territory');
insert into states values ('Canada', 2.0, 'NS', 'Nova Scotia');
insert into states values ('Canada', 2.0, 'NU', 'Nunavut');
insert into states values ('Canada', 2.0, 'ON', 'Ontario');
insert into states values ('Canada', 2.0, 'PE', 'Prince Edward Island');
insert into states values ('Canada', 2.0, 'QC', 'Quebec');
insert into states values ('Canada', 2.0, 'SK', 'Saskatchewan');
insert into states values ('Canada', 2.0, 'YT', 'Yukon Territory');

-- other
insert into states values ('Other', 10.0, 'NA','(Not Applicable)');