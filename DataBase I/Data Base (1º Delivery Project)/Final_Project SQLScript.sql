/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     07/10/2022 14:39:41                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AD_HOC_SEASONAL') and o.name = 'FK_AD_HOC_S_INHERITAN_PROMOTIO')
alter table AD_HOC_SEASONAL
   drop constraint FK_AD_HOC_S_INHERITAN_PROMOTIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COUNTDOWN') and o.name = 'FK_COUNTDOW_INHERITAN_PROMOTIO')
alter table COUNTDOWN
   drop constraint FK_COUNTDOW_INHERITAN_PROMOTIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_ITEMS_FRO_STORE_PA')
alter table ITEMS
   drop constraint FK_ITEMS_ITEMS_FRO_STORE_PA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_ITEMS_FRO_LW_PACKA')
alter table ITEMS
   drop constraint FK_ITEMS_ITEMS_FRO_LW_PACKA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_ITEMS_IN__AD_HOC_S')
alter table ITEMS
   drop constraint FK_ITEMS_ITEMS_IN__AD_HOC_S
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_ITEM_SUBC_SUBCATEG')
alter table ITEMS
   drop constraint FK_ITEMS_ITEM_SUBC_SUBCATEG
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_RELATIONS_STORE')
alter table ITEMS
   drop constraint FK_ITEMS_RELATIONS_STORE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_RELATIONS_SALES')
alter table ITEMS
   drop constraint FK_ITEMS_RELATIONS_SALES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ITEMS') and o.name = 'FK_ITEMS_RELATIONS_NDC')
alter table ITEMS
   drop constraint FK_ITEMS_RELATIONS_NDC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LW_PACKAGES') and o.name = 'FK_LW_PACKA_PACKAGES__CONTAINE')
alter table LW_PACKAGES
   drop constraint FK_LW_PACKA_PACKAGES__CONTAINE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LW_PACKAGES') and o.name = 'FK_LW_PACKA_PACKED_IN_LW')
alter table LW_PACKAGES
   drop constraint FK_LW_PACKA_PACKED_IN_LW
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NEWSLETTER_SUBSCRIPTION') and o.name = 'FK_NEWSLETT_NEWSLETTE_CLIENTS')
alter table NEWSLETTER_SUBSCRIPTION
   drop constraint FK_NEWSLETT_NEWSLETTE_CLIENTS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NEWSLETTER_SUBSCRIPTION') and o.name = 'FK_NEWSLETT_NEWSLETTE_STORE')
alter table NEWSLETTER_SUBSCRIPTION
   drop constraint FK_NEWSLETT_NEWSLETTE_STORE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PROMOTIONS') and o.name = 'FK_PROMOTIO_RELATIONS_STORE')
alter table PROMOTIONS
   drop constraint FK_PROMOTIO_RELATIONS_STORE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SALES') and o.name = 'FK_SALES_RELATIONS_STORE')
alter table SALES
   drop constraint FK_SALES_RELATIONS_STORE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STORE_PACKAGES') and o.name = 'FK_STORE_PA_RELATIONS_STORE')
alter table STORE_PACKAGES
   drop constraint FK_STORE_PA_RELATIONS_STORE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SUBCATEGORY') and o.name = 'FK_SUBCATEG_RELATIONS_CATEGORY')
