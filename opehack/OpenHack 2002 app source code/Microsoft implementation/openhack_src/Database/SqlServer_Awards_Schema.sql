-- TODO: Before Installing look for the account name to be used
-- and fixup the local account being used



IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Awards')
	DROP DATABASE [Awards]
GO

CREATE DATABASE [Awards]  ON (NAME = N'Awards_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\Awards_Data.MDF' , SIZE = 2, FILEGROWTH = 10%) LOG ON (NAME = N'Awards_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\Awards_Log.LDF' , SIZE = 1, FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'Awards', N'autoclose', N'false'
GO

exec sp_dboption N'Awards', N'bulkcopy', N'false'
GO

exec sp_dboption N'Awards', N'trunc. log', N'false'
GO

exec sp_dboption N'Awards', N'torn page detection', N'true'
GO

exec sp_dboption N'Awards', N'read only', N'false'
GO

exec sp_dboption N'Awards', N'dbo use', N'false'
GO

exec sp_dboption N'Awards', N'single', N'false'
GO

exec sp_dboption N'Awards', N'autoshrink', N'false'
GO

exec sp_dboption N'Awards', N'ANSI null default', N'false'
GO

exec sp_dboption N'Awards', N'recursive triggers', N'false'
GO

exec sp_dboption N'Awards', N'ANSI nulls', N'false'
GO

exec sp_dboption N'Awards', N'concat null yields null', N'false'
GO

exec sp_dboption N'Awards', N'cursor close on commit', N'false'
GO

exec sp_dboption N'Awards', N'default to local cursor', N'false'
GO

exec sp_dboption N'Awards', N'quoted identifier', N'false'
GO

exec sp_dboption N'Awards', N'ANSI warnings', N'false'
GO

exec sp_dboption N'Awards', N'auto create statistics', N'true'
GO

exec sp_dboption N'Awards', N'auto update statistics', N'true'
GO

use [Awards]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddCheckPayment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddCheckPayment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddCreditPayment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddCreditPayment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddNewCompany]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddNewCompany]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddNewProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddNewProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddNewUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddNewUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CheckPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Check]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DeleteProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DeleteProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetAllUserCompanies]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetAllUserCompanies]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCompanyAndPaymentInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetCompanyAndPaymentInfo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCompanyId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetCompanyId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCompanyList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetCompanyList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCompanyName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetCompanyName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCreditCardBrands]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetCreditCardBrands]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetNumCompaniesRegistered]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetNumCompaniesRegistered]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetNumEntriesSubmitted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetNumEntriesSubmitted]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetProductInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetProductInfo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetProductList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetProductList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetStates]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUserEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetUserEmail]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUserInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetUserInfo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUserLostPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetUserLostPassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IsEmailTaken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IsEmailTaken]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IsUserCompany]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IsUserCompany]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IsUserIdTaken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IsUserIdTaken]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IsUserProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IsUserProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateCompany]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateCompany]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdatePassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdatePassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdatePaymentAsCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdatePaymentAsCheck]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdatePaymentAsCredit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdatePaymentAsCredit]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateUserInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateUserInfo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_adminusers]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_adminusers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_categories]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_categories]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_companies]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_companies]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_judges]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_judges]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_products]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_products]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_rankings]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_rankings]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_users]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_users]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[judge_users_companies]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[judge_users_companies]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_companies]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_companies]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_creditcards]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_creditcards]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_payment]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_payment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_products]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_products]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_states]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_states]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_users]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_users]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webuser_users_companies]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[webuser_users_companies]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ADMINUSERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ADMINUSERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CATEGORIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CATEGORIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMPANIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COMPANIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CREDITCARDS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CREDITCARDS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JUDGES_CATEGORIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[JUDGES_CATEGORIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PAYMENT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PAYMENT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUCTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUCTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RANKINGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RANKINGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERS_COMPANIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USERS_COMPANIES]
GO


