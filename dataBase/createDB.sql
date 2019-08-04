
CREATE SEQUENCE public.siteadministrateur_id_seq;

CREATE TABLE public.SiteAdministrateur (
                ID INTEGER NOT NULL DEFAULT nextval('public.siteadministrateur_id_seq'),
                Login VARCHAR(255) NOT NULL,
                Password VARCHAR(255) NOT NULL,
                CONSTRAINT siteadministrateur_pk PRIMARY KEY (ID)
);


ALTER SEQUENCE public.siteadministrateur_id_seq OWNED BY public.SiteAdministrateur.ID;

CREATE TABLE public.Licencie (
                Licence INTEGER NOT NULL,
                Prenom VARCHAR(25) NOT NULL,
                Nom VARCHAR(25) NOT NULL,
                Civilite VARCHAR(3) NOT NULL,
                DateNaissance DATE NOT NULL,
                ClubNom VARCHAR(255),
                CONSTRAINT licencie_pk PRIMARY KEY (Licence)
);


CREATE INDEX utilisateur_idx
 ON public.Licencie
 ( Prenom, Nom, Civilite, DateNaissance );

CREATE TABLE public.Utilisateur (
                Licencie INTEGER NOT NULL,
                Email VARCHAR(255) NOT NULL,
                Password VARCHAR(255) NOT NULL,
                Telephone VARCHAR(255),
                ProfileImage VARCHAR,
                Addresse VARCHAR(255),
                Createur BOOLEAN DEFAULT false NOT NULL,
                isAdmin BOOLEAN DEFAULT false NOT NULL,
                L_Date TIMESTAMP NOT NULL,
                L_IP VARCHAR(45) NOT NULL,
                CONSTRAINT utilisateur_pk PRIMARY KEY (Licencie)
);


CREATE TABLE public.Club (
                Nom VARCHAR(255) NOT NULL,
                CodePostal INTEGER NOT NULL,
                DirecteurLicence INTEGER NOT NULL,
                CONSTRAINT club_pk PRIMARY KEY (Nom)
);


CREATE UNIQUE INDEX club_idx
 ON public.Club
 ( Nom, CodePostal );

CREATE TABLE public.AutoLoginClub (
                Nom VARCHAR(255) NOT NULL,
                AutoLogin VARCHAR(255) NOT NULL,
                CONSTRAINT autologinclub_pk PRIMARY KEY (Nom)
);


CREATE TABLE public.Invitation (
                Nom VARCHAR(255) NOT NULL,
                Licence INTEGER NOT NULL,
                Email VARCHAR(255) NOT NULL,
                AutoLogin VARCHAR(255) NOT NULL,
                CONSTRAINT invitation_pk PRIMARY KEY (Nom, Licence)
);


CREATE TABLE public.Inscription (
                ClubNom VARCHAR(255) NOT NULL,
                UtilisateurLicence INTEGER NOT NULL,
                CONSTRAINT inscription_pk PRIMARY KEY (ClubNom, UtilisateurLicence)
);


CREATE SEQUENCE public.evenement_id_seq;

CREATE TABLE public.Evenement (
                ID INTEGER NOT NULL DEFAULT nextval('public.evenement_id_seq'),
                Nom VARCHAR(255) NOT NULL,
                DateDebut TIMESTAMP NOT NULL,
                DateFin TIMESTAMP NOT NULL,
                Lieu VARCHAR(255) NOT NULL,
                IsPublic BOOLEAN DEFAULT true NOT NULL,
                CreateurLicence INTEGER NOT NULL,
                CONSTRAINT evenement_pk PRIMARY KEY (ID)
);


ALTER SEQUENCE public.evenement_id_seq OWNED BY public.Evenement.ID;

CREATE SEQUENCE public.categorie_id_seq;

CREATE TABLE public.Categorie (
                ID INTEGER NOT NULL DEFAULT nextval('public.categorie_id_seq'),
                Nom VARCHAR(255) NOT NULL,
                Age VARCHAR(5) DEFAULT '00;99' NOT NULL,
                Genre VARCHAR(3) DEFAULT '*' NOT NULL,
                PointsDepart INTEGER DEFAULT 0 NOT NULL,
                EvenementID INTEGER NOT NULL,
                CONSTRAINT categorie_pk PRIMARY KEY (ID)
);
COMMENT ON COLUMN public.Categorie.PointsDepart IS 'points donn�s au depart';


ALTER SEQUENCE public.categorie_id_seq OWNED BY public.Categorie.ID;

CREATE SEQUENCE public.epreuve_id_seq;

CREATE TABLE public.Epreuve (
                ID INTEGER NOT NULL DEFAULT nextval('public.epreuve_id_seq'),
                Nom VARCHAR(255) NOT NULL,
                PointsMax INTEGER DEFAULT 0 NOT NULL,
                TempsEpreuve TIME NOT NULL,
                HeureStart TIMESTAMP NOT NULL,
                Emplacement VARCHAR(255) NOT NULL,
                CategorieID INTEGER NOT NULL,
                CONSTRAINT epreuve_pk PRIMARY KEY (ID)
);
COMMENT ON COLUMN public.Epreuve.PointsMax IS 'Points maximums enlev�s';


