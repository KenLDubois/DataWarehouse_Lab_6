/****** Object:  Database [mbaddeley_IronwoodDW]    Script Date: 2019-10-06 11:09:02 AM ******/
CREATE DATABASE [kdubois1_IronwoodDW]
GO
USE [kdubois1_IronwoodDW]
GO
/****** Object:  Schema [Dimension]    Script Date: 2019-10-06 11:09:02 AM ******/
CREATE SCHEMA [Dimension]
GO
/****** Object:  Schema [Fact]    Script Date: 2019-10-06 11:09:02 AM ******/
CREATE SCHEMA [Fact]
GO
/****** Object:  Schema [Staging]    Script Date: 2019-10-06 11:09:02 AM ******/
CREATE SCHEMA [Staging]
GO
/****** Object:  UserDefinedFunction [Staging].[udf_getTermKey]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Staging].[udf_getTermKey] 
(
	@term	VARCHAR(10),
	@day	VARCHAR(8),
	@time	DATETIME
)
RETURNS BIGINT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @dateKey AS BIGINT

	-- Add the T-SQL statements to compute the return value here
	SELECT	@dateKey = datekey
	FROM	Dimension.TermDates
	WHERE	termLabel = @term
	AND		dayLabel = @day
	AND		classtime = @time

	-- Return the result of the function
	RETURN @dateKey

END
GO
/****** Object:  Table [Dimension].[Course]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Course](
	[CourseKey] [bigint] IDENTITY(1,1) NOT NULL,
	[IWCourseKey] [bigint] NOT NULL,
	[CourseName] [varchar](10) NOT NULL,
	[CourseTitle] [varchar](200) NOT NULL,
	[CourseCredits] [tinyint] NOT NULL,
	[DepartmentName] [varchar](30) NOT NULL,
	[AuditKey] [int] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[CourseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Instructor]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Instructor](
	[InstructorKey] [bigint] IDENTITY(1,1) NOT NULL,
	[IWInstructorKey] [bigint] NOT NULL,
	[InstructorFirstName] [varchar](30) NOT NULL,
	[InstructorLastName] [varchar](30) NOT NULL,
	[InstructorMI] [varchar](1) NULL,
	[DepartmentName] [varchar](30) NOT NULL,
	[ValidFrom] [date] NOT NULL,
	[ValidTo] [date] NULL,
	[AuditKey] [int] NULL,
 CONSTRAINT [PK_Instructor] PRIMARY KEY CLUSTERED 
(
	[InstructorKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Lineage]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Lineage](
	[AuditKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentAuditKey] [int] NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[PkgName] [varchar](50) NOT NULL,
	[PkgGUID] [uniqueidentifier] NULL,
	[PkgVersionGUID] [uniqueidentifier] NULL,
	[PkgVersionMajor] [smallint] NULL,
	[PkgVersionMinor] [smallint] NULL,
	[ExecStartDT] [datetime] NOT NULL,
	[ExecStopDT] [datetime] NULL,
	[ExecutionInstanceGUID] [uniqueidentifier] NULL,
	[ExtractRowCnt] [bigint] NULL,
	[InsertRowCnt] [bigint] NULL,
	[UpdateRowCnt] [bigint] NULL,
	[ErrorRowCnt] [bigint] NULL,
	[TableInitialRowCnt] [bigint] NULL,
	[TableFinalRowCnt] [bigint] NULL,
	[TableMaxDateTime] [datetime] NULL,
	[SuccessfulProcessingInd] [char](1) NOT NULL,
 CONSTRAINT [PK_dbo.DimAudit] PRIMARY KEY CLUSTERED 
(
	[AuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Student]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Student](
	[StudentKey] [bigint] IDENTITY(1,1) NOT NULL,
	[IWStudentKey] [bigint] NOT NULL,
	[StudentFirstName] [varchar](30) NOT NULL,
	[StudentLastName] [varchar](30) NOT NULL,
	[StudentDOB] [datetime] NOT NULL,
	[studentGender] [char](1) NOT NULL,
	[StudentAddress] [varchar](50) NOT NULL,
	[StudentCity] [varchar](50) NOT NULL,
	[StudentPostalCode] [varchar](10) NOT NULL,
	[StateName] [varchar](100) NOT NULL,
	[StudentAreaCode] [nvarchar](50) NOT NULL,
	[ValidFrom] [date] NULL,
	[ValidTo] [date] NULL,
	[AuditKey] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[StudentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[TermDates]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[TermDates](
	[dateKey] [bigint] IDENTITY(1,1) NOT NULL,
	[termLabel] [varchar](10) NOT NULL,
	[dayLabel] [varchar](8) NOT NULL,
	[classTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_staging.term_dates] PRIMARY KEY CLUSTERED 
(
	[dateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Fact].[EnrollmentOutcomes]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[EnrollmentOutcomes](
	[EnrollOutcomeKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CourseKey] [bigint] NOT NULL,
	[InstructorKey] [bigint] NOT NULL,
	[SectionNumber] [varchar](3) NOT NULL,
	[DateKey] [bigint] NULL,
	[StudentKey] [bigint] NOT NULL,
	[EnrollLetterGrade] [varchar](2) NULL,
	[EnrollNumberGrade] [tinyint] NULL,
	[AuditKey] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Fact].[EnrollmentSeats]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[EnrollmentSeats](
	[EnrollSeatsKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CourseKey] [bigint] NOT NULL,
	[InstructorKey] [bigint] NOT NULL,
	[SectionNumber] [varchar](3) NOT NULL,
	[DateKey] [bigint] NOT NULL,
	[SeatsActual] [smallint] NOT NULL,
	[SeatsCapacity] [smallint] NOT NULL,
	[AuditKey] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimCourse]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimCourse](
	[CourseID] [bigint] IDENTITY(1,1) NOT NULL,
	[CourseName] [varchar](10) NOT NULL,
	[CourseTitle] [varchar](200) NOT NULL,
	[CourseCredits] [tinyint] NOT NULL,
	[DepartmentID] [bigint] NOT NULL,
 CONSTRAINT [PK_DimCourse] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimDepartment]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimDepartment](
	[DepartmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_DimDepartment] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimensionLaptop]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimensionLaptop](
	[LaptopID] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentID] [bigint] NULL,
 CONSTRAINT [PK_DimensionLaptop] PRIMARY KEY CLUSTERED 
(
	[LaptopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimInstructor]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimInstructor](
	[InstructorID] [bigint] IDENTITY(1,1) NOT NULL,
	[InstructorName] [varchar](61) NOT NULL,
 CONSTRAINT [PK_DimInstructor] PRIMARY KEY CLUSTERED 
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimState]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimState](
	[StateAbbreviation] [varchar](2) NOT NULL,
	[StateName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_DimState] PRIMARY KEY CLUSTERED 
(
	[StateAbbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[DimStudent]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[DimStudent](
	[StudentID] [bigint] NOT NULL,
	[StudentFirstName] [varchar](30) NOT NULL,
	[StudentLastName] [varchar](30) NOT NULL,
	[StudentDOB] [datetime] NOT NULL,
	[StudentGender] [char](1) NOT NULL,
	[StudentAddress] [varchar](50) NOT NULL,
	[StudentCity] [varchar](50) NOT NULL,
	[StudentPostalCode] [varchar](10) NOT NULL,
	[StudentPhoneNumber] [varchar](10) NOT NULL,
	[StateAbbreviation] [varchar](2) NOT NULL,
 CONSTRAINT [PK_DimStudent] PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[FactEnrollment]    Script Date: 2019-10-06 11:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[FactEnrollment](
	[SectionID] [bigint] NOT NULL,
	[StudentID] [bigint] NOT NULL,
	[EnrollmentGrade] [varchar](2) NULL,
 CONSTRAINT [PK_FactEnrollment] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC,
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[FactSection]    Script Date: 2019-10-06 11:09:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[FactSection](
	[SectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[SectionNumber] [varchar](3) NOT NULL,
	[SectionTerm] [varchar](10) NOT NULL,
	[SectionDay] [varchar](8) NOT NULL,
	[SectionTime] [datetime2](7) NOT NULL,
	[SectionMaxEnrollment] [smallint] NOT NULL,
	[SectionCurrentEnrollment] [smallint] NULL,
	[InstructorID] [bigint] NOT NULL,
	[CourseID] [bigint] NOT NULL,
 CONSTRAINT [PK_FactSection] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [Dimension].[Course] ON 

INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (1, 1, N'MIS 240', N'Information Systems in Business', 3, N'Management Information Systems', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (2, 2, N'MIS 310', N'Systems Analysis and Design', 3, N'Management Information Systems', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (3, 3, N'MIS 344', N'Database Management Systems', 3, N'Management Information Systems', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (4, 4, N'MIS 345', N'Introduction to Networks', 3, N'Management Information Systems', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (5, 5, N'ACCT 201', N'Principles of Accounting', 3, N'Accounting', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (6, 6, N'ACCT 312', N'Managerial Accounting', 3, N'Accounting', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (7, 7, N'PHYS 211', N'General Physics', 4, N'Physics', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (8, 8, N'CS 245', N'Fundamentals of Object-Oriented Programming', 4, N'Computer Science', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (9, 9, N'CHEM 205', N'Applied Physical Chemistry', 3, N'Chemistry', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (10, 10, N'GEOL 212', N'Mineralogy and Petrology', 5, N'Geology', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (11, 11, N'CHIN 110', N'Intensive Beginning Chinese (Mandarin)', 5, N'Foreign Languages', 1)
INSERT [Dimension].[Course] ([CourseKey], [IWCourseKey], [CourseName], [CourseTitle], [CourseCredits], [DepartmentName], [AuditKey]) VALUES (12, 12, N'PHI 100', N'Deconstructing the Zombie Apocolyse', 3, N'Management Information Systems', 1)
SET IDENTITY_INSERT [Dimension].[Course] OFF
SET IDENTITY_INSERT [Dimension].[Instructor] ON 

INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (1, 1, N'Lauren', N'Morrison', N'J', N'Management Information Systems', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (2, 2, N'Adam', N'Dutton', N'K', N'Accounting', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (3, 3, N'Eagan', N'Ruppelt', N'T', N'Physics', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (4, 4, N'Charles', N'Murphy', N'H', N'Computer Science', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (5, 5, N'Richard', N'Harrison', N'P', N'Chemistry', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (6, 6, N'Judith', N'Bakke', N'D', N'Geology', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (7, 7, N'Diane', N'Adler', N'O', N'Foreign Languages', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (8, 8, N'Ted', N'Buck', NULL, N'Management Information Systems', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (9, 9, N'Roberta', N'Sanchez', N'V', N'Management Information Systems', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (10, 10, N'Lillian', N'Hogstad', N'S', N'Management Information Systems', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (11, 11, N'Brian', N'Luedke', N'L', N'Accounting', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (12, 12, N'Anthony', N'Downs', N'K', N'Accounting', CAST(N'2019-05-06' AS Date), NULL, 1)
INSERT [Dimension].[Instructor] ([InstructorKey], [IWInstructorKey], [InstructorFirstName], [InstructorLastName], [InstructorMI], [DepartmentName], [ValidFrom], [ValidTo], [AuditKey]) VALUES (13, 13, N'Nancy', N'Gardner', NULL, N'Accounting', CAST(N'2019-05-06' AS Date), NULL, 1)
SET IDENTITY_INSERT [Dimension].[Instructor] OFF
SET IDENTITY_INSERT [Dimension].[Lineage] ON 

INSERT [Dimension].[Lineage] ([AuditKey], [ParentAuditKey], [TableName], [PkgName], [PkgGUID], [PkgVersionGUID], [PkgVersionMajor], [PkgVersionMinor], [ExecStartDT], [ExecStopDT], [ExecutionInstanceGUID], [ExtractRowCnt], [InsertRowCnt], [UpdateRowCnt], [ErrorRowCnt], [TableInitialRowCnt], [TableFinalRowCnt], [TableMaxDateTime], [SuccessfulProcessingInd]) VALUES (1, 1, N'Initial Lab Load', N'NA', NULL, NULL, NULL, NULL, CAST(N'2019-09-29T11:55:00.000' AS DateTime), CAST(N'2019-09-29T11:56:00.000' AS DateTime), NULL, 0, 0, 0, NULL, 0, NULL, NULL, N'Y')
SET IDENTITY_INSERT [Dimension].[Lineage] OFF
SET IDENTITY_INSERT [Dimension].[Student] ON 

INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (1, 1, N'Clifford', N'Wall', CAST(N'1988-05-29T00:00:00.000' AS DateTime), N'M', N'3403 Level St', N'Ironwood', N'49938', N'MICHIGAN', N'715', CAST(N'2019-09-02' AS Date), NULL, 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (2, 2, N'Dawna', N'Voss', CAST(N'1981-11-01T00:00:00.000' AS DateTime), N'F', N'524 Lakeview Dr Apt 12', N'Ashland', N'54806', N'WISCONSIN', N'715', CAST(N'2019-09-11' AS Date), CAST(N'2019-09-14' AS Date), 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (3, 3, N'Patricia', N'Owen', CAST(N'1987-01-23T00:00:00.000' AS DateTime), N'F', N'S13254 County Rd 71', N'Ironwood', N'49938', N'MICHIGAN', N'715', CAST(N'2019-09-02' AS Date), NULL, 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (4, 4, N'Raymond', N'Miller', CAST(N'1988-08-09T00:00:00.000' AS DateTime), N'M', N'65 Renwood Lane', N'Ashland', N'54230', N'MICHIGAN', N'715', CAST(N'2019-09-11' AS Date), CAST(N'2019-09-14' AS Date), 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (5, 5, N'Ann', N'Bochman', CAST(N'1988-04-12T00:00:00.000' AS DateTime), N'F', N'112 Rainetta Blvd', N'Ashland', N'54806', N'WISCONSIN', N'715', CAST(N'2019-09-02' AS Date), NULL, 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (6, 6, N'Brenda', N'Johansen', CAST(N'1989-03-27T00:00:00.000' AS DateTime), N'F', N'520 Congress Rd', N'Ironwood', N'49938', N'MICHIGAN', N'715', CAST(N'2019-09-02' AS Date), CAST(N'2019-09-14' AS Date), 1)
INSERT [Dimension].[Student] ([StudentKey], [IWStudentKey], [StudentFirstName], [StudentLastName], [StudentDOB], [studentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StateName], [StudentAreaCode], [ValidFrom], [ValidTo], [AuditKey]) VALUES (7, 7, N'David', N'Ashcraft', CAST(N'1989-10-15T00:00:00.000' AS DateTime), N'M', N'331 1st Ave Apt 11', N'Ashland', N'54806', N'WISCONSIN', N'715', CAST(N'2019-09-02' AS Date), NULL, 1)
SET IDENTITY_INSERT [Dimension].[Student] OFF
SET IDENTITY_INSERT [Dimension].[TermDates] ON 

INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (1, N'SPR08', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (2, N'SPR08', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (3, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (4, N'SUMM08', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (5, N'SUMM08', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (6, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (7, N'FALL08', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (8, N'FALL08', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (9, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (10, N'SPR08', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (11, N'SPR08', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (12, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (13, N'SUMM08', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (14, N'SUMM08', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (15, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (16, N'FALL08', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (17, N'FALL08', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (18, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (19, N'SPR08', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (20, N'SPR08', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (21, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (22, N'SUMM08', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (23, N'SUMM08', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (24, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (25, N'FALL08', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (26, N'FALL08', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (27, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (28, N'SPR08', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (29, N'SPR08', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (30, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (31, N'SUMM08', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (32, N'SUMM08', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (33, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (34, N'FALL08', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (35, N'FALL08', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (36, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (37, N'SPR08', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (38, N'SPR08', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (39, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (40, N'SUMM08', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (41, N'SUMM08', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (42, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (43, N'FALL08', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (44, N'FALL08', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (45, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (46, N'SPR08', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (47, N'SPR08', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (48, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (49, N'SUMM08', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (50, N'SUMM08', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (51, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (52, N'FALL08', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (53, N'FALL08', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (54, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (55, N'SPR08', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (56, N'SPR08', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (57, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (58, N'SUMM08', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (59, N'SUMM08', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (60, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (61, N'FALL08', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (62, N'FALL08', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (63, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (64, N'SPR08', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (65, N'SPR08', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (66, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (67, N'SUMM08', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (68, N'SUMM08', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (69, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (70, N'FALL08', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (71, N'FALL08', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (72, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (73, N'SPR08', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (74, N'SPR08', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (75, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (76, N'SUMM08', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (77, N'SUMM08', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (78, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (79, N'FALL08', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (80, N'FALL08', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (81, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (82, N'SPR08', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (83, N'SPR08', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (84, N'SPR08', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (85, N'SUMM08', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (86, N'SUMM08', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (87, N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (88, N'FALL08', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (89, N'FALL08', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (90, N'FALL08', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (91, N'SPR09', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (92, N'SPR09', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (93, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (94, N'SUMM09', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (95, N'SUMM09', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (96, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (97, N'FALL09', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (98, N'FALL09', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (99, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
GO
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (100, N'SPR09', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (101, N'SPR09', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (102, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (103, N'SUMM09', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (104, N'SUMM09', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (105, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (106, N'FALL09', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (107, N'FALL09', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (108, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (109, N'SPR09', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (110, N'SPR09', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (111, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (112, N'SUMM09', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (113, N'SUMM09', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (114, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (115, N'FALL09', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (116, N'FALL09', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (117, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (118, N'SPR09', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (119, N'SPR09', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (120, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (121, N'SUMM09', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (122, N'SUMM09', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (123, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (124, N'FALL09', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (125, N'FALL09', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (126, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (127, N'SPR09', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (128, N'SPR09', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (129, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (130, N'SUMM09', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (131, N'SUMM09', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (132, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (133, N'FALL09', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (134, N'FALL09', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (135, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (136, N'SPR09', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (137, N'SPR09', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (138, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (139, N'SUMM09', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (140, N'SUMM09', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (141, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (142, N'FALL09', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (143, N'FALL09', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (144, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (145, N'SPR09', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (146, N'SPR09', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (147, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (148, N'SUMM09', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (149, N'SUMM09', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (150, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (151, N'FALL09', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (152, N'FALL09', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (153, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (154, N'SPR09', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (155, N'SPR09', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (156, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (157, N'SUMM09', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (158, N'SUMM09', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (159, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (160, N'FALL09', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (161, N'FALL09', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (162, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (163, N'SPR09', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (164, N'SPR09', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (165, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (166, N'SUMM09', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (167, N'SUMM09', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (168, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (169, N'FALL09', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (170, N'FALL09', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (171, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (172, N'SPR09', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (173, N'SPR09', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (174, N'SPR09', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (175, N'SUMM09', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (176, N'SUMM09', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (177, N'SUMM09', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (178, N'FALL09', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (179, N'FALL09', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (180, N'FALL09', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (181, N'SPR10', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (182, N'SPR10', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (183, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (184, N'SUMM10', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (185, N'SUMM10', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (186, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (187, N'FALL10', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (188, N'FALL10', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (189, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (190, N'SPR10', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (191, N'SPR10', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (192, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (193, N'SUMM10', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (194, N'SUMM10', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (195, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (196, N'FALL10', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (197, N'FALL10', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (198, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (199, N'SPR10', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
GO
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (200, N'SPR10', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (201, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (202, N'SUMM10', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (203, N'SUMM10', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (204, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (205, N'FALL10', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (206, N'FALL10', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (207, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (208, N'SPR10', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (209, N'SPR10', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (210, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (211, N'SUMM10', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (212, N'SUMM10', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (213, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (214, N'FALL10', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (215, N'FALL10', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (216, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (217, N'SPR10', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (218, N'SPR10', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (219, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (220, N'SUMM10', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (221, N'SUMM10', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (222, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (223, N'FALL10', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (224, N'FALL10', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (225, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (226, N'SPR10', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (227, N'SPR10', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (228, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (229, N'SUMM10', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (230, N'SUMM10', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (231, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (232, N'FALL10', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (233, N'FALL10', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (234, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (235, N'SPR10', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (236, N'SPR10', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (237, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (238, N'SUMM10', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (239, N'SUMM10', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (240, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (241, N'FALL10', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (242, N'FALL10', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (243, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (244, N'SPR10', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (245, N'SPR10', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (246, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (247, N'SUMM10', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (248, N'SUMM10', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (249, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (250, N'FALL10', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (251, N'FALL10', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (252, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (253, N'SPR10', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (254, N'SPR10', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (255, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (256, N'SUMM10', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (257, N'SUMM10', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (258, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (259, N'FALL10', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (260, N'FALL10', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (261, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (262, N'SPR10', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (263, N'SPR10', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (264, N'SPR10', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (265, N'SUMM10', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (266, N'SUMM10', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (267, N'SUMM10', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (268, N'FALL10', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (269, N'FALL10', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (270, N'FALL10', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (271, N'SPR11', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (272, N'SPR11', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (273, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (274, N'SUMM11', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (275, N'SUMM11', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (276, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (277, N'FALL11', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (278, N'FALL11', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (279, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (280, N'SPR11', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (281, N'SPR11', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (282, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (283, N'SUMM11', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (284, N'SUMM11', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (285, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (286, N'FALL11', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (287, N'FALL11', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (288, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (289, N'SPR11', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (290, N'SPR11', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (291, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (292, N'SUMM11', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (293, N'SUMM11', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (294, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (295, N'FALL11', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (296, N'FALL11', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (297, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (298, N'SPR11', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (299, N'SPR11', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
GO
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (300, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (301, N'SUMM11', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (302, N'SUMM11', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (303, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (304, N'FALL11', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (305, N'FALL11', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (306, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (307, N'SPR11', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (308, N'SPR11', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (309, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (310, N'SUMM11', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (311, N'SUMM11', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (312, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (313, N'FALL11', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (314, N'FALL11', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (315, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (316, N'SPR11', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (317, N'SPR11', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (318, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (319, N'SUMM11', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (320, N'SUMM11', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (321, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (322, N'FALL11', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (323, N'FALL11', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (324, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (325, N'SPR11', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (326, N'SPR11', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (327, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (328, N'SUMM11', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (329, N'SUMM11', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (330, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (331, N'FALL11', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (332, N'FALL11', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (333, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (334, N'SPR11', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (335, N'SPR11', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (336, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (337, N'SUMM11', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (338, N'SUMM11', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (339, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (340, N'FALL11', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (341, N'FALL11', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (342, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (343, N'SPR11', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (344, N'SPR11', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (345, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (346, N'SUMM11', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (347, N'SUMM11', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (348, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (349, N'FALL11', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (350, N'FALL11', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (351, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (352, N'SPR11', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (353, N'SPR11', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (354, N'SPR11', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (355, N'SUMM11', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (356, N'SUMM11', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (357, N'SUMM11', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (358, N'FALL11', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (359, N'FALL11', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (360, N'FALL11', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (361, N'SPR12', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (362, N'SPR12', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (363, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (364, N'SUMM12', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (365, N'SUMM12', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (366, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (367, N'FALL12', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (368, N'FALL12', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (369, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (370, N'SPR12', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (371, N'SPR12', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (372, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (373, N'SUMM12', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (374, N'SUMM12', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (375, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (376, N'FALL12', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (377, N'FALL12', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (378, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (379, N'SPR12', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (380, N'SPR12', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (381, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (382, N'SUMM12', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (383, N'SUMM12', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (384, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (385, N'FALL12', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (386, N'FALL12', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (387, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (388, N'SPR12', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (389, N'SPR12', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (390, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (391, N'SUMM12', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (392, N'SUMM12', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (393, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (394, N'FALL12', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (395, N'FALL12', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (396, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (397, N'SPR12', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (398, N'SPR12', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (399, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
GO
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (400, N'SUMM12', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (401, N'SUMM12', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (402, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (403, N'FALL12', N'MWF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (404, N'FALL12', N'TTH', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (405, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T12:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (406, N'SPR12', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (407, N'SPR12', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (408, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (409, N'SUMM12', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (410, N'SUMM12', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (411, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (412, N'FALL12', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (413, N'FALL12', N'TTH', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (414, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (415, N'SPR12', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (416, N'SPR12', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (417, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (418, N'SUMM12', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (419, N'SUMM12', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (420, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (421, N'FALL12', N'MWF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (422, N'FALL12', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (423, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (424, N'SPR12', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (425, N'SPR12', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (426, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (427, N'SUMM12', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (428, N'SUMM12', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (429, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (430, N'FALL12', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (431, N'FALL12', N'TTH', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (432, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (433, N'SPR12', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (434, N'SPR12', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (435, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (436, N'SUMM12', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (437, N'SUMM12', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (438, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (439, N'FALL12', N'MWF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (440, N'FALL12', N'TTH', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (441, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T16:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (442, N'SPR12', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (443, N'SPR12', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (444, N'SPR12', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (445, N'SUMM12', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (446, N'SUMM12', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (447, N'SUMM12', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (448, N'FALL12', N'MWF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (449, N'FALL12', N'TTH', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
INSERT [Dimension].[TermDates] ([dateKey], [termLabel], [dayLabel], [classTime]) VALUES (450, N'FALL12', N'MTWTHF', CAST(N'1900-01-01T17:00:00.0000000' AS DateTime2))
SET IDENTITY_INSERT [Dimension].[TermDates] OFF
SET IDENTITY_INSERT [Fact].[EnrollmentOutcomes] ON 

INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (11, 5, 1, N'001', 24, 3, N'B-', 80, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (12, 1, 1, N'001', 7, 3, N'A-', 90, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (16, 1, 8, N'002', 62, 4, N'F', 40, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (17, 5, 11, N'001', 16, 4, N'F', 40, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (21, 5, 11, N'001', 16, 5, N'D-', 60, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (23, 10, 6, N'001', 26, 5, N'A-', 90, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (24, 11, 7, N'001', 35, 5, N'B', 80, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (1, 1, 1, N'001', 6, 1, N'C', 75, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (2, 7, 3, N'001', 17, 1, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (3, 8, 4, N'001', 52, 1, N'C', 75, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (4, 10, 6, N'001', 26, 1, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (5, 11, 7, N'001', 35, 1, N'A', 95, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (6, 1, 1, N'001', 6, 2, N'A', 95, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (7, 5, 11, N'001', 16, 2, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (8, 7, 3, N'001', 17, 2, N'B+', 88, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (9, 9, 5, N'001', 25, 2, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (10, 10, 6, N'001', 26, 2, N'A', 95, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (13, 5, 11, N'001', 16, 3, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (15, 10, 6, N'001', 26, 3, N'C+', 78, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (18, 9, 5, N'001', 25, 4, N'B', 85, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (19, 10, 6, N'001', 26, 4, N'C', 75, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (20, 1, 1, N'001', 7, 5, N'C+', 78, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (14, 7, 3, N'001', 17, 3, N'D+', 68, 1)
INSERT [Fact].[EnrollmentOutcomes] ([EnrollOutcomeKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [StudentKey], [EnrollLetterGrade], [EnrollNumberGrade], [AuditKey]) VALUES (22, 7, 3, N'001', 17, 5, N'B', 85, 1)
SET IDENTITY_INSERT [Fact].[EnrollmentOutcomes] OFF
SET IDENTITY_INSERT [Fact].[EnrollmentSeats] ON 

INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (1, 1, 1, N'001', 6, 25, 30, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (2, 7, 3, N'001', 17, 35, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (3, 8, 4, N'001', 52, 51, 60, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (4, 10, 6, N'001', 26, 26, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (5, 11, 7, N'001', 35, 23, 50, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (6, 1, 1, N'001', 6, 25, 30, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (7, 5, 11, N'001', 16, 36, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (8, 7, 3, N'001', 17, 35, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (9, 9, 5, N'001', 25, 34, 60, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (10, 10, 6, N'001', 26, 26, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (11, 2, 9, N'001', 110, 5, 65, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (12, 3, 10, N'001', 101, 3, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (13, 6, 12, N'001', 92, 0, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (14, 11, 7, N'001', 146, 31, 50, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (15, 5, 1, N'001', 24, 19, 30, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (16, 1, 1, N'001', 7, 65, 65, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (17, 5, 11, N'001', 16, 36, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (18, 7, 3, N'001', 17, 35, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (19, 10, 6, N'001', 26, 26, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (20, 1, 8, N'002', 62, 71, 80, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (21, 5, 11, N'001', 16, 36, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (22, 9, 5, N'001', 25, 34, 60, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (23, 10, 6, N'001', 26, 26, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (24, 1, 1, N'001', 91, 0, 65, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (25, 7, 3, N'001', 110, 23, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (26, 8, 4, N'001', 100, 38, 60, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (27, 11, 7, N'001', 146, 31, 50, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (28, 1, 1, N'001', 7, 65, 65, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (29, 5, 11, N'001', 16, 36, 40, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (30, 7, 3, N'001', 17, 35, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (31, 10, 6, N'001', 26, 26, 35, 1)
INSERT [Fact].[EnrollmentSeats] ([EnrollSeatsKey], [CourseKey], [InstructorKey], [SectionNumber], [DateKey], [SeatsActual], [SeatsCapacity], [AuditKey]) VALUES (32, 11, 7, N'001', 35, 23, 50, 1)
SET IDENTITY_INSERT [Fact].[EnrollmentSeats] OFF
SET IDENTITY_INSERT [Staging].[DimCourse] ON 

INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (1, N'MIS 240', N'Information Systems in Business', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (2, N'MIS 310', N'Systems Analysis and Design', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (3, N'MIS 344', N'Database Management Systems', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (4, N'MIS 345', N'Introduction to Networks', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (5, N'ACCT 201', N'Principles of Accounting', 3, 2)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (6, N'ACCT 312', N'Managerial Accounting', 3, 2)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (7, N'PHYS 211', N'General Physics', 4, 3)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (8, N'CS 245', N'Fundamentals of Object-Oriented Programming', 4, 4)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (9, N'CHEM 205', N'Applied Physical Chemistry', 3, 5)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (10, N'GEOL 212', N'Mineralogy and Petrology', 5, 6)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (11, N'CHIN 110', N'Intensive Beginning Chinese (Mandarin)', 5, 7)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (12, N'PHI 100', N'Deconstructing the Zombie Apocolyse', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (13, N'PHI 440', N'The Zen of John Snow', 3, 1)
INSERT [Staging].[DimCourse] ([CourseID], [CourseName], [CourseTitle], [CourseCredits], [DepartmentID]) VALUES (18, N'GEOL 330', N'Sedimentology And Petroleum Geology', 3, 6)
SET IDENTITY_INSERT [Staging].[DimCourse] OFF
SET IDENTITY_INSERT [Staging].[DimDepartment] ON 

INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (1, N'Management Information Systems')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (2, N'Accounting')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (3, N'Physics')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (4, N'Computer Science')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (5, N'Chemistry')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (6, N'Geology')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (7, N'Foreign Languages')
INSERT [Staging].[DimDepartment] ([DepartmentID], [DepartmentName]) VALUES (8, N'Philosophy')
SET IDENTITY_INSERT [Staging].[DimDepartment] OFF
SET IDENTITY_INSERT [Staging].[DimensionLaptop] ON 

INSERT [Staging].[DimensionLaptop] ([LaptopID], [StudentID]) VALUES (1, 1)
INSERT [Staging].[DimensionLaptop] ([LaptopID], [StudentID]) VALUES (4, 3)
SET IDENTITY_INSERT [Staging].[DimensionLaptop] OFF
SET IDENTITY_INSERT [Staging].[DimInstructor] ON 

INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (1, N'Lauren Morrison')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (2, N'Adam Dutton')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (3, N'Eagan Ruppelt')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (4, N'Charles Murphy')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (5, N'Richard Harrison')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (6, N'Judith Bakke')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (7, N'Diane Adler')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (8, N'Ted Buck')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (9, N'Roberta Sanchez')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (10, N'Lillian Hogstad')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (11, N'Brian Luedke')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (12, N'Anthony Downs')
INSERT [Staging].[DimInstructor] ([InstructorID], [InstructorName]) VALUES (13, N'Nancy Gardner')
SET IDENTITY_INSERT [Staging].[DimInstructor] OFF
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'AK', N'ALASKA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'AL', N'ALABAMA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'AR', N'ARKANSAS')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'AZ', N'ARIZONA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'CA', N'CALIFORNIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'CO', N'COLORADO')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'CT', N'CONNECTICUT')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'DC', N'DISTRICT OF COLUMBIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'DE', N'DELAWARE')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'FL', N'FLORIDA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'GA', N'GEORGIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'HI', N'HAWAII')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'IA', N'IOWA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'ID', N'IDAHO')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'IL', N'ILLINOIS')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'IN', N'INDIANA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'KS', N'KANSAS')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'KY', N'KENTUCKY')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'LA', N'LOUISIANA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MA', N'MASSACHUSETTS')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MD', N'MARYLAND')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'ME', N'MAINE')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MI', N'MICHIGAN')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MN', N'MINNESOTA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MO', N'MISSOURI')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MS', N'MISSISSIPPI')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'MT', N'MONTANA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NC', N'NORTH CAROLINA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'ND', N'NORTH DAKOTA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NE', N'NEBRASKA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NH', N'NEW HAMPSHIRE')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NJ', N'NEW JERSEY')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NM', N'NEW MEXICO')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NV', N'NEVADA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'NY', N'NEW YORK')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'OH', N'OHIO')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'OK', N'OKLAHOMA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'OR', N'OREGON')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'PA', N'PENNSYLVANIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'RI', N'RHODE ISLAND')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'SC', N'SOUTH CAROLINA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'SD', N'SOUTH DAKOTA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'TN', N'TENNESSEE')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'TX', N'TEXAS')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'UT', N'UTAH')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'VA', N'VIRGINIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'VT', N'VERMONT')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'WA', N'WASHINGTON')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'WI', N'WISCONSIN')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'WV', N'WEST VIRGINIA')
INSERT [Staging].[DimState] ([StateAbbreviation], [StateName]) VALUES (N'WY', N'WYOMING')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (1, N'Clifford', N'Wall', CAST(N'1988-05-29T00:00:00.000' AS DateTime), N'M', N'3403 Level St', N'Ironwood', N'49938', N'7158362331', N'MI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (2, N'Dawna', N'Voss-MacBeth', CAST(N'1981-11-01T00:00:00.000' AS DateTime), N'F', N'524 Lakeview Dr Apt 12', N'Ashland', N'54806', N'7158382413', N'WI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (3, N'Patricia', N'Owen', CAST(N'1987-01-23T00:00:00.000' AS DateTime), N'F', N'S13254 County Rd 71', N'Ironwood', N'49938', N'7158360982', N'MI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (4, N'Raymond', N'Miller', CAST(N'1988-08-09T00:00:00.000' AS DateTime), N'M', N'123 Sesame St', N'Somewhere Ville', N'12345', N'7158382319', N'MI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (5, N'Ann', N'Bochman', CAST(N'1988-04-12T00:00:00.000' AS DateTime), N'F', N'112 Rainetta Blvd', N'Ashland', N'54806', N'7158382231', N'WI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (6, N'Brenda ', N'Johansen', CAST(N'1989-03-27T00:00:00.000' AS DateTime), N'F', N'520 Congress Rd', N'Ironwood', N'49938', N'7158368891', N'MI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (7, N'David', N'Ashcraft', CAST(N'1989-10-15T00:00:00.000' AS DateTime), N'M', N'331 1st Ave Apt 11', N'Ashland', N'54806', N'7158384437', N'WI')
INSERT [Staging].[DimStudent] ([StudentID], [StudentFirstName], [StudentLastName], [StudentDOB], [StudentGender], [StudentAddress], [StudentCity], [StudentPostalCode], [StudentPhoneNumber], [StateAbbreviation]) VALUES (8, N'New', N'Person', CAST(N'1990-01-01T00:00:00.000' AS DateTime), N'F', N'1 Main St', N'Ironwood', N'49558', N'7151234567', N'MI')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (15, 4, N'B+')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (17, 2, N'A')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (18, 2, N'A-')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (21, 2, N'C')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (22, 4, N'C+')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (23, 4, N'B-')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (26, 2, N'C-')
INSERT [Staging].[FactEnrollment] ([SectionID], [StudentID], [EnrollmentGrade]) VALUES (26, 4, N'A+')
SET IDENTITY_INSERT [Staging].[FactSection] ON 

INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (1, N'001', N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 30, 25, 1, 1)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (2, N'001', N'SUMM08', N'MTWTHF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2), 30, 19, 1, 5)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (3, N'001', N'FALL08', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 65, 65, 1, 1)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (4, N'002', N'FALL08', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2), 80, 71, 8, 1)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (5, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 65, 61, 9, 2)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (6, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 40, 39, 10, 3)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (7, N'001', N'FALL08', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 40, 40, 8, 4)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (8, N'001', N'FALL08', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 40, 36, 11, 5)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (9, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2), 40, 38, 12, 6)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (10, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 35, 35, 3, 7)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (11, N'001', N'FALL08', N'MWF', CAST(N'1900-01-01T13:00:00.0000000' AS DateTime2), 60, 51, 4, 8)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (12, N'001', N'FALL08', N'MWF', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2), 60, 34, 5, 9)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (13, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2), 35, 26, 6, 10)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (14, N'001', N'FALL08', N'TTH', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2), 50, 23, 7, 11)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (15, N'001', N'SPR09', N'MWF', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 65, 0, 1, 1)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (16, N'002', N'SPR09', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2), 80, 0, 8, 1)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (17, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2), 65, 5, 9, 2)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (18, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 40, 3, 10, 3)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (19, N'001', N'SPR09', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2), 40, 21, 8, 4)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (20, N'001', N'SPR09', N'MWF', CAST(N'1900-01-01T15:00:00.0000000' AS DateTime2), 40, 17, 11, 5)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (21, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T08:00:00.0000000' AS DateTime2), 40, 0, 12, 6)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (22, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T10:00:00.0000000' AS DateTime2), 35, 23, 3, 7)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (23, N'001', N'SPR09', N'MWF', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 60, 38, 4, 8)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (24, N'001', N'SPR09', N'MWF', CAST(N'1900-01-01T11:00:00.0000000' AS DateTime2), 60, 12, 5, 9)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (25, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T09:00:00.0000000' AS DateTime2), 35, 29, 6, 10)
INSERT [Staging].[FactSection] ([SectionID], [SectionNumber], [SectionTerm], [SectionDay], [SectionTime], [SectionMaxEnrollment], [SectionCurrentEnrollment], [InstructorID], [CourseID]) VALUES (26, N'001', N'SPR09', N'TTH', CAST(N'1900-01-01T14:00:00.0000000' AS DateTime2), 50, 31, 7, 11)
SET IDENTITY_INSERT [Staging].[FactSection] OFF
/****** Object:  Index [PK_EnrollmentOutcomes]    Script Date: 2019-10-06 11:09:03 AM ******/
ALTER TABLE [Fact].[EnrollmentOutcomes] ADD  CONSTRAINT [PK_EnrollmentOutcomes] PRIMARY KEY NONCLUSTERED 
(
	[EnrollOutcomeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_EnrollmentSeats]    Script Date: 2019-10-06 11:09:03 AM ******/
ALTER TABLE [Fact].[EnrollmentSeats] ADD  CONSTRAINT [PK_EnrollmentSeats] PRIMARY KEY NONCLUSTERED 
(
	[EnrollSeatsKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Dimension].[Instructor] ADD  CONSTRAINT [DF_Instructor_ValidFrom]  DEFAULT (getdate()) FOR [ValidFrom]
GO
ALTER TABLE [Fact].[EnrollmentOutcomes]  WITH CHECK ADD  CONSTRAINT [FK_EnrollmentOutcomes_Course] FOREIGN KEY([CourseKey])
REFERENCES [Dimension].[Course] ([CourseKey])
GO
ALTER TABLE [Fact].[EnrollmentOutcomes] CHECK CONSTRAINT [FK_EnrollmentOutcomes_Course]
GO
ALTER TABLE [Fact].[EnrollmentOutcomes]  WITH CHECK ADD  CONSTRAINT [FK_EnrollmentOutcomes_Instructor] FOREIGN KEY([InstructorKey])
REFERENCES [Dimension].[Instructor] ([InstructorKey])
GO
ALTER TABLE [Fact].[EnrollmentOutcomes] CHECK CONSTRAINT [FK_EnrollmentOutcomes_Instructor]
GO
ALTER TABLE [Fact].[EnrollmentOutcomes]  WITH CHECK ADD  CONSTRAINT [FK_EnrollmentOutcomes_Student] FOREIGN KEY([StudentKey])
REFERENCES [Dimension].[Student] ([StudentKey])
GO
ALTER TABLE [Fact].[EnrollmentOutcomes] CHECK CONSTRAINT [FK_EnrollmentOutcomes_Student]
GO
ALTER TABLE [Fact].[EnrollmentOutcomes]  WITH CHECK ADD  CONSTRAINT [FK_EnrollmentOutcomes_TermDates] FOREIGN KEY([DateKey])
REFERENCES [Dimension].[TermDates] ([dateKey])
GO
ALTER TABLE [Fact].[EnrollmentOutcomes] CHECK CONSTRAINT [FK_EnrollmentOutcomes_TermDates]
GO