CREATE TABLE [dbo].[ADMINUSERS] (
	[USERID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PASSWORD] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ACCESSLEVEL] [int] NOT NULL ,
	[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NOT NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CATEGORIES] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CATEGORYHEADING] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SORTORDER] [float] NOT NULL ,
	[CATEGORYNAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CRITERIA] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LEADJUDGE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OTHERJUDGES] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OBSOLETE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NOT NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[COMPANIES] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[COMPANYNAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ADDRESS1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ADDRESS2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZIP] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COUNTRY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FAX] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[URL] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CREDITCARDS] (
	[SHORTNAME] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LONGNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[JUDGES_CATEGORIES] (
	[USERID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CATEGORYID] [int] NOT NULL ,
	[LEADJUDGE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

-- eo: expanded credit card field to accomodate encrypted data
CREATE TABLE [dbo].[PAYMENT] (
	[COMPANYID] [int] NOT NULL ,
	[CREDITCARDBRAND] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CREDITCARD] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CREDITCARDEXPIRY] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGADDRESS1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGADDRESS2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGCITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGSTATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGZIP] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGCOUNTRY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BILLINGPHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CHECKPAYMENT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PAYMENTPROCESSEDTIMESTAMP] [datetime] NULL ,
	[CREDITCARDAUTHORIZATIONCODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CREDITISSUED] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CREDITISSUEDTIMESTAMP] [datetime] NULL ,
	[PAYMENTCOMMENT] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NULL ,
	[REFUNDISSUED] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[REFUNDISSUEDTIMESTAMP] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PRODUCTS] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[COMPANYID] [int] NOT NULL ,
	[PRODUCTNAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VERSION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ANNOUNCEMENTDATE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SHIPDATE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[URL] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NDA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TARGETAUDIENCE] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BUSINESSPROBLEM] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[COMPETITORS] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[KEYFEATURES] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PRICE] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CUSTOMERREFERENCES] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CATEGORYID] [int] NULL ,
	[CATEGORYASSIGNER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CATEGORYTIMESTAMP] [datetime] NULL ,
	[REASSIGNEDCATEGORYID] [int] NULL ,
	[REASSIGNEDCATEGORYASSIGNER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[REASSIGNEDCATEGORYTIMESTAMP] [datetime] NULL ,
	[RANKINGID] [int] NULL ,
	[RANKINGIDTIMESTAMP] [datetime] NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NULL ,
	[ORIGINALCATEGORYID] [int] NULL ,
	[PREVIOUSCATEGORYID] [int] NULL ,
	[PREVIOUSCATEGORYASSIGNER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PREVIOUSCATEGORYTIMESTAMP] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[RANKINGS] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[RANKINGSCORE] [int] NOT NULL ,
	[RANKINGNAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RANKINGDESCRIPTION] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[STATES] (
	[COUNTRY] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[COUNTRYSORTORDER] [float] NOT NULL ,
	[SHORTNAME] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LONGNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

-- eo: expanded password field to account for encryption/encoding (16->50)
CREATE TABLE [dbo].[USERS] (
	[USERID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PASSWORD] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[USERNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TITLE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COMPANYNAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NOTIFYNEXTYEAR] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RECORDCREATIONTIMESTAMP] [datetime] NULL ,
	[RECORDMODIFICATIONTIMESTAMP] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[USERS_COMPANIES] (
	[USERID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[COMPANYID] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ADMINUSERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ADMINUSERS] PRIMARY KEY  CLUSTERED 
	(
		[USERID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_CATEGORIES] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMPANIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMPANIES] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CREDITCARDS] WITH NOCHECK ADD 
	CONSTRAINT [PK_CREDITCARDS] PRIMARY KEY  CLUSTERED 
	(
		[SHORTNAME]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[JUDGES_CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_JUDGES_CATEGORIES] PRIMARY KEY  CLUSTERED 
	(
		[USERID],
		[CATEGORYID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PAYMENT] WITH NOCHECK ADD 
	CONSTRAINT [PK_PAYMENT] PRIMARY KEY  CLUSTERED 
	(
		[COMPANYID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PRODUCTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PRODUCTS] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RANKINGS] WITH NOCHECK ADD 
	CONSTRAINT [PK_RANKINGS] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[STATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_STATES] PRIMARY KEY  CLUSTERED 
	(
		[SHORTNAME]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_USERS] PRIMARY KEY  CLUSTERED 
	(
		[USERID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USERS_COMPANIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_USERS_COMPANIES] PRIMARY KEY  CLUSTERED 
	(
		[USERID],
		[COMPANYID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ADMINUSERS] WITH NOCHECK ADD 
	CONSTRAINT [DF_ADMINUSERS_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [DF_ADMINUSERS_RECORDMODIFICATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDMODIFICATIONTIMESTAMP]
GO

ALTER TABLE [dbo].[CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [DF_CATEGORIES_OBSOLETE] DEFAULT ('N') FOR [OBSOLETE],
	CONSTRAINT [DF_CATEGORIES_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [DF_CATEGORIES_RECORDMODIFICATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDMODIFICATIONTIMESTAMP]
GO

ALTER TABLE [dbo].[COMPANIES] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMPANIES_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [DF_COMPANIES_RECORDMODIFICATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDMODIFICATIONTIMESTAMP]
GO

ALTER TABLE [dbo].[JUDGES_CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [DF_JUDGES_CATEGORIES_LEADJUDGE] DEFAULT ('N') FOR [LEADJUDGE]
GO

ALTER TABLE [dbo].[PAYMENT] WITH NOCHECK ADD 
	CONSTRAINT [DF_PAYMENT_CHECKPAYMENT] DEFAULT ('N') FOR [CHECKPAYMENT],
	CONSTRAINT [DF_PAYMENT_CREDITISSUED] DEFAULT ('N') FOR [CREDITISSUED],
	CONSTRAINT [DF_PAYMENT_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [DF_PAYMENT_RECORDMODIFICATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDMODIFICATIONTIMESTAMP],
	CONSTRAINT [DF_PAYMENT_REFUNDISSUED] DEFAULT ('N') FOR [REFUNDISSUED],
	CONSTRAINT [CK_PAYMENT] CHECK (([CHECKPAYMENT] = 'N' or [CHECKPAYMENT] = 'Y') and ([CREDITISSUED] = 'N' or [CREDITISSUED] = 'Y') and ([REFUNDISSUED] = 'N' or [REFUNDISSUED] = 'Y'))
GO

ALTER TABLE [dbo].[PRODUCTS] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUCTS_NDA] DEFAULT ('N') FOR [NDA],
	CONSTRAINT [DF_PRODUCTS_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [CK_PRODUCTS] CHECK ([NDA] = 'N' or [NDA] = 'Y')
GO

ALTER TABLE [dbo].[USERS] WITH NOCHECK ADD 
	CONSTRAINT [DF_USERS_NOTIFYNEXTYEAR] DEFAULT ('N') FOR [NOTIFYNEXTYEAR],
	CONSTRAINT [DF_USERS_RECORDCREATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDCREATIONTIMESTAMP],
	CONSTRAINT [DF_USERS_RECORDMODIFICATIONTIMESTAMP] DEFAULT (getdate()) FOR [RECORDMODIFICATIONTIMESTAMP],
	CONSTRAINT [IX_USERS] UNIQUE  NONCLUSTERED 
	(
		[EMAIL]
	)  ON [PRIMARY] ,
	CONSTRAINT [CK_USERS] CHECK ([NOTIFYNEXTYEAR] = 'N' or [NOTIFYNEXTYEAR] = 'Y')
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_adminusers
AS
SELECT     *
FROM         dbo.ADMINUSERS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_categories
AS
SELECT     *
FROM         dbo.CATEGORIES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_companies
AS
SELECT     *
FROM         dbo.COMPANIES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_judges
AS
SELECT     *
FROM         dbo.ADMINUSERS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_products
AS
SELECT     *
FROM         dbo.PRODUCTS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_rankings
AS
SELECT     *
FROM         dbo.RANKINGS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_users
AS
SELECT     *
FROM         dbo.USERS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.judge_users_companies
AS
SELECT     *
FROM         dbo.USERS_COMPANIES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_companies
AS
SELECT     *
FROM         dbo.COMPANIES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_creditcards
AS
SELECT     *
FROM         dbo.CREDITCARDS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_payment
AS
SELECT     *
FROM         dbo.PAYMENT


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_products
AS
SELECT     *
FROM         dbo.PRODUCTS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_states
AS
SELECT     *
FROM         dbo.STATES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_users
AS
SELECT     *
FROM         dbo.USERS


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.webuser_users_companies
AS
SELECT     *
FROM         dbo.USERS_COMPANIES


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [AddCheckPayment] 

@COMPANYID int

AS

insert into PAYMENT 
values (@COMPANYID, null, '', '', '', '', '', '', null, '', '', '', 'Y', null, null, 'N', null, null, getdate(), getdate(), 'N', null)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


-- eo: updated CREDITCARD length to accomodate encryption
CREATE PROCEDURE [AddCreditPayment] 

@COMPANYID int,
@CREDITCARDBRAND varchar(10),
@CREDITCARD varchar(100),
@CREDITCARDEXPIRY varchar(10),
@BILLINGNAME varchar(30),
@BILLINGADDRESS1 varchar(30),
@BILLINGADDRESS2 varchar(30),
@BILLINGCITY varchar(30),
@BILLINGSTATE varchar(2),
@BILLINGZIP varchar(15),
@BILLINGCOUNTRY varchar(30),
@BILLINGPHONE varchar(20)

AS

insert into PAYMENT 
values (
@COMPANYID, 
@CREDITCARDBRAND,  
@CREDITCARD, 
@CREDITCARDEXPIRY, 
@BILLINGNAME, 
@BILLINGADDRESS1, 
@BILLINGADDRESS2, 
@BILLINGCITY, 
@BILLINGSTATE, 
@BILLINGZIP, 
@BILLINGCOUNTRY, 
@BILLINGPHONE, 
'N', 
null, 
null, 
'N', 
null, 
null, 
getdate(), 
getdate(), 
'N', 
null)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [AddNewCompany] 

@USERID varchar(10), 
@COMPANYNAME varchar(100), 
@COMPANYADDRESS1 varchar(50), 
@COMPANYADDRESS2 varchar(50), 
@COMPANYCITY varchar(30), 
@COMPANYSTATE varchar(2), 
@COMPANYZIP varchar(15), 
@COMPANYCOUNTRY varchar(30), 
@COMPANYPHONE varchar(20), 
@COMPANYFAX varchar(20), 
@COMPANYURL varchar(100)

AS

Declare @COMPANYID int

insert into COMPANIES 
values (
@COMPANYNAME, 
@COMPANYADDRESS1, 
@COMPANYADDRESS2, 
@COMPANYCITY, 
@COMPANYSTATE, 
@COMPANYZIP, 
@COMPANYCOUNTRY, 
@COMPANYPHONE, 
@COMPANYFAX, 
@COMPANYURL, 
getdate(), getdate()
) 

select @COMPANYID = @@identity

insert into USERS_COMPANIES
values (@USERID, @COMPANYID )

select @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [AddNewProduct] 

@COMPANYID int,
@PRODUCTNAME varchar(100),
@VERSION varchar(30),
@ANNOUNCEMENTDATE varchar(30),
@SHIPDATE varchar(30),
@PRODUCTURL varchar(100),
@PRODUCTNDA char(1),
@TARGETAUDIENCE text,
@DESCRIPTION text,
@BUSINESSPROBLEM text,
@COMPETITORS text,
@KEYFEATURES text,
@PRICE text,
@CUSTOMERREFERENCES text

AS

insert into PRODUCTS 
values (
@COMPANYID, 
@PRODUCTNAME, 
@VERSION, 
@ANNOUNCEMENTDATE, 
@SHIPDATE, 
@PRODUCTURL, 
@PRODUCTNDA, 
@TARGETAUDIENCE, 
@DESCRIPTION, 
@BUSINESSPROBLEM, 
@COMPETITORS, 
@KEYFEATURES, 
@PRICE, 
@CUSTOMERREFERENCES, 
null, null, null, null, null, null, null, null, getdate(), getdate(), null, null, null, null
)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [AddNewUser] 

@USERID varchar(10), 
@USERPASSWORD varchar(50), 
@USERNAME varchar(30), 
@USERTITLE varchar(50), 
@COMPANYNAME varchar(50), 
@USERPHONE varchar(20), 
@USEREMAIL varchar(50),
@NOTIFYNEXTYEAR char(1)

AS

insert into USERS 
values (
@USERID, 
@USERPASSWORD, 
@USERNAME, 
@USERTITLE, 
@COMPANYNAME, 
@USERPHONE, 
@USEREMAIL, 
@NOTIFYNEXTYEAR, 
getdate(), getdate()
)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [CheckPassword] 

@USERID varchar(10),
@PASSWORD varchar(50)

AS

select count(USERID) 
from USERS 
where USERID = @USERID and cast(PASSWORD as varbinary) = cast(@PASSWORD as varbinary)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [DeleteProduct] 

@PRODUCTID int

AS

delete from PRODUCTS 
where ID = @PRODUCTID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetAllUserCompanies] 

@USERID varchar(10)

AS

select COMPANYID 
from USERS_COMPANIES 
where USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetCompanyAndPaymentInfo] 

@COMPANYID int

AS

select * 
from COMPANIES join PAYMENT on PAYMENT.COMPANYID = COMPANIES.ID 
where ID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetCompanyId] 

@USERID varchar(10),
@PRODUCTID int

AS

select USERS_COMPANIES.COMPANYID 
from USERS_COMPANIES, PRODUCTS
where USERID = @USERID and USERS_COMPANIES.COMPANYID = PRODUCTS.COMPANYID and PRODUCTS.ID = @PRODUCTID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetCompanyList]

@USERID varchar(10)

AS

select COMPANIES.ID, COMPANIES.COMPANYNAME, COMPANIES.RECORDCREATIONTIMESTAMP, count(PRODUCTS.ID) as NUMBEROFENTRIES 
from USERS_COMPANIES, COMPANIES left join PRODUCTS on COMPANIES.ID = PRODUCTS.COMPANYID 
where USERS_COMPANIES.USERID = @USERID and USERS_COMPANIES.COMPANYID = COMPANIES.ID 
group by COMPANIES.ID, COMPANIES.COMPANYNAME, COMPANIES.RECORDCREATIONTIMESTAMP 
order by COMPANIES.RECORDCREATIONTIMESTAMP

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetCompanyName] 

@COMPANYID int

AS

select COMPANYNAME 
from COMPANIES 
where ID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetCreditCardBrands] 

AS

select LONGNAME, SHORTNAME 
from CREDITCARDS 
order by LONGNAME

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetNumCompaniesRegistered] 

@USERID varchar(10)

AS

select count(COMPANYID) 
from USERS_COMPANIES 
where USERID = @USERID


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetNumEntriesSubmitted] 

@USERID varchar(10)

AS

select count(PRODUCTS.ID) 
from PRODUCTS, USERS_COMPANIES 
where PRODUCTS.COMPANYID = USERS_COMPANIES.COMPANYID and USERS_COMPANIES.USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetProductInfo] 

@PRODUCTID int

AS

select COMPANIES.COMPANYNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.VERSION, PRODUCTS.ANNOUNCEMENTDATE, PRODUCTS.SHIPDATE, PRODUCTS.URL, PRODUCTS.NDA, PRODUCTS.TARGETAUDIENCE, PRODUCTS.DESCRIPTION, PRODUCTS.BUSINESSPROBLEM, PRODUCTS.COMPETITORS, PRODUCTS.KEYFEATURES, PRODUCTS.PRICE, PRODUCTS.CUSTOMERREFERENCES, PRODUCTS.RECORDCREATIONTIMESTAMP 
from COMPANIES, PRODUCTS 
where COMPANIES.ID = PRODUCTS.COMPANYID and PRODUCTS.ID = @PRODUCTID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetProductList] 

@USERID varchar(10)

AS

select COMPANIES.COMPANYNAME, PRODUCTS.ID, PRODUCTS.PRODUCTNAME, PRODUCTS.VERSION, PRODUCTS.RECORDCREATIONTIMESTAMP 
from PRODUCTS, USERS_COMPANIES, COMPANIES 
where USERS_COMPANIES.USERID = @USERID and USERS_COMPANIES.COMPANYID = PRODUCTS.COMPANYID and USERS_COMPANIES.COMPANYID = COMPANIES.ID 
order by PRODUCTS.RECORDCREATIONTIMESTAMP

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetStates] 