alter table SUBCATEGORY
   drop constraint FK_SUBCATEG_RELATIONS_CATEGORY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AD_HOC_SEASONAL')
            and   type = 'U')
   drop table AD_HOC_SEASONAL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CATEGORY')
            and   type = 'U')
   drop table CATEGORY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLIENTS')
            and   type = 'U')
   drop table CLIENTS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTAINER')
            and   type = 'U')
   drop table CONTAINER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COUNTDOWN')
            and   type = 'U')
   drop table COUNTDOWN
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ITEMS')
            and   name  = 'RELATIONSHIP_14_FK'
            and   indid > 0
            and   indid < 255)
   drop index ITEMS.RELATIONSHIP_14_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ITEMS')
            and   name  = 'RELATIONSHIP_11_FK'
            and   indid > 0
            and   indid < 255)
   drop index ITEMS.RELATIONSHIP_11_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ITEMS')
            and   name  = 'RELATIONSHIP_6_FK'
            and   indid > 0
            and   indid < 255)
   drop index ITEMS.RELATIONSHIP_6_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ITEMS')
            and   name  = 'RELATIONSHIP_2_FK'
            and   indid > 0
            and   indid < 255)
   drop index ITEMS.RELATIONSHIP_2_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ITEMS')
            and   type = 'U')
   drop table ITEMS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LW')
            and   type = 'U')
   drop table LW
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('LW_PACKAGES')
            and   name  = 'RELATIONSHIP_9_FK'
            and   indid > 0
            and   indid < 255)
   drop index LW_PACKAGES.RELATIONSHIP_9_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('LW_PACKAGES')
            and   name  = 'RELATIONSHIP_3_FK'
            and   indid > 0
            and   indid < 255)
   drop index LW_PACKAGES.RELATIONSHIP_3_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LW_PACKAGES')
            and   type = 'U')
   drop table LW_PACKAGES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('NDC')
            and   type = 'U')
   drop table NDC
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NEWSLETTER_SUBSCRIPTION')
            and   name  = 'NEWSLETTER_SUBSCRIPTION2_FK'
            and   indid > 0
            and   indid < 255)
   drop index NEWSLETTER_SUBSCRIPTION.NEWSLETTER_SUBSCRIPTION2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NEWSLETTER_SUBSCRIPTION')
            and   name  = 'NEWSLETTER_SUBSCRIPTION_FK'
            and   indid > 0
            and   indid < 255)
   drop index NEWSLETTER_SUBSCRIPTION.NEWSLETTER_SUBSCRIPTION_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('NEWSLETTER_SUBSCRIPTION')
            and   type = 'U')
   drop table NEWSLETTER_SUBSCRIPTION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PROMOTIONS')
            and   type = 'U')
   drop table PROMOTIONS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SALES')
            and   name  = 'RELATIONSHIP_18_FK'
            and   indid > 0
            and   indid < 255)
   drop index SALES.RELATIONSHIP_18_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SALES')
            and   type = 'U')
   drop table SALES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STORE')
            and   type = 'U')
   drop table STORE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STORE_PACKAGES')
            and   name  = 'RELATIONSHIP_5_FK'
            and   indid > 0
            and   indid < 255)
   drop index STORE_PACKAGES.RELATIONSHIP_5_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STORE_PACKAGES')
            and   type = 'U')
   drop table STORE_PACKAGES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SUBCATEGORY')
            and   name  = 'RELATIONSHIP_19_FK'
            and   indid > 0
            and   indid < 255)
   drop index SUBCATEGORY.RELATIONSHIP_19_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SUBCATEGORY')
            and   type = 'U')
   drop table SUBCATEGORY
go

/*==============================================================*/
/* Table: AD_HOC_SEASONAL                                       */
/*==============================================================*/
create table AD_HOC_SEASONAL (
   PROMOTION_ID         numeric              not null,
   STARTING_DATE        datetime             null,
   END_DATE             datetime             null,
   DISCOUNT_PERCENTAGE  numeric              not null,
   STOREWIDE            bit                  not null,
   constraint PK_AD_HOC_SEASONAL primary key (PROMOTION_ID)
)
go

/*==============================================================*/
/* Table: CATEGORY                                              */
/*==============================================================*/
create table CATEGORY (
   CATEGORY_ID          numeric              identity,
   CATEGORY_NAME        varchar(50)          not null,
   constraint PK_CATEGORY primary key nonclustered (CATEGORY_ID)
)
go

