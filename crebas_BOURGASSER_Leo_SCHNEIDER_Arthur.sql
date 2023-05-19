/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de création :  19/05/2023 14:37:12                      */
/*==============================================================*/


drop index PARTICIPER_FK;

drop table EVENEMENT cascade constraints;

drop table PARTICIPANT cascade constraints;

drop index CONSERNER_FK;

drop index COINCIDER_AVEC_FK;

drop index RESERVER_FK;

drop table RESERVATION cascade constraints;

drop index APPARTENIR_FK;

drop index CORRESPONDRE_FK;

drop table SITE cascade constraints;

drop table TERRITOIRE cascade constraints;

drop table THEME cascade constraints;

/*==============================================================*/
/* Table : EVENEMENT                                            */
/*==============================================================*/
create table EVENEMENT 
(
   cdPers               INTEGER              not null,
   numEv                INTEGER              not null,
   dateDebEv            DATE,
   dateFinEv            DATE,
   nbPlaces             INTEGER,
   tarif                FLOAT,
   constraint PK_EVENEMENT primary key (cdPers, numEv),
   constraint Contrainte_mini_nbPlace check (nbPlaces >= 20
)
);

/*==============================================================*/
/* Table : PARTICIPANT                                          */
/*==============================================================*/
create table PARTICIPANT 
(
   cdPers               INTEGER              not null,
   nomPers              VARCHAR2(100),
   prenomPers           VARCHAR2(100),
   adrPers              VARCHAR2(100),
   cpPers               CHAR(5),
   villePers            VARCHAR2(100),
   telPers              CHAR(10),
   tpPers               CHAR(1),
   constraint PK_PARTICIPANT primary key (cdPers),
   constraint Contrainte_tpPers check (UPPER(tpPers) IN ('P', 'C', 'E')
)
);

/*==============================================================*/
/* Table : RESERVATION                                          */
/*==============================================================*/
create table RESERVATION 
(
   cdPers               INTEGER              not null,
   EVE_cdPers           INTEGER              not null,
   numEv                INTEGER              not null,
   cdSite               INTEGER              not null,
   dateResa             DATE                 not null,
   nbPlResa             INTEGER,
   modeReglt            INTEGER,
   constraint PK_RESERVATION primary key (cdPers, EVE_cdPers, numEv, cdSite, dateResa),
   constraint Contrainte_modeReglt check (1 <= modeReglt <= 3
)
);

/*==============================================================*/
/* Table : SITE                                                 */
/*==============================================================*/
create table SITE 
(
   cdSite               INTEGER              not null,
   cdTerr               INTEGER              not null,
   cdTheme              INTEGER              not null,
   nomSite              VARCHAR2(100),
   tpSite               VARCHAR2(100),
   adrSite              VARCHAR2(100),
   cpSite               CHAR(5),
   villeSite            VARCHAR2(100),
   emailSite            VARCHAR2(100),
   telSite              CHAR(10),
   siteweb              VARCHAR2(100),
   constraint PK_SITE primary key (cdSite)
);

/*==============================================================*/
/* Table : TERRITOIRE                                           */
/*==============================================================*/
create table TERRITOIRE 
(
   cdTerr               INTEGER              not null,
   nomTerr              VARCHAR2(100),
   constraint PK_TERRITOIRE primary key (cdTerr)
);

/*==============================================================*/
/* Table : THEME                                                */
/*==============================================================*/
create table THEME 
(
   cdTheme              INTEGER              not null,
   libThme              VARCHAR2(100),
   constraint PK_THEME primary key (cdTheme)
);

alter table EVENEMENT
   add constraint FK_EVENEMEN_PARTICIPE_PARTICIP foreign key (cdPers)
      references PARTICIPANT (cdPers);

alter table RESERVATION
   add constraint FK_RESERVAT_COINCIDER_EVENEMEN foreign key (EVE_cdPers, numEv)
      references EVENEMENT (cdPers, numEv);

alter table RESERVATION
   add constraint FK_RESERVAT_CONSERNER_SITE foreign key (cdSite)
      references SITE (cdSite);

alter table RESERVATION
   add constraint FK_RESERVAT_RESERVER_PARTICIP foreign key (cdPers)
      references PARTICIPANT (cdPers);

alter table SITE
   add constraint FK_SITE_APPARTENI_TERRITOI foreign key (cdTerr)
      references TERRITOIRE (cdTerr);

alter table SITE
   add constraint FK_SITE_CORRESPON_THEME foreign key (cdTheme)
      references THEME (cdTheme);