AS

select LONGNAME, SHORTNAME 
from STATES 
order by COUNTRYSORTORDER, LONGNAME

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetUserEmail] 

@USERID varchar(10)

AS

select EMAIL 
from USERS 
where USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetUserInfo] 

@USERID varchar(10)

AS

select USERNAME, TITLE, COMPANYNAME, PHONE, EMAIL, NOTIFYNEXTYEAR 
from USERS 
where USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [GetUserLostPassword] 

@USEREMAIL varchar(50)

AS

select USERNAME, USERID, PASSWORD 
from USERS 
where EMAIL = @USEREMAIL

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [IsEmailTaken] 

@USERID varchar(10),
@NEWEMAIL varchar(50)

AS

select count(USERID) 
from USERS 
where EMAIL = @NEWEMAIL and USERID != @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [IsUserCompany] 

@USERID varchar(10),
@COMPANYID int

AS

select count(USERID) 
from USERS_COMPANIES 
where USERID = @USERID and COMPANYID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [IsUserIdTaken] 

@USERID varchar(10)

AS

select count(USERID) 
from USERS 
where USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [IsUserProduct] 

@USERID varchar(10),
@PRODUCTID int

AS

select count(USERS_COMPANIES.USERID) 
from USERS_COMPANIES, PRODUCTS 
where USERS_COMPANIES.USERID = @USERID and USERS_COMPANIES.COMPANYID = PRODUCTS.COMPANYID and PRODUCTS.ID = @PRODUCTID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [UpdateCompany] 