/*==============================================================*/
/* Table: CLIENTS                                               */
/*==============================================================*/
create table CLIENTS (
   CLIENT_ID            numeric              identity,
   EMAIL                varchar(50)          not null,
   FIRST_NAME           varchar(20)          not null,
   LAST_NAME            varchar(20)          not null,
   PHONE                varchar(20)          null,
   constraint PK_CLIENTS primary key nonclustered (CLIENT_ID)
)
go

/*==============================================================*/
/* Table: CONTAINER                                             */
/*==============================================================*/
create table CONTAINER (
   CONTAINER_ID         numeric              identity,
   STATE__FULL_         bit                  not null,
   LONGITTUDE__CONT_    float(25)            not null,
   LATITUDE__CONT_      float(25)            not null,
   constraint PK_CONTAINER primary key nonclustered (CONTAINER_ID)
)
go

/*==============================================================*/
/* Table: COUNTDOWN                                             */
/*==============================================================*/
create table COUNTDOWN (
   PROMOTION_ID         numeric              not null,
   STARTING_DATE        datetime             null,
   END_DATE             datetime             null,
   STARTING_PRICE       float(10)            not null,
   FINAL_PRICE          float(10)            not null,
   AMOUNT_DECREASED     float(10)            not null,
   constraint PK_COUNTDOWN primary key (PROMOTION_ID)
)
go

