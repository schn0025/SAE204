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

drop table ACTIVITE cascade constraints;

drop table PROGRAMME cascade constraints;

DROP SEQUENCE PK_PARTICIPANT;

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
   dateNais             DATE,
   constraint PK_PARTICIPANT primary key (cdPers),
   constraint Contrainte_tpPers check (UPPER(tpPers) IN ('P', 'C', 'E')
)
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
   constraint PK_SITE primary key (cdSite),
   constraint FK_SITE_CORRESPON_THEME foreign key (cdTheme)
      references THEME (cdTheme)
      ON DELETE CASCADE,
   constraint FK_SITE_APPARTENI_TERRITOI foreign key (cdTerr)
      references TERRITOIRE (cdTerr)
);

/*==============================================================*/
/* Table : EVENEMENT                                            */
/*==============================================================*/
create table EVENEMENT 
(
   cdSite               INTEGER              not null,
   numEv                INTEGER              not null,
   dateDebEv            DATE                 not null,
   dateFinEv            DATE,
   nbPlaces             INTEGER,
   tarif                FLOAT,
   dureeEv              GENERATED ALWAYS AS (dateFinEv - dateDebEv) VIRTUAL,
   constraint PK_EVENEMENT primary key (cdSite, numEv),
   constraint Contrainte_mini_nbPlace check (nbPlaces >= 20),
   constraint CK_dateFinEv check (dateFinEv >= dateDebEv),
   constraint FK_EVENEMEN_PARTICIPE_PARTICIP foreign key (cdSite)
      references SITE (cdSite)
      ON DELETE CASCADE
);

/*==============================================================*/
/* Table : RESERVATION                                          */
/*==============================================================*/
create table RESERVATION 
(
   cdPers               INTEGER              not null,
   numEv                INTEGER              not null,
   cdSite               INTEGER              not null,
   dateResa             DATE                 not null,
   nbPlResa             INTEGER,
   modeReglt            INTEGER,
   constraint PK_RESERVATION primary key (cdPers, numEv, cdSite, dateResa),
   constraint Contrainte_modeReglt check (modeReglt BETWEEN 1 and 3),
   constraint FK_RESERVAT_RESERVER_PARTICIP foreign key (cdPers)
      references PARTICIPANT (cdPers)
      ON DELETE CASCADE,
   constraint FK_RESERVAT_CONSERNER_SITE foreign key (cdSite)
      references SITE (cdSite)
      ON DELETE CASCADE,
   constraint FK_RESERVAT_COINCIDER_EVENEMEN foreign key (cdSite, numEv)
      references EVENEMENT (cdSite, numEv)
      ON DELETE CASCADE
);

/*==============================================================*/
/* Table : ACTIVITE                                             */
/*==============================================================*/
CREATE TABLE ACTIVITE
(
    cdAct   CHAR(1) PRIMARY KEY not null,
    nomAct  VARCHAR(100)
);

INSERT  INTO ACTIVITE
    SELECT  *
    FROM    TESTSAELD.ACTIVITE;

/*==============================================================*/
/* Table : PROGRAMME                                            */
/*==============================================================*/
CREATE TABLE PROGRAMME
(
    cdAct       CHAR(1) not null,
    cdSite      INTEGER not null,
    tpPublic    VARCHAR(4),
    constraint PK_PROGRAMME primary key (cdAct, cdSite),
    constraint FK_cdAct foreign key (cdAct)
      references ACTIVITE (cdAct)
      ON DELETE CASCADE,
    constraint FK_cdSite foreign key (cdSite)
      references SITE (cdSite)
      ON DELETE CASCADE,
    constraint CK_tpPublic check (UPPER(tpPublic) IN ('TOUS', '+18', '+10', '+5'))
);

/*==============================================================*/
/* Création des index                                           */
/*==============================================================*/
CREATE INDEX fk_cdTerr  ON SITE (cdTerr);
CREATE INDEX fk_cdTheme ON SITE (cdTheme);
CREATE INDEX nomSite    ON SITE (nomSite);
CREATE INDEX nomPers    ON PARTICIPANT (nomPers);
CREATE INDEX prenomPers ON PARTICIPANT (prenomPers);
CREATE INDEX nomAct     ON ACTIVITE (nomACT);