@COMPANYID int,
@COMPANYNAME varchar(100),
@COMPANYADDRESS1 varchar(50),
@COMPANYADDRESS2 varchar(50),
@COMPANYCITY varchar(30),
@COMPANYSTATE varchar(2),
@COMPANYZIP varchar(15),
@COMPANYCOUNTRY varchar(30),
@COMPANYPHONE varchar(20),
@COMPANYFAX varchar(20),
@COMPANYURL varchar(100)

AS

update COMPANIES
set 
COMPANYNAME = @COMPANYNAME, 
ADDRESS1 = @COMPANYADDRESS1, 
ADDRESS2 = @COMPANYADDRESS2, 
CITY = @COMPANYCITY, 
STATE = @COMPANYSTATE, 
ZIP = @COMPANYZIP, 
COUNTRY = @COMPANYCOUNTRY, 
PHONE = @COMPANYPHONE, 
FAX = @COMPANYFAX, 
URL = @COMPANYURL, 
RECORDMODIFICATIONTIMESTAMP = getdate() 
where ID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [UpdatePassword] 

@USERID varchar(10),
@PASSWORD varchar(50),
@NEWPASSWORD varchar(50)

AS

update USERS set PASSWORD = @NEWPASSWORD 
where USERID = @USERID and PASSWORD = @PASSWORD

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [UpdatePaymentAsCheck] 