/*==============================================================*/
/* Table: ITEMS                                                 */
/*==============================================================*/
create table ITEMS (
   ITEM_ID              numeric              identity,
   SALES_ID             numeric              null,
   CATEGORY_ID          numeric              null,
   SUBCATEGORY_ID       numeric              null,
   STORE_ID2            numeric              null,
   LW_ID2               numeric              null,
   CONTAINER_ID         numeric              null,
   LW_PACKAGES_ID       numeric              null,
   STO_STORE_ID2        numeric              null,
   STORE_PACKAGES_ID    numeric              null,
   NDC_ID               numeric              null,
   PROMOTION_ID         numeric              null,
   FINAL_USE            varchar(20)          not null
      constraint CKC_FINAL_USE_ITEMS check (FINAL_USE in ('Resale','Recycling','Reuse','Elimination')),
   SEASON               varchar(20)          null
      constraint CKC_SEASON_ITEMS check (SEASON is null or (SEASON in ('Summer','Winter','Spring','Fall','Autumn'))),
   SIZE                 varchar(20)          null,
   BRAND                varchar(50)          null,
   ITEM_TYPE            varchar(20)          null
      constraint CKC_ITEM_TYPE_ITEMS check (ITEM_TYPE is null or (ITEM_TYPE in ('Premium','Regular'))),
   SECTION              varchar(20)          null
      constraint CKC_SECTION_ITEMS check (SECTION is null or (SECTION in ('Man','Woman','Kids','Baby','Unisex','None'))),
   PRICE                float(15)            null,
   COLOR                varchar(20)          null,
   IN_STOCK_SINCE       datetime             not null,
   IN_STOCK_UNTIL       datetime             not null,
   constraint PK_ITEMS primary key nonclustered (ITEM_ID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_2_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_2_FK on ITEMS (
CONTAINER_ID ASC,
LW_ID2 ASC,
LW_PACKAGES_ID ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_6_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_6_FK on ITEMS (
STO_STORE_ID2 ASC,
STORE_PACKAGES_ID ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_11_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_11_FK on ITEMS (
CATEGORY_ID ASC,
SUBCATEGORY_ID ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_14_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_14_FK on ITEMS (
STORE_ID2 ASC
)
go

/*==============================================================*/
/* Table: LW                                                    */
/*==============================================================*/
create table LW (
   LW_ID2               numeric              identity,
   STREET_NAME          varchar(50)          not null,
   BUILDING_NUMBER      numeric(5)           not null,
   POSTAL_CODE          varchar(10)          not null,
   FLOOR_NUMBER         numeric(5)           not null,
   LW_NAME              varchar(50)          null,
   constraint PK_LW primary key nonclustered (LW_ID2),
   constraint AK_UNIQUE_ADRESS_LW unique (STREET_NAME, BUILDING_NUMBER, POSTAL_CODE, FLOOR_NUMBER)
)
go

/*==============================================================*/
/* Table: LW_PACKAGES                                           */
/*==============================================================*/
create table LW_PACKAGES (
   LW_ID2               numeric              not null,
   CONTAINER_ID         numeric              not null,
   LW_PACKAGES_ID       numeric              identity,
   constraint PK_LW_PACKAGES primary key nonclustered (CONTAINER_ID, LW_ID2, LW_PACKAGES_ID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_3_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_3_FK on LW_PACKAGES (
LW_ID2 ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_9_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_9_FK on LW_PACKAGES (
CONTAINER_ID ASC
)
go

/*==============================================================*/
/* Table: NDC                                                   */
/*==============================================================*/
create table NDC (
   NDC_ID               numeric              identity,
   NDC_NAME             varchar(50)          null,
   constraint PK_NDC primary key nonclustered (NDC_ID)
)
go

/*==============================================================*/
/* Table: NEWSLETTER_SUBSCRIPTION                               */
/*==============================================================*/
create table NEWSLETTER_SUBSCRIPTION (
   CLIENT_ID            numeric              not null,
   STORE_ID2            numeric              not null,
   constraint PK_NEWSLETTER_SUBSCRIPTION primary key (CLIENT_ID, STORE_ID2)
)
go

/*==============================================================*/
/* Index: NEWSLETTER_SUBSCRIPTION_FK                            */
/*==============================================================*/
create index NEWSLETTER_SUBSCRIPTION_FK on NEWSLETTER_SUBSCRIPTION (
CLIENT_ID ASC
)
go

/*==============================================================*/
/* Index: NEWSLETTER_SUBSCRIPTION2_FK                           */
/*==============================================================*/
create index NEWSLETTER_SUBSCRIPTION2_FK on NEWSLETTER_SUBSCRIPTION (
STORE_ID2 ASC
)
go

/*==============================================================*/
/* Table: PROMOTIONS                                            */
/*==============================================================*/
create table PROMOTIONS (
   PROMOTION_ID         numeric              identity,
   STORE_ID2            numeric              null,
   STARTING_DATE        datetime             null,
   END_DATE             datetime             null,
   constraint PK_PROMOTIONS primary key nonclustered (PROMOTION_ID)
)
go

/*==============================================================*/
/* Table: SALES                                                 */
/*==============================================================*/
create table SALES (
   SALES_ID             numeric              identity,
   STORE_ID2            numeric              not null,
   SALES_DATE           datetime             not null,
   constraint PK_SALES primary key nonclustered (SALES_ID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_18_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_18_FK on SALES (
STORE_ID2 ASC
)
go

/*==============================================================*/
/* Table: STORE                                                 */
/*==============================================================*/
create table STORE (
   STORE_ID2            numeric              identity,
   STORE_NAME           varchar(50)          null,
   LONGITUDE            float(25)            not null
      constraint CKC_LONGITUDE_STORE check (LONGITUDE between -180.0 and 180.0),
   LATITUDE             float(25)            not null
      constraint CKC_LATITUDE_STORE check (LATITUDE between -90.0 and 90.0),
   STREETNAME           varchar(50)          not null,
   BUILDINGNUMBER       numeric(5)           not null,
   STORE_POSTAL_CODE    varchar(10)          not null,
   STORE_FLOOR_NUMBER   numeric(5)           not null,
   STORE_TYPE           varchar(20)          not null
      constraint CKC_STORE_TYPE_STORE check (STORE_TYPE in ('Regular','Premium')),
   constraint PK_STORE primary key nonclustered (STORE_ID2),
   constraint AK_UNIQUE_ADRESS_STORE unique (STREETNAME, BUILDINGNUMBER, STORE_POSTAL_CODE, STORE_FLOOR_NUMBER)
)
go

/*==============================================================*/
/* Table: STORE_PACKAGES                                        */
/*==============================================================*/
create table STORE_PACKAGES (
   STORE_ID2            numeric              not null,
   STORE_PACKAGES_ID    numeric              identity,
   constraint PK_STORE_PACKAGES primary key nonclustered (STORE_ID2, STORE_PACKAGES_ID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_5_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_5_FK on STORE_PACKAGES (
STORE_ID2 ASC
)
go

/*==============================================================*/
/* Table: SUBCATEGORY                                           */
/*==============================================================*/
create table SUBCATEGORY (
   CATEGORY_ID          numeric              not null,
   SUBCATEGORY_ID       numeric              identity,
   SUBCATEGORY          varchar(50)          not null,
   constraint PK_SUBCATEGORY primary key nonclustered (CATEGORY_ID, SUBCATEGORY_ID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_19_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_19_FK on SUBCATEGORY (
CATEGORY_ID ASC
)
go

alter table AD_HOC_SEASONAL
   add constraint FK_AD_HOC_S_INHERITAN_PROMOTIO foreign key (PROMOTION_ID)
      references PROMOTIONS (PROMOTION_ID)
go

alter table COUNTDOWN
   add constraint FK_COUNTDOW_INHERITAN_PROMOTIO foreign key (PROMOTION_ID)
      references PROMOTIONS (PROMOTION_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_ITEMS_FRO_STORE_PA foreign key (STO_STORE_ID2, STORE_PACKAGES_ID)
      references STORE_PACKAGES (STORE_ID2, STORE_PACKAGES_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_ITEMS_FRO_LW_PACKA foreign key (CONTAINER_ID, LW_ID2, LW_PACKAGES_ID)
      references LW_PACKAGES (CONTAINER_ID, LW_ID2, LW_PACKAGES_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_ITEMS_IN__AD_HOC_S foreign key (PROMOTION_ID)
      references AD_HOC_SEASONAL (PROMOTION_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_ITEM_SUBC_SUBCATEG foreign key (CATEGORY_ID, SUBCATEGORY_ID)
      references SUBCATEGORY (CATEGORY_ID, SUBCATEGORY_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_RELATIONS_STORE foreign key (STORE_ID2)
      references STORE (STORE_ID2)
go

alter table ITEMS
   add constraint FK_ITEMS_RELATIONS_SALES foreign key (SALES_ID)
      references SALES (SALES_ID)
go

alter table ITEMS
   add constraint FK_ITEMS_RELATIONS_NDC foreign key (NDC_ID)
      references NDC (NDC_ID)
go

alter table LW_PACKAGES
   add constraint FK_LW_PACKA_PACKAGES__CONTAINE foreign key (CONTAINER_ID)
      references CONTAINER (CONTAINER_ID)
go

alter table LW_PACKAGES
   add constraint FK_LW_PACKA_PACKED_IN_LW foreign key (LW_ID2)
      references LW (LW_ID2)
go

alter table NEWSLETTER_SUBSCRIPTION
   add constraint FK_NEWSLETT_NEWSLETTE_CLIENTS foreign key (CLIENT_ID)
      references CLIENTS (CLIENT_ID)
go

alter table NEWSLETTER_SUBSCRIPTION
   add constraint FK_NEWSLETT_NEWSLETTE_STORE foreign key (STORE_ID2)
      references STORE (STORE_ID2)
go

alter table PROMOTIONS
   add constraint FK_PROMOTIO_RELATIONS_STORE foreign key (STORE_ID2)
      references STORE (STORE_ID2)
go

alter table SALES
   add constraint FK_SALES_RELATIONS_STORE foreign key (STORE_ID2)
      references STORE (STORE_ID2)
go

alter table STORE_PACKAGES
   add constraint FK_STORE_PA_RELATIONS_STORE foreign key (STORE_ID2)
      references STORE (STORE_ID2)
go

alter table SUBCATEGORY
   add constraint FK_SUBCATEG_RELATIONS_CATEGORY foreign key (CATEGORY_ID)
      references CATEGORY (CATEGORY_ID)
go

