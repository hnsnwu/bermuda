USE [master]
GO
/****** Object:  Database [bermuda-mvc]    Script Date: 2018/6/23 22:02:15 ******/
CREATE DATABASE [bermuda-mvc]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bermuda-mvc', FILENAME = N'E:\studiospace\Database\_msserver\bermuda-mvc\bermuda-mvc.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bermuda-mvc_log', FILENAME = N'E:\studiospace\Database\_msserver\bermuda-mvc\bermuda-mvc_log.ldf' , SIZE = 2304KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [bermuda-mvc] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bermuda-mvc].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bermuda-mvc] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bermuda-mvc] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bermuda-mvc] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bermuda-mvc] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bermuda-mvc] SET ARITHABORT OFF 
GO
ALTER DATABASE [bermuda-mvc] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bermuda-mvc] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [bermuda-mvc] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bermuda-mvc] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bermuda-mvc] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bermuda-mvc] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bermuda-mvc] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bermuda-mvc] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bermuda-mvc] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bermuda-mvc] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bermuda-mvc] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bermuda-mvc] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bermuda-mvc] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bermuda-mvc] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bermuda-mvc] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bermuda-mvc] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bermuda-mvc] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bermuda-mvc] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bermuda-mvc] SET RECOVERY FULL 
GO
ALTER DATABASE [bermuda-mvc] SET  MULTI_USER 
GO
ALTER DATABASE [bermuda-mvc] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bermuda-mvc] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bermuda-mvc] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bermuda-mvc] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'bermuda-mvc', N'ON'
GO
USE [bermuda-mvc]
GO
/****** Object:  StoredProcedure [dbo].[JoinTopicsProc]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[JoinTopicsProc] (
  @user_id bigint,
  @title varchar(100),
  @text text,
  
  @topic1_id bigint = 0,
  @topic2_id bigint = 0,
  @topic3_id bigint = 0
)
as 
  insert into BmdCurrent(UserId, Title, Text)
  values(@user_id, @title, @text)

  declare @current_id bigint
  set @current_id = IDENT_CURRENT('BmdCurrent')
  --select @current_id = Id
  --from BmdCurrent
  --where UserId = @user_id
  --  and Title = @title
  --  and Text = @text
  
  if @topic1_id != 0
    insert into BmdTopicJoin(TopicId, CurrentId)
    values(@topic1_id, @current_id)

  if @topic2_id != 0
    insert into BmdTopicJoin(TopicId, CurrentId)
    values(@topic2_id, @current_id)

  if @topic3_id != 0  
    insert into BmdTopicJoin(TopicId, CurrentId)
    values(@topic3_id, @current_id)

GO
/****** Object:  Table [dbo].[BmdConsignee]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdConsignee](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Consignee] [varchar](50) NULL,
	[Address] [varchar](200) NULL,
	[PhoneNum] [char](11) NULL,
 CONSTRAINT [PK_BmdConsignee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdCurrent]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdCurrent](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Title] [varchar](100) NULL,
	[Text] [text] NULL,
	[BriefText] [varchar](280) NULL,
	[CmntCount] [bigint] NULL CONSTRAINT [DF_current_cmnt_count]  DEFAULT ((0)),
	[StarCount] [bigint] NULL CONSTRAINT [DF_current_star_count]  DEFAULT ((0)),
	[PraiseCount] [bigint] NULL CONSTRAINT [DF_current_praise_count]  DEFAULT ((0)),
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdCurrent_CreatedAt]  DEFAULT (getdate()),
 CONSTRAINT [pk_current] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdCurrentCmnt]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdCurrentCmnt](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CurrentId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[Contents] [varchar](280) NULL,
	[CmntDate] [datetime] NULL,
	[PraiseCount] [bigint] NULL,
	[ReplyCount] [bigint] NULL,
 CONSTRAINT [PK_current_cmnt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdCurrentCmntPraise]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdCurrentCmntPraise](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CmntId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[PraiseDate] [datetime] NULL,
 CONSTRAINT [PK_BmdCurrentCmntPraise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdCurrentCmntReply]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdCurrentCmntReply](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CmntId] [bigint] NULL,
	[AimsId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[Contents] [varchar](280) NULL,
	[ReplyDate] [datetime] NULL,
	[PraiseCount] [bigint] NULL,
 CONSTRAINT [pk_current_reply] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdCurrentCmntReplyPraise]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdCurrentCmntReplyPraise](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ReplyId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[PraiseDate] [datetime] NULL,
 CONSTRAINT [PK_BmdCurrentCmntReplyPraise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdCurrentPraise]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdCurrentPraise](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CurrentId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[PraiseDate] [datetime] NULL,
 CONSTRAINT [PK_BmdCurrentPraise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdCurrentStar]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdCurrentStar](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CurrentId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[StarDate] [datetime] NULL,
 CONSTRAINT [pk_current_star] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdNotice]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdNotice](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[SpecieId] [bigint] NULL,
	[Type] [char](8) NULL,
	[Title] [varchar](100) NULL,
	[Place] [varchar](100) NULL,
	[FullPlace] [varchar](200) NULL,
	[EventTimeDesc] [varchar](100) NULL,
	[ImgUrl] [varchar](200) NULL,
	[ContactWay] [varchar](100) NULL,
	[Detail] [varchar](280) NULL,
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdNotice_CreatedAt]  DEFAULT (getdate()),
	[CmntCount] [bigint] NULL CONSTRAINT [DF_notice_cmnt_count]  DEFAULT ((0)),
	[TraceCount] [bigint] NULL CONSTRAINT [DF_notice_trace_count]  DEFAULT ((0)),
	[IsSolved] [tinyint] NULL CONSTRAINT [DF_BmdNotice_Status]  DEFAULT ((0)),
 CONSTRAINT [pk_notice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdNoticeCmnt]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdNoticeCmnt](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[NoticeId] [bigint] NULL,
	[Contents] [varchar](280) NULL,
	[CmntDate] [datetime] NULL,
	[ReplyCount] [bigint] NULL,
 CONSTRAINT [pk_notice_cmnt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdNoticeCmntReply]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdNoticeCmntReply](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CmntId] [bigint] NULL,
	[AimsId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[Contents] [varchar](280) NULL,
	[ReplyDate] [datetime] NULL,
 CONSTRAINT [pk_notice_reply] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdNoticeSpecie]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdNoticeSpecie](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NULL,
	[ImgUrl] [varchar](200) NULL,
	[NoticeCount] [bigint] NULL CONSTRAINT [DF_species_notice_count]  DEFAULT ((0)),
 CONSTRAINT [pk_species] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdNoticeTrace]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdNoticeTrace](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[NoticeId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[TraceDate] [datetime] NULL,
 CONSTRAINT [pk_notice_trace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdOrder]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdOrder](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[BuyerId] [bigint] NULL,
	[SellerId] [bigint] NULL,
	[ConsigneeId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
	[TotalPrice] [decimal](8, 2) NULL,
 CONSTRAINT [PK_BmdOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdOrderItem]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdOrderItem](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[Qty] [int] NULL,
 CONSTRAINT [PK_BmdOrderItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdProduct]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdProduct](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Title] [varchar](50) NULL,
	[Category] [varchar](10) NULL,
	[Tag] [varchar](10) NULL,
	[Price] [decimal](8, 2) NULL,
	[Inventory] [int] NULL CONSTRAINT [DF_BmdProduct_Qty]  DEFAULT ((0)),
	[ImgUrl] [varchar](200) NULL,
	[Tale] [text] NULL,
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdProduct_CreatedAt]  DEFAULT (getdate()),
 CONSTRAINT [PK_BmdProduct] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdRoot]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdRoot](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Permission] [tinyint] NULL,
	[PhoneNum] [varchar](11) NULL,
	[Email] [varchar](200) NULL,
	[Avatar] [varchar](200) NULL,
	[Remark] [varchar](200) NULL,
 CONSTRAINT [pk_bmd_root] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdShoppingCart]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdShoppingCart](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[Quantity] [int] NULL CONSTRAINT [DF_BmdShoppingCart_Qty]  DEFAULT ((1)),
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdShoppingCart_CreatedAt]  DEFAULT (getdate()),
 CONSTRAINT [PK_BmdShoppingCart] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdTopic]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdTopic](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Name] [varchar](50) NULL,
	[Detail] [varchar](100) NULL,
	[JoinCount] [bigint] NULL CONSTRAINT [DF_topic_join_count]  DEFAULT ((0)),
	[ImgUrl] [varchar](200) NULL,
	[IsPassed] [tinyint] NULL CONSTRAINT [DF_topic_is_passed]  DEFAULT ((0)),
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdTopic_CreatedAt]  DEFAULT (getdate()),
 CONSTRAINT [pk_topic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdTopicJoin]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdTopicJoin](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TopicId] [bigint] NULL,
	[CurrentId] [bigint] NULL,
 CONSTRAINT [pk_topic_join] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BmdUser]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BmdUser](
	[Id] [bigint] IDENTITY(10001,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Sex] [char](2) NULL,
	[PhoneNumber] [varchar](11) NULL,
	[Email] [varchar](200) NULL,
	[Type] [varchar](20) NULL,
	[Pwd] [varchar](16) NOT NULL,
	[AvatarUrl] [varchar](200) NULL CONSTRAINT [DF_bmd_user_avatar]  DEFAULT ('/assets/avatar-tmp.svg'),
	[FollowingCount] [bigint] NULL CONSTRAINT [DF_bmd_user_following_count]  DEFAULT ((0)),
	[FollowerCount] [bigint] NULL CONSTRAINT [DF_bmd_user_follower_count]  DEFAULT ((0)),
	[LostCount] [bigint] NULL CONSTRAINT [DF_BmdUser_LostCount]  DEFAULT ((0)),
	[FoundCount] [bigint] NULL CONSTRAINT [DF_BmdUser_FoundCount]  DEFAULT ((0)),
	[HelpCount] [bigint] NULL CONSTRAINT [DF_BmdUser_HelpCount]  DEFAULT ((0)),
	[Rating] [decimal](2, 1) NULL CONSTRAINT [DF_bmd_user_rate]  DEFAULT ((0.0)),
	[Credit] [int] NULL CONSTRAINT [DF_BmdUser_Credit]  DEFAULT ((0)),
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdUser_CreateAt]  DEFAULT (getdate()),
 CONSTRAINT [pk_bmd_user] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BmdUserFollow]    Script Date: 2018/6/23 22:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BmdUserFollow](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[FollowingId] [bigint] NULL,
	[CreatedAt] [datetime] NULL CONSTRAINT [DF_BmdUserFollow_CreatedAt]  DEFAULT (getdate()),
 CONSTRAINT [PK_follow_user] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[BmdCurrentCmnt] ADD  CONSTRAINT [DF_current_cmnt_praise_count]  DEFAULT ((0)) FOR [PraiseCount]
GO
ALTER TABLE [dbo].[BmdCurrentCmnt] ADD  CONSTRAINT [DF_current_cmnt_reply_count]  DEFAULT ((0)) FOR [ReplyCount]
GO
ALTER TABLE [dbo].[BmdCurrentCmntReply] ADD  CONSTRAINT [DF_current_reply_praise_count]  DEFAULT ((0)) FOR [PraiseCount]
GO
ALTER TABLE [dbo].[BmdNoticeCmnt] ADD  CONSTRAINT [DF_notice_cmnt_reply_count]  DEFAULT ((0)) FOR [ReplyCount]
GO
USE [master]
GO
ALTER DATABASE [bermuda-mvc] SET  READ_WRITE 
GO