@COMPANYID int

AS

update PAYMENT 
set CREDITCARDBRAND = null, 
CREDITCARD = '', 
CREDITCARDEXPIRY = '', 
BILLINGNAME = '', 
BILLINGADDRESS1 = '', 
BILLINGADDRESS2 = '', 
BILLINGCITY = '', 
BILLINGSTATE = null, 
BILLINGCOUNTRY = '', 
BILLINGPHONE = '', 
CHECKPAYMENT = 'Y', 
RECORDMODIFICATIONTIMESTAMP = getdate() 
where COMPANYID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


-- eo: updated credit card length for encryption
CREATE PROCEDURE [UpdatePaymentAsCredit] 

@COMPANYID int,
@CREDITCARDBRAND varchar(10),
@CREDITCARD varchar(100),
@CREDITCARDEXPIRY varchar(10),
@BILLINGNAME varchar(30),
@BILLINGADDRESS1 varchar(30),
@BILLINGADDRESS2 varchar(30),
@BILLINGCITY varchar(30),
@BILLINGSTATE varchar(2),
@BILLINGZIP varchar(15),
@BILLINGCOUNTRY varchar(30),
@BILLINGPHONE varchar(20)

AS

update PAYMENT 
set 
CREDITCARDBRAND = @CREDITCARDBRAND, 
CREDITCARD = @CREDITCARD, 
CREDITCARDEXPIRY = @CREDITCARDEXPIRY, 
BILLINGNAME = @BILLINGNAME, 
BILLINGADDRESS1 = @BILLINGADDRESS1, 
BILLINGADDRESS2 = @BILLINGADDRESS2, 
BILLINGCITY = @BILLINGCITY, 
BILLINGSTATE = @BILLINGSTATE, 
BILLINGZIP = @BILLINGZIP, 
BILLINGCOUNTRY = @BILLINGCOUNTRY, 
BILLINGPHONE = @BILLINGPHONE, 
CHECKPAYMENT = 'N', 
RECORDMODIFICATIONTIMESTAMP = getdate() 
where COMPANYID = @COMPANYID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [UpdateProduct] 