ALTER SEQUENCE public.epreuve_id_seq OWNED BY public.Epreuve.ID;

CREATE TABLE public.Orientation (
                EpreuveID INTEGER NOT NULL,
                Carte VARCHAR(255),
                AvecBalises BOOLEAN DEFAULT false NOT NULL,
                Distance REAL NOT NULL,
                CONSTRAINT orientation_pk PRIMARY KEY (EpreuveID)
);


CREATE SEQUENCE public.balise_id_seq;

CREATE TABLE public.Balise (
                ID INTEGER NOT NULL DEFAULT nextval('public.balise_id_seq'),
                Nom VARCHAR(255) NOT NULL,
                Emplacement VARCHAR(255) NOT NULL,
                PointsEnleve INTEGER DEFAULT 0 NOT NULL,
                OrientationID INTEGER NOT NULL,
                CONSTRAINT balise_pk PRIMARY KEY (ID)
);
COMMENT ON COLUMN public.Balise.PointsEnleve IS 'Points enlev� si non passage';


ALTER SEQUENCE public.balise_id_seq OWNED BY public.Balise.ID;

CREATE TABLE public.Quizz (
                EpreuveID INTEGER NOT NULL,
                CONSTRAINT quizz_pk PRIMARY KEY (EpreuveID)
);


CREATE SEQUENCE public.question_id_seq;

CREATE TABLE public.Question (
                ID INTEGER NOT NULL DEFAULT nextval('public.question_id_seq'),
                Enonce TEXT NOT NULL,
                PointsEnleve INTEGER DEFAULT 0 NOT NULL,
                QuizzID INTEGER,
                BaliseID INTEGER,
                ReponseID INTEGER NOT NULL,
                CONSTRAINT question_pk PRIMARY KEY (ID)
);
COMMENT ON COLUMN public.Question.PointsEnleve IS 'Points enlev� en cas de mauvaise r�ponse';


ALTER SEQUENCE public.question_id_seq OWNED BY public.Question.ID;

CREATE SEQUENCE public.choix_id_seq;

CREATE TABLE public.Choix (
                ID INTEGER NOT NULL DEFAULT nextval('public.choix_id_seq'),
                Choix VARCHAR(255) NOT NULL,
                QuestionID INTEGER NOT NULL,
                CONSTRAINT choix_pk PRIMARY KEY (ID)
);


ALTER SEQUENCE public.choix_id_seq OWNED BY public.Choix.ID;

CREATE TABLE public.Responsable (
                EvenementID INTEGER NOT NULL,
                UtilisateurLicence INTEGER NOT NULL,
                Niveau VARCHAR NOT NULL,
                CONSTRAINT responsable_pk PRIMARY KEY (EvenementID, UtilisateurLicence)
);


CREATE TABLE public.ResponsableEpreuve (
                EvenementID INTEGER NOT NULL,
                ResponsableLicence INTEGER NOT NULL,
                EpreuveID INTEGER,
                BaliseID INTEGER,
                CONSTRAINT responsableepreuve_pk PRIMARY KEY (EvenementID, ResponsableLicence)
);


CREATE TABLE public.Participant (
                Licencie INTEGER NOT NULL,
                EvenementID INTEGER NOT NULL,
                CategorieID INTEGER NOT NULL,
                CONSTRAINT participant_pk PRIMARY KEY (Licencie, EvenementID)
);


CREATE SEQUENCE public.reussite_id_seq;

CREATE TABLE public.Reussite (
                ID INTEGER NOT NULL DEFAULT nextval('public.reussite_id_seq'),
                Reussi BOOLEAN DEFAULT true NOT NULL,
                QuestionID INTEGER,
                BaliseID INTEGER,
                Licencie INTEGER NOT NULL,
                EvenementID INTEGER NOT NULL,
                CONSTRAINT reussite_pk PRIMARY KEY (ID)
);
COMMENT ON TABLE public.Reussite IS 'Points unitaires des balises/questions';


ALTER SEQUENCE public.reussite_id_seq OWNED BY public.Reussite.ID;

CREATE SEQUENCE public.score_id_seq;

CREATE TABLE public.Score (
                ID INTEGER NOT NULL DEFAULT nextval('public.score_id_seq'),
                Points INTEGER DEFAULT 0 NOT NULL,
                Commentaire VARCHAR(255) NOT NULL,
                EpreuveID INTEGER NOT NULL,
                Licencie INTEGER NOT NULL,
                EvenementID INTEGER NOT NULL,
                CONSTRAINT score_pk PRIMARY KEY (ID)
);
COMMENT ON TABLE public.Score IS 'Points d''une epreuve entiere';