/*==============================================================*/
/* Insertions : Theme                                           */
/*==============================================================*/
INSERT INTO THEME
VALUES(1, 'Animaux');

INSERT INTO THEME
VALUES(2, 'Sport');

INSERT INTO THEME
VALUES(3, 'Bateaux');

INSERT INTO THEME
VALUES(4, 'Ferme pédagogique');

INSERT INTO THEME
VALUES(5, 'Parcs et jardins');

INSERT INTO THEME
VALUES(6, 'Jeux pour enfants');

INSERT INTO THEME
VALUES(7, 'Patrimoine');

INSERT INTO THEME
VALUES(8, 'Parcours Sportifs');

INSERT INTO THEME
VALUES(9, 'Golf');

INSERT INTO THEME
VALUES(10, 'Sports nautiques');

INSERT INTO THEME
VALUES(11, 'Parc d''attraction');

/*==============================================================*/
/* Insertions : Territoire                                      */
/*==============================================================*/
INSERT INTO TERRITOIRE
VALUES(1, 'Autour du Louvres - Lens');

INSERT INTO TERRITOIRE
VALUES(2, 'Vallées ' || '&' || ' Marais');

INSERT INTO TERRITOIRE
VALUES(3, 'Côte d''opale');

/*==============================================================*/
/* Insertions : Participant                                     */
/*==============================================================*/
CREATE SEQUENCE PK_PARTICIPANT
START WITH 1;

INSERT INTO PARTICIPANT(cdPers, nomPers, prenomPers, adrPers, cpPers, villePers, telPers, tpPers)
    SELECT  PK_PARTICIPANT.NEXTVAL, 
            nomPers, 
            prenomPers, 
            adrPers, 
            cpPers, 
            villePers, 
            REPLACE(telPers, '.', ''), 
            tpPers
    FROM    TESTS1.EMPRUNTEUR;
    
INSERT INTO PARTICIPANT(cdPers, nomPers, prenomPers, adrPers, cpPers, villePers, telPers, tpPers)
    SELECT  PK_PARTICIPANT.NEXTVAL, 
            nom, 
            prnm, 
            adr, 
            cp, 
            localite, 
            NULL, 
            'P'
    FROM    TESTS1.CLIENT;
    
/*==============================================================*/
/* Insertions : Site                                            */
/*==============================================================*/
INSERT INTO SITE
    SELECT  cdSite,
            cdTerr,
            cdTheme,
            nomSite,
            tpSite,
            adrSite,
            cpSite,
            villeSite,
            emailSite,
            REPLACE(telSite, ' ', ''),
            siteWeb
    FROM    TESTSAELD.SITE
    WHERE   cdTerr BETWEEN 1 AND 3;
    
/*==============================================================*/
/* Insertions : Evenement                                       */
/*==============================================================*/
INSERT INTO EVENEMENT(cdSite,numEv,dateDebEv,dateFinEv,nbPlaces,tarif,nomEv)
    SELECT  cdSite,
            numEv,
            dateDebEv,
            dateFinEv,
            nbPlaces,
            tarif,
            nomEv
    FROM    TESTSAELD.EVENEMENT
    WHERE   cdSite IN   (SELECT cdSite
                        FROM    SITE);
                        
/*==============================================================*/
/* Insertions : Reservation                                     */
/*==============================================================*/
INSERT INTO RESERVATION(cdPers,numEv,cdSite,dateResa,nbPlResa,modeReglt)
    SELECT  cdPers,
            numEv,
            cdSite,
            dateInscr,
            nbPlResa,
            modeReglt
    FROM    TESTSAELD.INSCRIPTION
    WHERE   cdSite IN   (SELECT cdSite
                        FROM    SITE)
      AND   cdPers IN   (SELECT cdPers
                        FROM    PARTICIPANT)
      AND   numEv IN   (SELECT numEv
                        FROM    EVENEMENT);
                        
/*==============================================================*/
/* Correction de dernières minutes                              */
/*==============================================================*/
ALTER TABLE EVENEMENT
ADD nomEv VARCHAR(100);