@PRODUCTID int,
@PRODUCTNAME varchar(100),
@VERSION varchar(30),
@ANNOUNCEMENTDATE varchar(30),
@SHIPDATE varchar(30),
@PRODUCTURL varchar(100),
@PRODUCTNDA char(1),
@TARGETAUDIENCE text,
@DESCRIPTION text,
@BUSINESSPROBLEM text,
@COMPETITIORS text,
@KEYFEATURES text,
@PRICE text,
@CUSTOMERREFERENCES text

AS


update PRODUCTS 
set 
PRODUCTNAME = @PRODUCTNAME, 
VERSION = @VERSION, 
ANNOUNCEMENTDATE = @ANNOUNCEMENTDATE, 
SHIPDATE = @SHIPDATE, 
URL = @PRODUCTURL, 
NDA = @PRODUCTNDA, 
TARGETAUDIENCE = @TARGETAUDIENCE, 
DESCRIPTION = @DESCRIPTION, 
BUSINESSPROBLEM = @BUSINESSPROBLEM, 
COMPETITORS = @COMPETITIORS, 
KEYFEATURES = @KEYFEATURES, 
PRICE = @PRICE, 
CUSTOMERREFERENCES = @CUSTOMERREFERENCES, 
RECORDMODIFICATIONTIMESTAMP = getdate() 
where ID = @PRODUCTID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [UpdateUserInfo] 

