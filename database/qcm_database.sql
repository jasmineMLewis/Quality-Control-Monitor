USE [master]
GO
/****** Object:  Database [QualityControlMonitor]    Script Date: 6/15/2019 1:24:54 AM ******/
CREATE DATABASE [QualityControlMonitor]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QualityControlMonitor', FILENAME = N'C:\Users\dholmes\QualityControlMonitor.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QualityControlMonitor_log', FILENAME = N'C:\Users\dholmes\QualityControlMonitor_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [QualityControlMonitor] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QualityControlMonitor].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QualityControlMonitor] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET ARITHABORT OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QualityControlMonitor] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QualityControlMonitor] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QualityControlMonitor] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QualityControlMonitor] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QualityControlMonitor] SET  MULTI_USER 
GO
ALTER DATABASE [QualityControlMonitor] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QualityControlMonitor] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QualityControlMonitor] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QualityControlMonitor] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QualityControlMonitor] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QualityControlMonitor] SET QUERY_STORE = OFF
GO
USE [QualityControlMonitor]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [QualityControlMonitor]
GO
/****** Object:  Table [dbo].[DocumentTypes]    Script Date: 6/15/2019 1:24:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentTypes](
	[DocumentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DocumentType] [varchar](255) NULL,
 CONSTRAINT [PK_DocumentTypes] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileErrors]    Script Date: 6/15/2019 1:25:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileErrors](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[Details] [varchar](max) NULL,
	[Status] [varchar](max) NULL,
	[CompletionDate] [date] NULL,
	[IsCompletionApproved] [bit] NULL,
	[Notes] [varchar](max) NULL,
	[fk_NoticeTypeID] [int] NULL,
	[fk_ErrorStaffID] [int] NULL,
	[fk_ProcessTypeID] [int] NULL,
	[fk_FileID] [int] NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_AuditorSubmittedID] [int] NULL,
 CONSTRAINT [PK_FileErrors] PRIMARY KEY CLUSTERED 
(
	[ErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileErrorsDocumentTypes]    Script Date: 6/15/2019 1:25:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileErrorsDocumentTypes](
	[FileErrorDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ErrorID] [int] NULL,
	[fk_FIleID] [int] NULL,
	[fk_DocumentTypeID] [int] NULL,
 CONSTRAINT [PK_FileErrorsDocumentTypes] PRIMARY KEY CLUSTERED 
(
	[FileErrorDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileReviewedDocuments]    Script Date: 6/15/2019 1:25:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileReviewedDocuments](
	[DocumentTypeReviewedID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_DocumentID] [int] NULL,
	[fk_FileID] [int] NULL,
	[IsReviewed] [int] NULL,
 CONSTRAINT [PK_FileReviewedDocuments] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeReviewedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileReviewedProcesses]    Script Date: 6/15/2019 1:25:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileReviewedProcesses](
	[ProcessTypeReviewedID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_ProcessID] [int] NULL,
	[fk_FileID] [int] NULL,
	[IsReviewed] [bit] NULL,
 CONSTRAINT [PK_FileReviewedProcesses] PRIMARY KEY CLUSTERED 
(
	[ProcessTypeReviewedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 6/15/2019 1:25:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[ClientFirstName] [varchar](100) NULL,
	[ClientLastName] [varchar](100) NULL,
	[EliteID] [varchar](15) NULL,
	[fk_CaseManagerID] [int] NULL,
	[fk_ReviewTypeID] [int] NULL,
	[ReviewDate] [datetime] NULL,
	[EffectiveDate] [datetime] NULL,
	[Comment] [varchar](max) NULL,
	[fk_AudtitorID] [int] NULL,
	[IsReviewComplete] [bit] NULL,
	[IsFileDisable] [bit] NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 6/15/2019 1:25:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[Group] [nvarchar](255) NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LotteryNumberErrors]    Script Date: 6/15/2019 1:25:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LotteryNumberErrors](
	[LotteryNumberID] [int] IDENTITY(1,1) NOT NULL,
	[doClientHaveNumber] [bit] NULL,
	[Number] [varchar](50) NULL,
	[Comments] [varchar](max) NULL,
	[fk_FileID] [int] NULL,
	[fk_AuditorID] [int] NULL,
 CONSTRAINT [PK_LotteryNumberErrors] PRIMARY KEY CLUSTERED 
(
	[LotteryNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoticeTypeDocuments]    Script Date: 6/15/2019 1:25:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoticeTypeDocuments](
	[NoticeTypeDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_DocumentTypeID] [int] NULL,
	[fk_NoticeTypeID] [int] NULL,
 CONSTRAINT [PK_NoticeTypeDocuments] PRIMARY KEY CLUSTERED 
(
	[NoticeTypeDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoticeTypeProcesses]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoticeTypeProcesses](
	[NoticeTypeProcessID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_ProcessTypeID] [int] NULL,
	[fk_NoticeTypeID] [int] NULL,
 CONSTRAINT [PK_NoticeTypeProcesses] PRIMARY KEY CLUSTERED 
(
	[NoticeTypeProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoticeTypes]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoticeTypes](
	[NoticeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Notice] [varchar](255) NULL,
 CONSTRAINT [PK_NoticeTypes] PRIMARY KEY CLUSTERED 
(
	[NoticeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcessTypes]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessTypes](
	[ProcessTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Process] [varchar](255) NULL,
 CONSTRAINT [PK_ProcessTypes] PRIMARY KEY CLUSTERED 
(
	[ProcessTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReviewTypes]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReviewTypes](
	[ReviewTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Review] [varchar](255) NULL,
 CONSTRAINT [PK_ReviewTypes] PRIMARY KEY CLUSTERED 
(
	[ReviewTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReviewTypesDocuments]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReviewTypesDocuments](
	[ReviewTypeDocumentID] [float] NULL,
	[fk_ReviewTypeID] [float] NULL,
	[fk_DocumentTypeID] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReviewTypesProcesses]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReviewTypesProcesses](
	[ReviewTypeProcessID] [int] IDENTITY(1,1) NOT NULL,
	[fk_ReviewTypeID] [int] NULL,
	[fk_ProcessTypeID] [int] NULL,
 CONSTRAINT [PK_ReviewTypeProcess] PRIMARY KEY CLUSTERED 
(
	[ReviewTypeProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 6/15/2019 1:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](50) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecialCaseErrors]    Script Date: 6/15/2019 1:25:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecialCaseErrors](
	[SpecialCaseID] [int] IDENTITY(1,1) NOT NULL,
	[isExists] [bit] NULL,
	[Comments] [varchar](max) NULL,
	[fk_ErrorTypeID] [int] NULL,
	[fk_FileID] [int] NULL,
	[fk_AuditorID] [int] NULL,
 CONSTRAINT [PK_SpecialCaseErrors] PRIMARY KEY CLUSTERED 
(
	[SpecialCaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 6/15/2019 1:25:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Password] [varchar](50) NULL,
	[fk_GroupID] [int] NULL,
	[fk_RoleID] [int] NULL,
	[IsActive] [bit] NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [QualityControlMonitor] SET  READ_WRITE 
GO