ALTER SEQUENCE public.score_id_seq OWNED BY public.Score.ID;

ALTER TABLE public.Participant ADD CONSTRAINT utilisateur_participant_fk
FOREIGN KEY (Licencie)
REFERENCES public.Licencie (Licence)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Utilisateur ADD CONSTRAINT licencie_utilisateur_fk
FOREIGN KEY (Licencie)
REFERENCES public.Licencie (Licence)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Invitation ADD CONSTRAINT licencie_invitation_fk
FOREIGN KEY (Licence)
REFERENCES public.Licencie (Licence)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Responsable ADD CONSTRAINT utilisateur_administrateur_fk
FOREIGN KEY (UtilisateurLicence)
REFERENCES public.Utilisateur (Licencie)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Evenement ADD CONSTRAINT utilisateur_evenement_fk
FOREIGN KEY (CreateurLicence)
REFERENCES public.Utilisateur (Licencie)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Inscription ADD CONSTRAINT utilisateur_inscription_fk
FOREIGN KEY (UtilisateurLicence)
REFERENCES public.Utilisateur (Licencie)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Club ADD CONSTRAINT utilisateur_club_fk
FOREIGN KEY (DirecteurLicence)
REFERENCES public.Utilisateur (Licencie)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Licencie ADD CONSTRAINT club_utilisateur_fk
FOREIGN KEY (ClubNom)
REFERENCES public.Club (Nom)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Inscription ADD CONSTRAINT club_inscription_fk
FOREIGN KEY (ClubNom)
REFERENCES public.Club (Nom)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Invitation ADD CONSTRAINT club_invitation_fk
FOREIGN KEY (Nom)
REFERENCES public.Club (Nom)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.AutoLoginClub ADD CONSTRAINT club_autologinclub_fk
FOREIGN KEY (Nom)
REFERENCES public.Club (Nom)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Categorie ADD CONSTRAINT evenement_group_fk
FOREIGN KEY (EvenementID)
REFERENCES public.Evenement (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Participant ADD CONSTRAINT evenement_participant_fk
FOREIGN KEY (EvenementID)
REFERENCES public.Evenement (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Responsable ADD CONSTRAINT evenement_administrateur_fk
FOREIGN KEY (EvenementID)
REFERENCES public.Evenement (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Epreuve ADD CONSTRAINT group_epreuve_fk
FOREIGN KEY (CategorieID)
REFERENCES public.Categorie (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Participant ADD CONSTRAINT group_participant_fk
FOREIGN KEY (CategorieID)
REFERENCES public.Categorie (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Quizz ADD CONSTRAINT epreuve_quizz_fk
FOREIGN KEY (EpreuveID)
REFERENCES public.Epreuve (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Orientation ADD CONSTRAINT epreuve_orientation_fk
FOREIGN KEY (EpreuveID)
REFERENCES public.Epreuve (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Score ADD CONSTRAINT epreuve_score_fk
FOREIGN KEY (EpreuveID)
REFERENCES public.Epreuve (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ResponsableEpreuve ADD CONSTRAINT epreuve_epreuveadmin_fk
FOREIGN KEY (EpreuveID)
REFERENCES public.Epreuve (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Balise ADD CONSTRAINT orientation_balise_fk
FOREIGN KEY (OrientationID)
REFERENCES public.Orientation (EpreuveID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Question ADD CONSTRAINT balise_question_fk
FOREIGN KEY (BaliseID)
REFERENCES public.Balise (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Reussite ADD CONSTRAINT balise_reussite_fk
FOREIGN KEY (BaliseID)
REFERENCES public.Balise (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ResponsableEpreuve ADD CONSTRAINT balise_epreuveadmin_fk
FOREIGN KEY (BaliseID)
REFERENCES public.Balise (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Question ADD CONSTRAINT quizz_question_fk
FOREIGN KEY (QuizzID)
REFERENCES public.Quizz (EpreuveID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Choix ADD CONSTRAINT question_choix_fk
FOREIGN KEY (QuestionID)
REFERENCES public.Question (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Reussite ADD CONSTRAINT question_reussite_fk
FOREIGN KEY (QuestionID)
REFERENCES public.Question (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Question ADD CONSTRAINT choix_question_fk
FOREIGN KEY (ReponseID)
REFERENCES public.Choix (ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ResponsableEpreuve ADD CONSTRAINT responsable_responsableepreuve_fk
FOREIGN KEY (EvenementID, ResponsableLicence)
REFERENCES public.Responsable (EvenementID, UtilisateurLicence)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Score ADD CONSTRAINT participant_score_fk
FOREIGN KEY (Licencie, EvenementID)
REFERENCES public.Participant (Licencie, EvenementID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Reussite ADD CONSTRAINT participant_reussite_fk
FOREIGN KEY (Licencie, EvenementID)
REFERENCES public.Participant (Licencie, EvenementID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