@USERID varchar(10), 
@USERNAME varchar(30), 
@USERTITLE varchar(50), 
@COMPANYNAME varchar(50), 
@USERPHONE varchar(20), 
@USEREMAIL varchar(50),
@NOTIFYNEXTYEAR char(1)

AS

update USERS 
set USERNAME = @USERNAME, 
TITLE = @USERTITLE, 
COMPANYNAME = @COMPANYNAME, 
PHONE = @USERPHONE, 
EMAIL = @USEREMAIL, 
NOTIFYNEXTYEAR = @NOTIFYNEXTYEAR, 
RECORDMODIFICATIONTIMESTAMP = getdate() 
where USERID = @USERID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

-- TODO: Fixup the local account being used

EXEC sp_grantdbaccess [ERIKOLS\ASPNET], 'webuser'
GO

-- grant dB access
grant execute on [dbo].[AddCheckPayment] to webuser
GO

grant execute on [dbo].[AddCreditPayment] to webuser
GO

grant execute on [dbo].[AddNewCompany] to webuser
GO

grant execute on [dbo].[AddNewProduct] to webuser
GO

grant execute on [dbo].[AddNewUser] to webuser
GO

grant execute on [dbo].[CheckPassword] to webuser
GO

grant execute on [dbo].[DeleteProduct] to webuser
GO

grant execute on [dbo].[GetAllUserCompanies] to webuser
GO

grant execute on [dbo].[GetCompanyAndPaymentInfo] to webuser
GO

grant execute on [dbo].[GetCompanyId] to webuser
GO

grant execute on [dbo].[GetCompanyList] to webuser
GO

grant execute on [dbo].[GetCompanyName] to webuser
GO

grant execute on [dbo].[GetCreditCardBrands] to webuser
GO

grant execute on [dbo].[GetNumCompaniesRegistered] to webuser
GO

grant execute on [dbo].[GetNumEntriesSubmitted] to webuser
GO

grant execute on [dbo].[GetProductInfo] to webuser
GO

grant execute on [dbo].[GetProductList] to webuser
GO

grant execute on [dbo].[GetStates] to webuser
GO

grant execute on [dbo].[GetUserEmail] to webuser
GO

grant execute on [dbo].[GetUserInfo] to webuser
GO

grant execute on [dbo].[GetUserLostPassword] to webuser
GO

grant execute on [dbo].[IsEmailTaken] to webuser
GO

grant execute on [dbo].[IsUserCompany] to webuser
GO

grant execute on [dbo].[IsUserIdTaken] to webuser
GO

grant execute on [dbo].[IsUserProduct] to webuser
GO

grant execute on [dbo].[UpdateCompany] to webuser
GO

grant execute on [dbo].[UpdatePassword] to webuser
GO

grant execute on [dbo].[UpdatePaymentAsCheck] to webuser
GO

grant execute on [dbo].[UpdatePaymentAsCredit] to webuser
GO

grant execute on [dbo].[UpdateProduct] to webuser
GO

grant execute on [dbo].[UpdateUserInfo] to webuser
GO
