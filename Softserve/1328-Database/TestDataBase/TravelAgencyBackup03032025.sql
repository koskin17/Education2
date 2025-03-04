PGDMP  :                    }            TravelAgency    17.2    17.1 Z    C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            F           1262    42301    TravelAgency    DATABASE     �   CREATE DATABASE "TravelAgency" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Ukrainian_Ukraine.1252';
    DROP DATABASE "TravelAgency";
                     postgres    false            �            1255    42492 C   add_client(character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.add_client(IN p_full_name character varying, IN p_email character varying, IN p_phone character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Проверяем, существует ли уже такой email или телефон
    IF EXISTS (SELECT p_email, p_phone FROM clients WHERE clients.email = p_email OR clients.phone = p_phone) THEN
        RAISE EXCEPTION 'Клиент с таким email или телефоном уже существует!';
    END IF;

    -- Вставка нового клиента
    INSERT INTO clients (full_name, email, phone) VALUES (p_full_name, p_email, p_phone);
END;
$$;
 �   DROP PROCEDURE public.add_client(IN p_full_name character varying, IN p_email character varying, IN p_phone character varying);
       public               postgres    false            �            1255    42467    count_client_contracts(integer)    FUNCTION     4  CREATE FUNCTION public.count_client_contracts(client_id_param integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$  
DECLARE  
    contract_count INT;  
BEGIN  
    SELECT COUNT(*) INTO contract_count  
    FROM Contracts  
    WHERE client_id = client_id_param;  
    RETURN contract_count;  
END;  
$$;
 F   DROP FUNCTION public.count_client_contracts(client_id_param integer);
       public               postgres    false            �            1255    42479    email_exists(character varying)    FUNCTION       CREATE FUNCTION public.email_exists(p_email character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    exists VARCHAR;
BEGIN
    SELECT p_email FROM clients WHERE clients.email = p_email INTO exists;
    RETURN exists;
END;
$$;
 >   DROP FUNCTION public.email_exists(p_email character varying);
       public               postgres    false            �            1255    42489 &   get_client_by_email(character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.get_client_by_email(IN client_email character varying, OUT client_id integer, OUT full_name character varying, OUT phone character varying, OUT created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Получаем данные клиента
    SELECT c.client_id, c.full_name, c.phone, c.created_at 
    INTO client_id, full_name, phone, created_at
    FROM clients AS c
    WHERE c.email = client_email;
END;
$$;
 �   DROP PROCEDURE public.get_client_by_email(IN client_email character varying, OUT client_id integer, OUT full_name character varying, OUT phone character varying, OUT created_at timestamp without time zone);
       public               postgres    false            �            1255    42475    get_client_by_id(integer)    FUNCTION     <  CREATE FUNCTION public.get_client_by_id(p_client_id integer) RETURNS TABLE(full_name character varying, email character varying, phone character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT clients.full_name, clients.email, clients.phone FROM clients WHERE client_id = p_client_id;
END;
$$;
 <   DROP FUNCTION public.get_client_by_id(p_client_id integer);
       public               postgres    false            �            1255    42473    get_clients_count()    FUNCTION     �   CREATE FUNCTION public.get_clients_count() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    client_count INT;
BEGIN
    SELECT COUNT(*) INTO client_count FROM Clients;
    RETURN client_count;
END;
$$;
 *   DROP FUNCTION public.get_clients_count();
       public               postgres    false            �            1255    42466     get_min_max_resort_cost(integer)    FUNCTION       CREATE FUNCTION public.get_min_max_resort_cost(resort_id_param integer) RETURNS TABLE(min_cost numeric, max_cost numeric)
    LANGUAGE plpgsql
    AS $$  
BEGIN  
    RETURN QUERY  
    SELECT MIN(cost), MAX(cost)  
    FROM offers  
    WHERE resort_id = resort_id_param;  
END;  
$$;
 G   DROP FUNCTION public.get_min_max_resort_cost(resort_id_param integer);
       public               postgres    false            �            1255    42471    get_resort_info(integer)    FUNCTION     �  CREATE FUNCTION public.get_resort_info(resort_id_param integer) RETURNS TABLE(resort_name character varying, resort_type character varying, resort_quality integer, resort_country character varying, resort_location character varying)
    LANGUAGE plpgsql
    AS $$  
BEGIN  
    RETURN QUERY
    SELECT name, type, quality, country, location  
    FROM resorts  
    WHERE resort_id = resort_id_param;  
END;  
$$;
 ?   DROP FUNCTION public.get_resort_info(resort_id_param integer);
       public               postgres    false            �            1255    42491 /   update_client_email(integer, character varying) 	   PROCEDURE       CREATE PROCEDURE public.update_client_email(IN p_client_id integer, IN p_new_email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Проверяем, существует ли уже такой email
    IF EXISTS (SELECT p_new_email FROM clients WHERE clients.email = p_new_email) THEN
        RAISE EXCEPTION 'Email уже используется другим клиентом!';
    END IF;

    -- Обновляем email клиента
    UPDATE clients SET email = p_new_email WHERE client_id = p_client_id;
END;
$$;
 e   DROP PROCEDURE public.update_client_email(IN p_client_id integer, IN p_new_email character varying);
       public               postgres    false            �            1255    42490 T   update_client_info(integer, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.update_client_info(IN p_client_id integer, IN p_full_name character varying DEFAULT NULL::character varying, IN p_email character varying DEFAULT NULL::character varying, IN p_phone character varying DEFAULT NULL::character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Clients
    SET 
        full_name = COALESCE(p_full_name, full_name),
        email = COALESCE(p_email, email),
        phone = COALESCE(p_phone, phone)
    WHERE client_id = p_client_id;
END;
$$;
 �   DROP PROCEDURE public.update_client_info(IN p_client_id integer, IN p_full_name character varying, IN p_email character varying, IN p_phone character varying);
       public               postgres    false            �            1259    42328    clients    TABLE     	  CREATE TABLE public.clients (
    client_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.clients;
       public         heap r       postgres    false            G           0    0    TABLE clients    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO sales_manager_lead;
GRANT SELECT,INSERT ON TABLE public.clients TO sales_manager;
          public               postgres    false    222            �            1259    42456    active_clients_view    VIEW     �   CREATE VIEW public.active_clients_view AS
 SELECT client_id,
    full_name,
    email,
    phone
   FROM public.clients
  WHERE ((email)::text ~~ '%example.com'::text)
  WITH CASCADED CHECK OPTION;
 &   DROP VIEW public.active_clients_view;
       public       v       postgres    false    222    222    222    222            �            1259    42342    agents    TABLE     �   CREATE TABLE public.agents (
    agent_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    commission_percentage numeric(5,2) NOT NULL
);
    DROP TABLE public.agents;
       public         heap r       postgres    false            H           0    0    TABLE agents    ACL     P   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.agents TO sales_manager_lead;
          public               postgres    false    224            �            1259    42341    agents_agent_id_seq    SEQUENCE     �   CREATE SEQUENCE public.agents_agent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.agents_agent_id_seq;
       public               postgres    false    224            I           0    0    agents_agent_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.agents_agent_id_seq OWNED BY public.agents.agent_id;
          public               postgres    false    223            �            1259    42327    clients_client_id_seq    SEQUENCE     �   CREATE SEQUENCE public.clients_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.clients_client_id_seq;
       public               postgres    false    222            J           0    0    clients_client_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.clients_client_id_seq OWNED BY public.clients.client_id;
          public               postgres    false    221            �            1259    42396    comments    TABLE       CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    resort_id integer NOT NULL,
    photo_id integer NOT NULL,
    client_id integer NOT NULL,
    comment_text text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.comments;
       public         heap r       postgres    false            �            1259    42395    comments_comment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.comments_comment_id_seq;
       public               postgres    false    230            K           0    0    comments_comment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;
          public               postgres    false    229            �            1259    42355 	   contracts    TABLE       CREATE TABLE public.contracts (
    contract_id integer NOT NULL,
    client_id integer NOT NULL,
    agent_id integer NOT NULL,
    resort_id integer NOT NULL,
    offer_id integer NOT NULL,
    sign_date date NOT NULL,
    rest_start date NOT NULL,
    rest_end date NOT NULL
);
    DROP TABLE public.contracts;
       public         heap r       postgres    false            L           0    0    TABLE contracts    ACL     �   GRANT SELECT ON TABLE public.contracts TO sales_manager;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.contracts TO sales_manager_lead;
          public               postgres    false    226            �            1259    42354    contracts_contract_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contracts_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.contracts_contract_id_seq;
       public               postgres    false    226            M           0    0    contracts_contract_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.contracts_contract_id_seq OWNED BY public.contracts.contract_id;
          public               postgres    false    225            �            1259    42440    count_of_orders_by_client    VIEW     �   CREATE VIEW public.count_of_orders_by_client AS
 SELECT client_id,
    full_name,
    ( SELECT count(*) AS count
           FROM public.contracts
          WHERE (contracts.client_id = clients.client_id)) AS orders_count
   FROM public.clients;
 ,   DROP VIEW public.count_of_orders_by_client;
       public       v       postgres    false    226    222    222            �            1259    42448    top_clients_view    VIEW     y   CREATE VIEW public.top_clients_view AS
 SELECT client_id,
    full_name
   FROM public.clients
  WHERE (client_id <= 2);
 #   DROP VIEW public.top_clients_view;
       public       v       postgres    false    222    222            �            1259    42452    detailed_top_clients_view    VIEW     �  CREATE VIEW public.detailed_top_clients_view AS
 SELECT contracts.contract_id,
    top_clients_view.client_id AS client_id_top,
    contracts.agent_id,
    contracts.resort_id,
    contracts.offer_id,
    contracts.sign_date,
    contracts.rest_start,
    contracts.rest_end
   FROM (public.top_clients_view
     JOIN public.contracts ON ((top_clients_view.client_id = contracts.client_id)));
 ,   DROP VIEW public.detailed_top_clients_view;
       public       v       postgres    false    226    226    226    226    226    226    226    237    226            �            1259    42420    horizontal_view    VIEW     u   CREATE VIEW public.horizontal_view AS
 SELECT client_id,
    full_name,
    email,
    phone
   FROM public.clients;
 "   DROP VIEW public.horizontal_view;
       public       v       postgres    false    222    222    222    222            �            1259    42432 	   mixedview    VIEW     �   CREATE VIEW public.mixedview AS
 SELECT client_id,
    full_name
   FROM public.clients
  WHERE ((email)::text ~~ '%example.com'::text);
    DROP VIEW public.mixedview;
       public       v       postgres    false    222    222    222            �            1259    42314    offers    TABLE     �   CREATE TABLE public.offers (
    offer_id integer NOT NULL,
    resort_id integer NOT NULL,
    cost numeric(10,2) NOT NULL,
    description text
);
    DROP TABLE public.offers;
       public         heap r       postgres    false            �            1259    42313    offers_offer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.offers_offer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.offers_offer_id_seq;
       public               postgres    false    220            N           0    0    offers_offer_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.offers_offer_id_seq OWNED BY public.offers.offer_id;
          public               postgres    false    219            �            1259    42382    photos    TABLE     �   CREATE TABLE public.photos (
    photo_id integer NOT NULL,
    resort_id integer NOT NULL,
    title character varying(255) NOT NULL,
    file_path character varying(255) NOT NULL,
    tags text
);
    DROP TABLE public.photos;
       public         heap r       postgres    false            �            1259    42381    photos_photo_id_seq    SEQUENCE     �   CREATE SEQUENCE public.photos_photo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.photos_photo_id_seq;
       public               postgres    false    228            O           0    0    photos_photo_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.photos_photo_id_seq OWNED BY public.photos.photo_id;
          public               postgres    false    227            �            1259    42303    resorts    TABLE        CREATE TABLE public.resorts (
    resort_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    quality integer,
    country character varying(100) NOT NULL,
    location character varying(255) NOT NULL,
    CONSTRAINT resorts_quality_check CHECK (((quality >= 1) AND (quality <= 5))),
    CONSTRAINT resorts_type_check CHECK (((type)::text = ANY ((ARRAY['mountain-ski'::character varying, 'sea'::character varying, 'other'::character varying])::text[])))
);
    DROP TABLE public.resorts;
       public         heap r       postgres    false            �            1259    42436    resortoffersview    VIEW     �   CREATE VIEW public.resortoffersview AS
 SELECT resorts.name,
    offers.cost
   FROM (public.resorts
     JOIN public.offers ON ((resorts.resort_id = offers.resort_id)));
 #   DROP VIEW public.resortoffersview;
       public       v       postgres    false    218    220    220    218            �            1259    42302    resorts_resort_id_seq    SEQUENCE     �   CREATE SEQUENCE public.resorts_resort_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.resorts_resort_id_seq;
       public               postgres    false    218            P           0    0    resorts_resort_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.resorts_resort_id_seq OWNED BY public.resorts.resort_id;
          public               postgres    false    217            �            1259    42444 
   union_view    VIEW     �   CREATE VIEW public.union_view AS
 SELECT clients.full_name,
    clients.email
   FROM public.clients
UNION
 SELECT 'For_example'::character varying AS full_name,
    'for_example@example.com'::character varying AS email;
    DROP VIEW public.union_view;
       public       v       postgres    false    222    222            �            1259    42424    vertical_view    VIEW     Y   CREATE VIEW public.vertical_view AS
 SELECT full_name,
    email
   FROM public.clients;
     DROP VIEW public.vertical_view;
       public       v       postgres    false    222    222            q           2604    42345    agents agent_id    DEFAULT     r   ALTER TABLE ONLY public.agents ALTER COLUMN agent_id SET DEFAULT nextval('public.agents_agent_id_seq'::regclass);
 >   ALTER TABLE public.agents ALTER COLUMN agent_id DROP DEFAULT;
       public               postgres    false    224    223    224            o           2604    42331    clients client_id    DEFAULT     v   ALTER TABLE ONLY public.clients ALTER COLUMN client_id SET DEFAULT nextval('public.clients_client_id_seq'::regclass);
 @   ALTER TABLE public.clients ALTER COLUMN client_id DROP DEFAULT;
       public               postgres    false    221    222    222            t           2604    42399    comments comment_id    DEFAULT     z   ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);
 B   ALTER TABLE public.comments ALTER COLUMN comment_id DROP DEFAULT;
       public               postgres    false    230    229    230            r           2604    42358    contracts contract_id    DEFAULT     ~   ALTER TABLE ONLY public.contracts ALTER COLUMN contract_id SET DEFAULT nextval('public.contracts_contract_id_seq'::regclass);
 D   ALTER TABLE public.contracts ALTER COLUMN contract_id DROP DEFAULT;
       public               postgres    false    225    226    226            n           2604    42317    offers offer_id    DEFAULT     r   ALTER TABLE ONLY public.offers ALTER COLUMN offer_id SET DEFAULT nextval('public.offers_offer_id_seq'::regclass);
 >   ALTER TABLE public.offers ALTER COLUMN offer_id DROP DEFAULT;
       public               postgres    false    219    220    220            s           2604    42385    photos photo_id    DEFAULT     r   ALTER TABLE ONLY public.photos ALTER COLUMN photo_id SET DEFAULT nextval('public.photos_photo_id_seq'::regclass);
 >   ALTER TABLE public.photos ALTER COLUMN photo_id DROP DEFAULT;
       public               postgres    false    227    228    228            m           2604    42306    resorts resort_id    DEFAULT     v   ALTER TABLE ONLY public.resorts ALTER COLUMN resort_id SET DEFAULT nextval('public.resorts_resort_id_seq'::regclass);
 @   ALTER TABLE public.resorts ALTER COLUMN resort_id DROP DEFAULT;
       public               postgres    false    217    218    218            :          0    42342    agents 
   TABLE DATA           Z   COPY public.agents (agent_id, full_name, email, phone, commission_percentage) FROM stdin;
    public               postgres    false    224   �}       8          0    42328    clients 
   TABLE DATA           Q   COPY public.clients (client_id, full_name, email, phone, created_at) FROM stdin;
    public               postgres    false    222   �~       @          0    42396    comments 
   TABLE DATA           h   COPY public.comments (comment_id, resort_id, photo_id, client_id, comment_text, created_at) FROM stdin;
    public               postgres    false    230   L�       <          0    42355 	   contracts 
   TABLE DATA           {   COPY public.contracts (contract_id, client_id, agent_id, resort_id, offer_id, sign_date, rest_start, rest_end) FROM stdin;
    public               postgres    false    226   i�       6          0    42314    offers 
   TABLE DATA           H   COPY public.offers (offer_id, resort_id, cost, description) FROM stdin;
    public               postgres    false    220   x�       >          0    42382    photos 
   TABLE DATA           M   COPY public.photos (photo_id, resort_id, title, file_path, tags) FROM stdin;
    public               postgres    false    228   s�       4          0    42303    resorts 
   TABLE DATA           T   COPY public.resorts (resort_id, name, type, quality, country, location) FROM stdin;
    public               postgres    false    218   ��       Q           0    0    agents_agent_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.agents_agent_id_seq', 5, true);
          public               postgres    false    223            R           0    0    clients_client_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clients_client_id_seq', 12, true);
          public               postgres    false    221            S           0    0    comments_comment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);
          public               postgres    false    229            T           0    0    contracts_contract_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.contracts_contract_id_seq', 17, true);
          public               postgres    false    225            U           0    0    offers_offer_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.offers_offer_id_seq', 10, true);
          public               postgres    false    219            V           0    0    photos_photo_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.photos_photo_id_seq', 1, false);
          public               postgres    false    227            W           0    0    resorts_resort_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.resorts_resort_id_seq', 10, true);
          public               postgres    false    217            �           2606    42351    agents agents_email_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_email_key UNIQUE (email);
 A   ALTER TABLE ONLY public.agents DROP CONSTRAINT agents_email_key;
       public                 postgres    false    224            �           2606    42353    agents agents_phone_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_phone_key UNIQUE (phone);
 A   ALTER TABLE ONLY public.agents DROP CONSTRAINT agents_phone_key;
       public                 postgres    false    224            �           2606    42349    agents agents_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (agent_id);
 <   ALTER TABLE ONLY public.agents DROP CONSTRAINT agents_pkey;
       public                 postgres    false    224            }           2606    42336    clients clients_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_email_key;
       public                 postgres    false    222                       2606    42338    clients clients_phone_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_phone_key UNIQUE (phone);
 C   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_phone_key;
       public                 postgres    false    222            �           2606    42334    clients clients_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public                 postgres    false    222            �           2606    42404    comments comments_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public                 postgres    false    230            �           2606    42360    contracts contracts_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);
 B   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_pkey;
       public                 postgres    false    226            {           2606    42321    offers offers_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offer_id);
 <   ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
       public                 postgres    false    220            �           2606    42389    photos photos_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (photo_id);
 <   ALTER TABLE ONLY public.photos DROP CONSTRAINT photos_pkey;
       public                 postgres    false    228            y           2606    42312    resorts resorts_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.resorts
    ADD CONSTRAINT resorts_pkey PRIMARY KEY (resort_id);
 >   ALTER TABLE ONLY public.resorts DROP CONSTRAINT resorts_pkey;
       public                 postgres    false    218            �           1259    42339    idx_clients_email    INDEX     F   CREATE INDEX idx_clients_email ON public.clients USING btree (email);
 %   DROP INDEX public.idx_clients_email;
       public                 postgres    false    222            �           1259    42340    idx_clients_phone    INDEX     F   CREATE INDEX idx_clients_phone ON public.clients USING btree (phone);
 %   DROP INDEX public.idx_clients_phone;
       public                 postgres    false    222            �           2606    42410     comments comments_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id);
 J   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_client_id_fkey;
       public               postgres    false    4737    230    222            �           2606    42405    comments comments_photo_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_photo_id_fkey FOREIGN KEY (photo_id) REFERENCES public.photos(photo_id);
 I   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_photo_id_fkey;
       public               postgres    false    4749    228    230            �           2606    42415     comments comments_resort_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_resort_id_fkey FOREIGN KEY (resort_id) REFERENCES public.resorts(resort_id);
 J   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_resort_id_fkey;
       public               postgres    false    218    4729    230            �           2606    42366 !   contracts contracts_agent_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(agent_id);
 K   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_agent_id_fkey;
       public               postgres    false    226    4745    224            �           2606    42361 "   contracts contracts_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id);
 L   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_client_id_fkey;
       public               postgres    false    222    4737    226            �           2606    42376 !   contracts contracts_offer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(offer_id);
 K   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_offer_id_fkey;
       public               postgres    false    226    4731    220            �           2606    42371 "   contracts contracts_resort_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_resort_id_fkey FOREIGN KEY (resort_id) REFERENCES public.resorts(resort_id);
 L   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_resort_id_fkey;
       public               postgres    false    226    218    4729            �           2606    42322    offers offers_resort_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_resort_id_fkey FOREIGN KEY (resort_id) REFERENCES public.resorts(resort_id);
 F   ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_resort_id_fkey;
       public               postgres    false    218    220    4729            �           2606    42390    photos photos_resort_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_resort_id_fkey FOREIGN KEY (resort_id) REFERENCES public.resorts(resort_id);
 F   ALTER TABLE ONLY public.photos DROP CONSTRAINT photos_resort_id_fkey;
       public               postgres    false    228    218    4729            :   �   x�e�;�0����Wt��\6��%j�@۔T�?ߴu���'����9O��S�P�i�>~C7�����r\H��X�AH$�$sIcs���'x��a�f�5�� 8r���X÷.��g�����SVAh�i8�sin��v��qŶ-���h��3�K(���aj�t����9m���^(�ݑ1��_]�      8   �  x�}�Mo�0E�/����V��dE�RѢn�x2O�ŉGIh��cg��Y��E���3���;$��_zp9�9�w������\5�h%g�k��k~�-a��U�
f����o��Bn���0m@�6�p+�Ԫd�p7�<�~A���E/f�ZM
|�;�ӄ8�p&�3�ާ�4��S�c<�ޑ��_0o@.vּV�b;ܫ?��؏sᘉ�����x�g�K��C�B܀�6m�������݀3y�!�{�@���7+�X����_�'��)�<x��ν��E�'����CS���,)}��o���&[�Z��I�O�*5��+y<����n�'d�!�R;�jsF7u�+�z����<n2�M.\\H��mJ�~Ъ����g      @      x������ � �      <   �   x�M���0��]R�٥���c\�(B|�.%U�S����)%w��MA3��HJ��0Լv��r^��H'Ũz���r]���J�u������4��40�e�N*�{�)�5ͺLT�Ă��h+uR��\1�)����G���+���	����L�/ˑ�LlX�W��h����.2����ll`�1�li<��0862[Y�!���b:���H��[��u��pc/cc�@�Mco�+õ�8��4���;�zh      6   �   x�U�;n�0@g������	ЭY��K�b��bH��ܾr�(@��G*P�K)RB��H^������z�rP�V~���?�Sw��g�X@*߀�`���]�<c	%�{���̸�N��,.du�+�@�������dǀ5Ԡv��{�٧7��E����xY~�`�i�x��'�Ђj6�͸�����c�;�GP�F\Y��H��/#�;;F%a�z����h6�~�f����)8b`      >      x������ � �      4   *  x�]��n1E��W��J�>���C�-�P��ƚ�k<�(���MQY������3���lIo�cÁ�s�Fd;
-���㑼�m~�A��ֻ�k�!Lak�O��I-E5��e��{���X��ag8D!���^Z��DG:�f�����9�.#�yt"�t�n�zC؆��)<z�5��`�,�-T�ڬ?(z�x��j}ـ��Uܣ��u:$��*�؟K,P>%����H^�m��\\��=#l�w���ICVW%z����}�ʠ��JF�!n�_�K�u%��p�0ÚE���e_WJ�y,��     