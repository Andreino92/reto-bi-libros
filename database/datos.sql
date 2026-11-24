--
-- PostgreSQL database dump
--

\restrict ndYghLj0HhFaqRnUsxyWsggWEGXwy7hhMPDnrjDcuaTSuKFndwZpdOpoH4ajgGc

-- Dumped from database version 16.16 (Debian 16.16-1.pgdg13+1)
-- Dumped by pg_dump version 16.16 (Debian 16.16-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.decision_libros DROP CONSTRAINT IF EXISTS decision_libros_pkey;
DROP TABLE IF EXISTS public.decision_libros;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: decision_libros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decision_libros (
    escenario text NOT NULL,
    clave text NOT NULL,
    upc text NOT NULL,
    titulo text NOT NULL,
    categoria text,
    precio_gbp numeric(8,2) NOT NULL,
    estrellas smallint NOT NULL,
    stock integer,
    obras_ol integer,
    ediciones_ol integer,
    ratings_total integer,
    ratings_avg_ol double precision,
    ediciones_por_libra numeric(14,6),
    coincide boolean NOT NULL,
    cumple boolean NOT NULL,
    prioridad integer,
    decision text NOT NULL,
    motivo text
);


--
-- Data for Name: decision_libros; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.decision_libros (escenario, clave, upc, titulo, categoria, precio_gbp, estrellas, stock, obras_ol, ediciones_ol, ratings_total, ratings_avg_ol, ediciones_por_libra, coincide, cumple, prioridad, decision, motivo) FROM stdin;
base	light in the attic	a897fe39b1053632	A Light in the Attic	Poetry	51.77	3	22	1	27	0	0	0.521538	t	t	7	comprar	
base	tipping the velvet	90fa61229261140a	Tipping the Velvet	Historical Fiction	53.74	1	20	1	22	13	3.8461537	0.409378	t	f	\N	descartar	estrellas_bajo_umbral
base	soumission	6957f44c3847a760	Soumission	Fiction	50.10	1	20	4	26	15	3.2666667	0.518962	t	f	\N	descartar	estrellas_bajo_umbral
base	sharp objects	e00eb4fd7b871a48	Sharp Objects	Mystery	47.82	4	20	2	36	36	1.9027778	0.752823	t	t	4	comprar	
base	sapiens	4165285e1663650f	Sapiens: A Brief History of Humankind	History	54.23	5	20	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	requiem red	f77dbf2323deb740	The Requiem Red	Young Adult	22.65	1	19	1	2	0	0	0.088300	t	f	\N	descartar	estrellas_bajo_umbral
base	dirty little secrets of getting your dream job	2597b5a345f45e1b	The Dirty Little Secrets of Getting Your Dream Job	Business	33.34	4	19	1	2	0	\N	0.059988	t	f	\N	descartar	ediciones_bajo_umbral
base	coming woman	e72a5dfc7e9267b2	The Coming Woman: A Novel Based on the Life of the Infamous Feminist, Victoria Woodhull	Default	17.93	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	boys in the boat	e10e1e165dc8be4a	The Boys in the Boat: Nine Americans and Their Epic Quest for Gold at the 1936 Berlin Olympics	Default	22.60	4	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	black maria	1dfe412b8ac00530	The Black Maria	Poetry	52.15	1	19	4	4	1	2	0.076702	t	f	\N	descartar	estrellas_bajo_umbral
base	starving hearts	0312262ecafa5a40	Starving Hearts (Triangular Trade Trilogy, #1)	Default	13.99	2	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	shakespeares sonnets	30a7f60cd76ca58c	Shakespeare's Sonnets	Poetry	20.66	4	19	5	22	0	0	1.064860	t	t	2	comprar	
base	set me free	ce6396b0f23f6ecc	Set Me Free	Young Adult	17.46	5	19	7	15	1	1	0.859107	t	t	3	comprar	
base	scott pilgrims precious little life	3b1c02bac2a429e6	Scott Pilgrim's Precious Little Life (Scott Pilgrim #1)	Sequential Art	52.29	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	rip it up and start again	a34ba96d4081e6a4	Rip it Up and Start Again	Music	35.02	5	19	6	10	3	3.6666666666666665	0.285551	t	t	10	comprar	
base	our band could be your life	deda3e61b9514b83	Our Band Could Be Your Life: Scenes from the American Indie Underground, 1981-1991	Music	57.25	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	olio	feb7cc7701ecf901	Olio	Poetry	23.88	1	19	6	15	0	\N	0.628141	t	f	\N	descartar	estrellas_bajo_umbral
base	mesaerion	e30f54cea9b38190	Mesaerion: The Best Science Fiction Stories 1800-1849	Science Fiction	37.59	1	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	libertarianism for beginners	a18a4f574854aced	Libertarianism for Beginners	Politics	51.33	2	19	1	1	0	\N	0.019482	t	f	\N	descartar	estrellas_bajo_umbral
base	its only the himalayas	a22124811bfa8350	It's Only the Himalayas	Travel	45.17	2	19	1	1	0	\N	0.022139	t	f	\N	descartar	estrellas_bajo_umbral
base	in her wake	23356462d1320d61	In Her Wake	Thriller	12.84	1	19	8	14	0	0	1.090343	t	f	\N	descartar	estrellas_bajo_umbral
base	how music works	327f68a59745c102	How Music Works	Music	37.32	2	19	6	22	19	3.6041666666666665	0.589496	t	f	\N	descartar	estrellas_bajo_umbral
base	foolproof preserving	5674a18a29a43ced	Foolproof Preserving: A Guide to Small Batch Jams, Jellies, Pickles, Condiments, and More: A Foolproof Guide to Making Small Batch Jams, Jellies, Pickles, Condiments, and More	Food and Drink	30.52	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	chase me	c2e46a2ee3b4a322	Chase Me (Paris Nights #2)	Romance	25.27	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	black dust	00bfed9e18bb36f3	Black Dust	Romance	34.53	5	19	5	6	0	0	0.173762	t	t	13	lista_espera	
base	birdsong	9528d0948525bf5f	Birdsong: A Story in Pictures	Childrens	54.64	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	americas cradle of quarterbacks	c7d160c2c0de586f	America's Cradle of Quarterbacks: Western Pennsylvania's Football Factory from Johnny Unitas to Joe Montana	Default	22.50	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	aladdin and his wonderful lamp	904208d6aa64b655	Aladdin and His Wonderful Lamp	Default	53.13	3	19	5	5	0	\N	0.094109	t	t	16	lista_espera	
base	worlds elsewhere	4c28def39d850cdf	Worlds Elsewhere: Journeys Around Shakespeare’s Globe	Nonfiction	40.30	5	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	wall and piece	ccd9ffa25efabdea	Wall and Piece	Art	44.18	4	18	3	10	4	2.125	0.226347	t	t	12	lista_espera	
base	four agreements	6258a1f6a6dcfe50	The Four Agreements: A Practical Guide to Personal Freedom	Spirituality	17.66	5	18	1	1	1	3	0.056625	t	f	\N	descartar	ediciones_bajo_umbral
base	five love languages	3c039985229453bf	The Five Love Languages: How to Express Heartfelt Commitment to Your Mate	Nonfiction	31.05	3	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	elephant tree	5dada2b7be26bd03	The Elephant Tree	Thriller	23.82	5	18	3	7	1	4	0.293871	t	t	9	comprar	
base	bear and the piano	9f6568e9c95f60b0	The Bear and the Piano	Childrens	36.89	1	18	3	6	1	5	0.162646	t	f	\N	descartar	estrellas_bajo_umbral
base	sophies world	6be3beb0793a53e7	Sophie's World	Philosophy	15.94	5	18	7	8	8	4.375	0.501882	t	t	8	comprar	
base	penny maybe	668fe56b17cfcd4f	Penny Maybe	Default	33.29	3	18	1	5	0	\N	0.150195	t	t	14	lista_espera	
base	maude	094b269567e1c300	Maude (1883-1993):She Grew Up with the country	Default	18.02	2	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	in a dark dark wood	19ed25f4641d5efd	In a Dark, Dark Wood	Mystery	19.63	1	18	10	30	19	1.1403509	1.528273	t	f	\N	descartar	estrellas_bajo_umbral
base	behind closed doors	be5cc846f45496fb	Behind Closed Doors	Thriller	52.22	4	18	8	39	32	3.4126984	0.746840	t	t	5	comprar	
base	you cant bury them all	55f9da0c5eea2e10	You can't bury them all: Poems	Poetry	33.63	2	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	slow states of collapse	b4fd5943413e089a	Slow States of Collapse: Poems	Poetry	57.31	3	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	reasons to stay alive	c8f7f0cb1abb9cac	Reasons to Stay Alive	Nonfiction	26.41	2	17	2	10	19	4	0.378644	t	f	\N	descartar	estrellas_bajo_umbral
base	private paris	b12b89017878a60d	Private Paris (Private #10)	Fiction	47.61	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	higherselfie	c27f6e1f185b0383	#HigherSelfie: Wake Up Your Life. Free Your Soul. Find Your Tribe.	Nonfiction	23.11	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	without borders	acddfeab2a407640	Without Borders (Wanderlove #1)	New Adult	45.07	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	when we collided	3ecb690d1542c568	When We Collided	Contemporary	31.77	1	16	1	7	1	4	0.220334	t	f	\N	descartar	estrellas_bajo_umbral
base	we love you charlie freeman	8d455c7539795d2a	We Love You, Charlie Freeman	Fiction	50.27	5	16	1	4	0	\N	0.079570	t	f	\N	descartar	ediciones_bajo_umbral
base	untitled collection	657fe5ead67a7767	Untitled Collection: Sabbath Poems 2014	Poetry	14.27	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	unseen city	d170b5a0da46380e	Unseen City: The Majesty of Pigeons, the Discreet Charm of Snails & Other Wonders of the Urban Wilderness	Nonfiction	44.18	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	unicorn tracks	7ae099f3898e0209	Unicorn Tracks	Fantasy	18.78	3	16	1	3	0	0	0.159744	t	f	\N	descartar	ediciones_bajo_umbral
base	unbound	9a9d6e9bc555731e	Unbound: How Eight Technologies Made Us Human, Transformed Society, and Brought Our World to the Brink	History	25.52	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	tsubasa	09555be379ad9253	Tsubasa: WoRLD CHRoNiCLE 2 (Tsubasa WoRLD CHRoNiCLE #2)	Sequential Art	16.28	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	throwing rocks at the google bus	7858914fad68493c	Throwing Rocks at the Google Bus: How Growth Became the Enemy of Prosperity	Nonfiction	31.12	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	this one summer	51653ef291ab7ddc	This One Summer	Sequential Art	19.49	4	16	2	5	13	4	0.256542	t	t	11	lista_espera	
base	thirst	709822d0b5bcb7f4	Thirst	Fiction	17.27	5	16	3	11	3	3.3333333333333335	0.636943	t	t	6	comprar	
base	torch is passed	4eed62cf5f8d8edf	The Torch Is Passed: A Harding Family Story	Add a comment	19.09	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	secret of dreadwillow carse	b5ea0b5dabed25a8	The Secret of Dreadwillow Carse	Childrens	56.13	1	16	1	6	1	4	0.106895	t	f	\N	descartar	estrellas_bajo_umbral
base	pioneer woman cooks	142d767a56a9254d	The Pioneer Woman Cooks: Dinnertime: Comfort Classics, Freezer Food, 16-Minute Meals, and Other Delicious Ways to Solve Supper!	Food and Drink	56.41	1	16	1	1	0	\N	0.017727	t	f	\N	descartar	estrellas_bajo_umbral
base	past never ends	5ee94540d0749ea0	The Past Never Ends	Mystery	56.50	4	16	1	2	0	\N	0.035398	t	f	\N	descartar	ediciones_bajo_umbral
base	natural history of us	cedf82b5086e4691	The Natural History of Us (The Fine Art of Pretending #2)	Young Adult	45.22	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	nameless city	7d385d34d12e60ff	The Nameless City (The Nameless City #1)	Sequential Art	38.16	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	murder that never was	d01ac97e2b8947c2	The Murder That Never Was (Forensic Instincts #5)	Fiction	54.11	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	most perfect thing	aadee1c326d286e3	The Most Perfect Thing: Inside (and Outside) a Bird's Egg	Science	42.96	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	mindfulness and acceptance workbook for anxiety	31075275518532d7	The Mindfulness and Acceptance Workbook for Anxiety: A Guide to Breaking Free from Anxiety, Phobias, and Worry Using Acceptance and Commitment Therapy	Add a comment	23.89	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	life changing magic of tidying up	0da9aa9d24677fc0	The Life-Changing Magic of Tidying Up: The Japanese Art of Decluttering and Organizing	Nonfiction	16.77	3	16	2	2	0	\N	0.119261	t	f	\N	descartar	ediciones_bajo_umbral
base	inefficiency assassin	8c9e6bf2467d740d	The Inefficiency Assassin: Time Management Tactics for Working Smarter, Not Longer	Default	20.59	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	gutsy girl	acd86a5426e21ca0	The Gutsy Girl: Escapades for Your Life of Epic Adventure	Nonfiction	37.13	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	electric pencil	a30b270e25489e5c	The Electric Pencil: Drawings from Inside State Hospital No. 3	Nonfiction	56.06	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	death of humanity	bd261725b99f5983	The Death of Humanity: and the Case for Life	Philosophy	58.11	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	bulletproof diet	43c6a960757cf559	The Bulletproof Diet: Lose up to a Pound a Day, Reclaim Energy and Focus, Upgrade Your Life	Health	49.05	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	art forger	80cfab6bcff3a244	The Art Forger	Add a comment	40.76	3	16	5	6	4	2	0.147203	t	t	15	lista_espera	
base	age of genius	a3d2a4250807f1e9	The Age of Genius: The Seventeenth Century and the Birth of the Modern Mind	History	19.73	1	16	1	1	0	\N	0.050684	t	f	\N	descartar	estrellas_bajo_umbral
base	activists tao te ching	7d6d2a6c0276f81b	The Activist's Tao Te Ching: Ancient Advice for a Modern Revolution	Spirituality	32.24	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	spark joy	87b0615b6e1f4d7b	Spark Joy: An Illustrated Master Class on the Art of Organizing and Tidying Up	Nonfiction	41.83	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	soul reader	e6af5bf1163c1151	Soul Reader	Default	39.58	2	16	4	8	0	0	0.202122	t	f	\N	descartar	estrellas_bajo_umbral
base	security	6f78a0d744c35456	Security	Horror	39.25	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	saga volume 6	c849f0b2f5d6a742	Saga, Volume 6 (Saga (Collected Editions) #6)	Fantasy	25.02	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	saga volume 5	53a3d11bb568cc8b	Saga, Volume 5 (Saga (Collected Editions) #5)	Sequential Art	51.04	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	reskilling america	d7310206583a54b6	Reskilling America: Learning to Labor in the Twenty-First Century	Nonfiction	19.83	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	rat queens vol 3	c82a3e358c773c73	Rat Queens, Vol. 3: Demons (Rat Queens (Collected Editions) #11-15)	Sequential Art	50.40	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	princess jellyfish 2 in 1 omnibus vol 01	0fa6dceead7ce47a	Princess Jellyfish 2-in-1 Omnibus, Vol. 01 (Princess Jellyfish 2-in-1 Omnibus #1)	Sequential Art	13.61	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	princess between worlds	0e691eda369f4e09	Princess Between Worlds (Wide-Awake Princess #5)	Fantasy	13.34	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	pop gun war volume 1	e80f8e518b300dfe	Pop Gun War, Volume 1: Gift	Sequential Art	18.97	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	political suicide	7392c0032f92d816	Political Suicide: Missteps, Peccadilloes, Bad Calls, Backroom Hijinx, Sordid Pasts, Rotten Breaks, and Just Plain Dumb Mistakes in the Annals of American Politics	History	36.28	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	patience	9429b4d59c537af5	Patience	Sequential Art	10.16	3	16	4	57	4	4.75	5.610236	t	t	1	comprar	
base	outcast vol 1	889139b8e9c4cb36	Outcast, Vol. 1: A Darkness Surrounds Him (Outcast #1)	Sequential Art	15.44	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	orange	11809b1d323b3057	orange: The Complete Collection 1 (orange: The Complete Collection #1)	Sequential Art	48.41	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	online marketing for busy authors	9ffa38d3b832433a	Online Marketing for Busy Authors: A Step-By-Step Guide	Self Help	46.35	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	on a midnight clear	b757c0c361e689ce	On a Midnight Clear	Add a comment	14.07	3	16	1	1	0	0	0.071073	t	f	\N	descartar	ediciones_bajo_umbral
base	obsidian	3c346ab1e76ae1f6	Obsidian (Lux #1)	Young Adult	14.86	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	my paris kitchen	784bc2279baa878d	My Paris Kitchen: Recipes and Stories	Food and Drink	33.37	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	masks and shadows	fa9610a50a1bf149	Masks and Shadows	Fantasy	56.40	2	16	2	4	0	0	0.070922	t	f	\N	descartar	estrellas_bajo_umbral
base	mama tried	72f9d5be3472d34e	Mama Tried: Traditional Italian Cooking for the Screwed, Crude, Vegan, and Tattooed	Food and Drink	14.02	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	lumberjanes vol 2	460089f796fb3f82	Lumberjanes, Vol. 2: Friendship to the Max (Lumberjanes #5-8)	Sequential Art	46.91	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	lumberjanes vol 1	b6ee99bcf06fc91f	Lumberjanes, Vol. 1: Beware the Kitten Holy (Lumberjanes #1-4)	Sequential Art	45.61	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	lumberjanes vol 3	57e5a4d515c8ce44	Lumberjanes Vol. 3: A Terrible Plan (Lumberjanes #9-12)	Sequential Art	19.92	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	layered	7b75cc7f223791f4	Layered: Baking, Building, and Styling Spectacular Cakes	Food and Drink	40.11	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	judo	228f74b74f3a08ae	Judo: Seven Steps to Black Belt (an Introductory Guide for Beginners)	Add a comment	53.90	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
base	join	18ad3ed896c7ce05	Join	Science Fiction	35.67	5	16	1	1	1	5	0.028035	t	f	\N	descartar	ediciones_bajo_umbral
base	in the country we love	b136b1b180ca753a	In the Country We Love: My Family Divided	Nonfiction	22.00	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	light in the attic	a897fe39b1053632	A Light in the Attic	Poetry	51.77	3	22	1	27	0	0	0.521538	t	t	6	comprar	
esc_cambia_decision	tipping the velvet	90fa61229261140a	Tipping the Velvet	Historical Fiction	53.74	1	20	1	22	13	3.8461537	0.409378	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	soumission	6957f44c3847a760	Soumission	Fiction	50.10	1	20	4	26	15	3.2666667	0.518962	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	sharp objects	e00eb4fd7b871a48	Sharp Objects	Mystery	47.82	4	20	2	36	36	1.9027778	0.752823	t	t	3	comprar	
esc_cambia_decision	sapiens	4165285e1663650f	Sapiens: A Brief History of Humankind	History	54.23	5	20	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	requiem red	f77dbf2323deb740	The Requiem Red	Young Adult	22.65	1	19	1	2	0	0	0.088300	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	dirty little secrets of getting your dream job	2597b5a345f45e1b	The Dirty Little Secrets of Getting Your Dream Job	Business	33.34	4	19	1	2	0	\N	0.059988	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	coming woman	e72a5dfc7e9267b2	The Coming Woman: A Novel Based on the Life of the Infamous Feminist, Victoria Woodhull	Default	17.93	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	black dust	00bfed9e18bb36f3	Black Dust	Romance	34.53	5	19	5	6	0	0	0.173762	t	t	13	lista_espera	
esc_cambia_decision	boys in the boat	e10e1e165dc8be4a	The Boys in the Boat: Nine Americans and Their Epic Quest for Gold at the 1936 Berlin Olympics	Default	22.60	4	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	black maria	1dfe412b8ac00530	The Black Maria	Poetry	52.15	1	19	4	4	1	2	0.076702	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	starving hearts	0312262ecafa5a40	Starving Hearts (Triangular Trade Trilogy, #1)	Default	13.99	2	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	shakespeares sonnets	30a7f60cd76ca58c	Shakespeare's Sonnets	Poetry	20.66	4	19	5	22	0	0	1.064860	t	t	1	comprar	
esc_cambia_decision	set me free	ce6396b0f23f6ecc	Set Me Free	Young Adult	17.46	5	19	7	15	1	1	0.859107	t	t	2	comprar	
esc_cambia_decision	scott pilgrims precious little life	3b1c02bac2a429e6	Scott Pilgrim's Precious Little Life (Scott Pilgrim #1)	Sequential Art	52.29	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	rip it up and start again	a34ba96d4081e6a4	Rip it Up and Start Again	Music	35.02	5	19	6	10	3	3.6666666666666665	0.285551	t	t	9	comprar	
esc_cambia_decision	our band could be your life	deda3e61b9514b83	Our Band Could Be Your Life: Scenes from the American Indie Underground, 1981-1991	Music	57.25	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	olio	feb7cc7701ecf901	Olio	Poetry	23.88	1	19	6	15	0	\N	0.628141	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	mesaerion	e30f54cea9b38190	Mesaerion: The Best Science Fiction Stories 1800-1849	Science Fiction	37.59	1	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	libertarianism for beginners	a18a4f574854aced	Libertarianism for Beginners	Politics	51.33	2	19	1	1	0	\N	0.019482	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	its only the himalayas	a22124811bfa8350	It's Only the Himalayas	Travel	45.17	2	19	1	1	0	\N	0.022139	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	in her wake	23356462d1320d61	In Her Wake	Thriller	12.84	1	19	8	14	0	0	1.090343	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	how music works	327f68a59745c102	How Music Works	Music	37.32	2	19	6	22	19	3.6041666666666665	0.589496	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	foolproof preserving	5674a18a29a43ced	Foolproof Preserving: A Guide to Small Batch Jams, Jellies, Pickles, Condiments, and More: A Foolproof Guide to Making Small Batch Jams, Jellies, Pickles, Condiments, and More	Food and Drink	30.52	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	chase me	c2e46a2ee3b4a322	Chase Me (Paris Nights #2)	Romance	25.27	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	black dust	00bfed9e18bb36f3	Black Dust	Romance	34.53	5	19	5	6	0	0	0.173762	t	t	12	lista_espera	
esc_cambia_decision	birdsong	9528d0948525bf5f	Birdsong: A Story in Pictures	Childrens	54.64	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	americas cradle of quarterbacks	c7d160c2c0de586f	America's Cradle of Quarterbacks: Western Pennsylvania's Football Factory from Johnny Unitas to Joe Montana	Default	22.50	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	aladdin and his wonderful lamp	904208d6aa64b655	Aladdin and His Wonderful Lamp	Default	53.13	3	19	5	5	0	\N	0.094109	t	t	16	lista_espera	
esc_cambia_decision	worlds elsewhere	4c28def39d850cdf	Worlds Elsewhere: Journeys Around Shakespeare’s Globe	Nonfiction	40.30	5	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	wall and piece	ccd9ffa25efabdea	Wall and Piece	Art	44.18	4	18	3	10	4	2.125	0.226347	t	t	11	lista_espera	
esc_cambia_decision	four agreements	6258a1f6a6dcfe50	The Four Agreements: A Practical Guide to Personal Freedom	Spirituality	17.66	5	18	1	1	1	3	0.056625	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	five love languages	3c039985229453bf	The Five Love Languages: How to Express Heartfelt Commitment to Your Mate	Nonfiction	31.05	3	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	elephant tree	5dada2b7be26bd03	The Elephant Tree	Thriller	23.82	5	18	3	7	1	4	0.293871	t	t	8	comprar	
esc_cambia_decision	bear and the piano	9f6568e9c95f60b0	The Bear and the Piano	Childrens	36.89	1	18	3	6	1	5	0.162646	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	sophies world	6be3beb0793a53e7	Sophie's World	Philosophy	15.94	5	18	7	8	8	4.375	0.501882	t	t	7	comprar	
esc_cambia_decision	penny maybe	668fe56b17cfcd4f	Penny Maybe	Default	33.29	3	18	1	5	0	\N	0.150195	t	t	13	lista_espera	
esc_cambia_decision	maude	094b269567e1c300	Maude (1883-1993):She Grew Up with the country	Default	18.02	2	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	in a dark dark wood	19ed25f4641d5efd	In a Dark, Dark Wood	Mystery	19.63	1	18	10	30	19	1.1403509	1.528273	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	behind closed doors	be5cc846f45496fb	Behind Closed Doors	Thriller	52.22	4	18	8	39	32	3.4126984	0.746840	t	t	4	comprar	
esc_cambia_decision	you cant bury them all	55f9da0c5eea2e10	You can't bury them all: Poems	Poetry	33.63	2	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	slow states of collapse	b4fd5943413e089a	Slow States of Collapse: Poems	Poetry	57.31	3	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	reasons to stay alive	c8f7f0cb1abb9cac	Reasons to Stay Alive	Nonfiction	26.41	2	17	2	10	19	4	0.378644	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	private paris	b12b89017878a60d	Private Paris (Private #10)	Fiction	47.61	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	higherselfie	c27f6e1f185b0383	#HigherSelfie: Wake Up Your Life. Free Your Soul. Find Your Tribe.	Nonfiction	23.11	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	without borders	acddfeab2a407640	Without Borders (Wanderlove #1)	New Adult	45.07	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	when we collided	3ecb690d1542c568	When We Collided	Contemporary	31.77	1	16	1	7	1	4	0.220334	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	we love you charlie freeman	8d455c7539795d2a	We Love You, Charlie Freeman	Fiction	50.27	5	16	1	4	0	\N	0.079570	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	untitled collection	657fe5ead67a7767	Untitled Collection: Sabbath Poems 2014	Poetry	14.27	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	unseen city	d170b5a0da46380e	Unseen City: The Majesty of Pigeons, the Discreet Charm of Snails & Other Wonders of the Urban Wilderness	Nonfiction	44.18	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	unicorn tracks	7ae099f3898e0209	Unicorn Tracks	Fantasy	18.78	3	16	1	3	0	0	0.159744	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	unbound	9a9d6e9bc555731e	Unbound: How Eight Technologies Made Us Human, Transformed Society, and Brought Our World to the Brink	History	25.52	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	tsubasa	09555be379ad9253	Tsubasa: WoRLD CHRoNiCLE 2 (Tsubasa WoRLD CHRoNiCLE #2)	Sequential Art	16.28	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	throwing rocks at the google bus	7858914fad68493c	Throwing Rocks at the Google Bus: How Growth Became the Enemy of Prosperity	Nonfiction	31.12	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	this one summer	51653ef291ab7ddc	This One Summer	Sequential Art	19.49	4	16	2	5	13	4	0.256542	t	t	10	comprar	
esc_cambia_decision	thirst	709822d0b5bcb7f4	Thirst	Fiction	17.27	5	16	3	11	3	3.3333333333333335	0.636943	t	t	5	comprar	
esc_cambia_decision	torch is passed	4eed62cf5f8d8edf	The Torch Is Passed: A Harding Family Story	Add a comment	19.09	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	secret of dreadwillow carse	b5ea0b5dabed25a8	The Secret of Dreadwillow Carse	Childrens	56.13	1	16	1	6	1	4	0.106895	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	pioneer woman cooks	142d767a56a9254d	The Pioneer Woman Cooks: Dinnertime: Comfort Classics, Freezer Food, 16-Minute Meals, and Other Delicious Ways to Solve Supper!	Food and Drink	56.41	1	16	1	1	0	\N	0.017727	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	past never ends	5ee94540d0749ea0	The Past Never Ends	Mystery	56.50	4	16	1	2	0	\N	0.035398	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	natural history of us	cedf82b5086e4691	The Natural History of Us (The Fine Art of Pretending #2)	Young Adult	45.22	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	nameless city	7d385d34d12e60ff	The Nameless City (The Nameless City #1)	Sequential Art	38.16	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	murder that never was	d01ac97e2b8947c2	The Murder That Never Was (Forensic Instincts #5)	Fiction	54.11	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	most perfect thing	aadee1c326d286e3	The Most Perfect Thing: Inside (and Outside) a Bird's Egg	Science	42.96	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	mindfulness and acceptance workbook for anxiety	31075275518532d7	The Mindfulness and Acceptance Workbook for Anxiety: A Guide to Breaking Free from Anxiety, Phobias, and Worry Using Acceptance and Commitment Therapy	Add a comment	23.89	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	life changing magic of tidying up	0da9aa9d24677fc0	The Life-Changing Magic of Tidying Up: The Japanese Art of Decluttering and Organizing	Nonfiction	16.77	3	16	2	2	0	\N	0.119261	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	inefficiency assassin	8c9e6bf2467d740d	The Inefficiency Assassin: Time Management Tactics for Working Smarter, Not Longer	Default	20.59	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	gutsy girl	acd86a5426e21ca0	The Gutsy Girl: Escapades for Your Life of Epic Adventure	Nonfiction	37.13	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	electric pencil	a30b270e25489e5c	The Electric Pencil: Drawings from Inside State Hospital No. 3	Nonfiction	56.06	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	death of humanity	bd261725b99f5983	The Death of Humanity: and the Case for Life	Philosophy	58.11	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	bulletproof diet	43c6a960757cf559	The Bulletproof Diet: Lose up to a Pound a Day, Reclaim Energy and Focus, Upgrade Your Life	Health	49.05	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	art forger	80cfab6bcff3a244	The Art Forger	Add a comment	40.76	3	16	5	6	4	2	0.147203	t	t	14	lista_espera	
esc_cambia_decision	age of genius	a3d2a4250807f1e9	The Age of Genius: The Seventeenth Century and the Birth of the Modern Mind	History	19.73	1	16	1	1	0	\N	0.050684	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	activists tao te ching	7d6d2a6c0276f81b	The Activist's Tao Te Ching: Ancient Advice for a Modern Revolution	Spirituality	32.24	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	spark joy	87b0615b6e1f4d7b	Spark Joy: An Illustrated Master Class on the Art of Organizing and Tidying Up	Nonfiction	41.83	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	soul reader	e6af5bf1163c1151	Soul Reader	Default	39.58	2	16	4	8	0	0	0.202122	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	security	6f78a0d744c35456	Security	Horror	39.25	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	saga volume 6	c849f0b2f5d6a742	Saga, Volume 6 (Saga (Collected Editions) #6)	Fantasy	25.02	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	saga volume 5	53a3d11bb568cc8b	Saga, Volume 5 (Saga (Collected Editions) #5)	Sequential Art	51.04	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	reskilling america	d7310206583a54b6	Reskilling America: Learning to Labor in the Twenty-First Century	Nonfiction	19.83	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	rat queens vol 3	c82a3e358c773c73	Rat Queens, Vol. 3: Demons (Rat Queens (Collected Editions) #11-15)	Sequential Art	50.40	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	princess jellyfish 2 in 1 omnibus vol 01	0fa6dceead7ce47a	Princess Jellyfish 2-in-1 Omnibus, Vol. 01 (Princess Jellyfish 2-in-1 Omnibus #1)	Sequential Art	13.61	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	princess between worlds	0e691eda369f4e09	Princess Between Worlds (Wide-Awake Princess #5)	Fantasy	13.34	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	pop gun war volume 1	e80f8e518b300dfe	Pop Gun War, Volume 1: Gift	Sequential Art	18.97	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	chase me	c2e46a2ee3b4a322	Chase Me (Paris Nights #2)	Romance	25.27	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	political suicide	7392c0032f92d816	Political Suicide: Missteps, Peccadilloes, Bad Calls, Backroom Hijinx, Sordid Pasts, Rotten Breaks, and Just Plain Dumb Mistakes in the Annals of American Politics	History	36.28	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	patience	9429b4d59c537af5	Patience	Sequential Art	457.20	3	16	4	57	4	4.75	0.124672	t	t	15	lista_espera	
esc_cambia_decision	outcast vol 1	889139b8e9c4cb36	Outcast, Vol. 1: A Darkness Surrounds Him (Outcast #1)	Sequential Art	15.44	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	orange	11809b1d323b3057	orange: The Complete Collection 1 (orange: The Complete Collection #1)	Sequential Art	48.41	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	online marketing for busy authors	9ffa38d3b832433a	Online Marketing for Busy Authors: A Step-By-Step Guide	Self Help	46.35	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	on a midnight clear	b757c0c361e689ce	On a Midnight Clear	Add a comment	14.07	3	16	1	1	0	0	0.071073	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	obsidian	3c346ab1e76ae1f6	Obsidian (Lux #1)	Young Adult	14.86	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	my paris kitchen	784bc2279baa878d	My Paris Kitchen: Recipes and Stories	Food and Drink	33.37	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	masks and shadows	fa9610a50a1bf149	Masks and Shadows	Fantasy	56.40	2	16	2	4	0	0	0.070922	t	f	\N	descartar	estrellas_bajo_umbral
esc_cambia_decision	mama tried	72f9d5be3472d34e	Mama Tried: Traditional Italian Cooking for the Screwed, Crude, Vegan, and Tattooed	Food and Drink	14.02	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	lumberjanes vol 2	460089f796fb3f82	Lumberjanes, Vol. 2: Friendship to the Max (Lumberjanes #5-8)	Sequential Art	46.91	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	lumberjanes vol 1	b6ee99bcf06fc91f	Lumberjanes, Vol. 1: Beware the Kitten Holy (Lumberjanes #1-4)	Sequential Art	45.61	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	lumberjanes vol 3	57e5a4d515c8ce44	Lumberjanes Vol. 3: A Terrible Plan (Lumberjanes #9-12)	Sequential Art	19.92	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	layered	7b75cc7f223791f4	Layered: Baking, Building, and Styling Spectacular Cakes	Food and Drink	40.11	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	judo	228f74b74f3a08ae	Judo: Seven Steps to Black Belt (an Introductory Guide for Beginners)	Add a comment	53.90	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_cambia_decision	join	18ad3ed896c7ce05	Join	Science Fiction	35.67	5	16	1	1	1	5	0.028035	t	f	\N	descartar	ediciones_bajo_umbral
esc_cambia_decision	in the country we love	b136b1b180ca753a	In the Country We Love: My Family Divided	Nonfiction	22.00	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	light in the attic	a897fe39b1053632	A Light in the Attic	Poetry	51.77	3	22	1	27	0	0	0.521538	t	t	7	comprar	
esc_duplicado	tipping the velvet	90fa61229261140a	Tipping the Velvet	Historical Fiction	53.74	1	20	1	22	13	3.8461537	0.409378	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	soumission	6957f44c3847a760	Soumission	Fiction	50.10	1	20	4	26	15	3.2666667	0.518962	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	sharp objects	e00eb4fd7b871a48	Sharp Objects	Mystery	47.82	4	20	2	36	36	1.9027778	0.752823	t	t	4	comprar	
esc_duplicado	sapiens	4165285e1663650f	Sapiens: A Brief History of Humankind	History	54.23	5	20	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	requiem red	f77dbf2323deb740	The Requiem Red	Young Adult	22.65	1	19	1	2	0	0	0.088300	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	dirty little secrets of getting your dream job	2597b5a345f45e1b	The Dirty Little Secrets of Getting Your Dream Job	Business	33.34	4	19	1	2	0	\N	0.059988	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	coming woman	e72a5dfc7e9267b2	The Coming Woman: A Novel Based on the Life of the Infamous Feminist, Victoria Woodhull	Default	17.93	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	boys in the boat	e10e1e165dc8be4a	The Boys in the Boat: Nine Americans and Their Epic Quest for Gold at the 1936 Berlin Olympics	Default	22.60	4	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	black maria	1dfe412b8ac00530	The Black Maria	Poetry	52.15	1	19	4	4	1	2	0.076702	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	starving hearts	0312262ecafa5a40	Starving Hearts (Triangular Trade Trilogy, #1)	Default	13.99	2	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	shakespeares sonnets	30a7f60cd76ca58c	Shakespeare's Sonnets	Poetry	20.66	4	19	5	22	0	0	1.064860	t	t	2	comprar	
esc_duplicado	set me free	ce6396b0f23f6ecc	Set Me Free	Young Adult	17.46	5	19	7	15	1	1	0.859107	t	t	3	comprar	
esc_duplicado	scott pilgrims precious little life	3b1c02bac2a429e6	Scott Pilgrim's Precious Little Life (Scott Pilgrim #1)	Sequential Art	52.29	5	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	rip it up and start again	a34ba96d4081e6a4	Rip it Up and Start Again	Music	35.02	5	19	6	10	3	3.6666666666666665	0.285551	t	t	10	comprar	
esc_duplicado	our band could be your life	deda3e61b9514b83	Our Band Could Be Your Life: Scenes from the American Indie Underground, 1981-1991	Music	57.25	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	olio	feb7cc7701ecf901	Olio	Poetry	23.88	1	19	6	15	0	\N	0.628141	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	mesaerion	e30f54cea9b38190	Mesaerion: The Best Science Fiction Stories 1800-1849	Science Fiction	37.59	1	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	libertarianism for beginners	a18a4f574854aced	Libertarianism for Beginners	Politics	51.33	2	19	1	1	0	\N	0.019482	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	its only the himalayas	a22124811bfa8350	It's Only the Himalayas	Travel	45.17	2	19	1	1	0	\N	0.022139	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	in her wake	23356462d1320d61	In Her Wake	Thriller	12.84	1	19	8	14	0	0	1.090343	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	how music works	327f68a59745c102	How Music Works	Music	37.32	2	19	6	22	19	3.6041666666666665	0.589496	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	foolproof preserving	5674a18a29a43ced	Foolproof Preserving: A Guide to Small Batch Jams, Jellies, Pickles, Condiments, and More: A Foolproof Guide to Making Small Batch Jams, Jellies, Pickles, Condiments, and More	Food and Drink	30.52	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	birdsong	9528d0948525bf5f	Birdsong: A Story in Pictures	Childrens	54.64	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	americas cradle of quarterbacks	c7d160c2c0de586f	America's Cradle of Quarterbacks: Western Pennsylvania's Football Factory from Johnny Unitas to Joe Montana	Default	22.50	3	19	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	aladdin and his wonderful lamp	904208d6aa64b655	Aladdin and His Wonderful Lamp	Default	53.13	3	19	5	5	0	\N	0.094109	t	t	16	lista_espera	
esc_duplicado	worlds elsewhere	4c28def39d850cdf	Worlds Elsewhere: Journeys Around Shakespeare’s Globe	Nonfiction	40.30	5	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	wall and piece	ccd9ffa25efabdea	Wall and Piece	Art	44.18	4	18	3	10	4	2.125	0.226347	t	t	12	lista_espera	
esc_duplicado	four agreements	6258a1f6a6dcfe50	The Four Agreements: A Practical Guide to Personal Freedom	Spirituality	17.66	5	18	1	1	1	3	0.056625	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	five love languages	3c039985229453bf	The Five Love Languages: How to Express Heartfelt Commitment to Your Mate	Nonfiction	31.05	3	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	elephant tree	5dada2b7be26bd03	The Elephant Tree	Thriller	23.82	5	18	3	7	1	4	0.293871	t	t	9	comprar	
esc_duplicado	bear and the piano	9f6568e9c95f60b0	The Bear and the Piano	Childrens	36.89	1	18	3	6	1	5	0.162646	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	sophies world	6be3beb0793a53e7	Sophie's World	Philosophy	15.94	5	18	7	8	8	4.375	0.501882	t	t	8	comprar	
esc_duplicado	penny maybe	668fe56b17cfcd4f	Penny Maybe	Default	33.29	3	18	1	5	0	\N	0.150195	t	t	14	lista_espera	
esc_duplicado	maude	094b269567e1c300	Maude (1883-1993):She Grew Up with the country	Default	18.02	2	18	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	in a dark dark wood	19ed25f4641d5efd	In a Dark, Dark Wood	Mystery	19.63	1	18	10	30	19	1.1403509	1.528273	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	behind closed doors	be5cc846f45496fb	Behind Closed Doors	Thriller	52.22	4	18	8	39	32	3.4126984	0.746840	t	t	5	comprar	
esc_duplicado	you cant bury them all	55f9da0c5eea2e10	You can't bury them all: Poems	Poetry	33.63	2	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	slow states of collapse	b4fd5943413e089a	Slow States of Collapse: Poems	Poetry	57.31	3	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	reasons to stay alive	c8f7f0cb1abb9cac	Reasons to Stay Alive	Nonfiction	26.41	2	17	2	10	19	4	0.378644	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	private paris	b12b89017878a60d	Private Paris (Private #10)	Fiction	47.61	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	higherselfie	c27f6e1f185b0383	#HigherSelfie: Wake Up Your Life. Free Your Soul. Find Your Tribe.	Nonfiction	23.11	5	17	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	without borders	acddfeab2a407640	Without Borders (Wanderlove #1)	New Adult	45.07	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	when we collided	3ecb690d1542c568	When We Collided	Contemporary	31.77	1	16	1	7	1	4	0.220334	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	we love you charlie freeman	8d455c7539795d2a	We Love You, Charlie Freeman	Fiction	50.27	5	16	1	4	0	\N	0.079570	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	untitled collection	657fe5ead67a7767	Untitled Collection: Sabbath Poems 2014	Poetry	14.27	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	unseen city	d170b5a0da46380e	Unseen City: The Majesty of Pigeons, the Discreet Charm of Snails & Other Wonders of the Urban Wilderness	Nonfiction	44.18	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	unicorn tracks	7ae099f3898e0209	Unicorn Tracks	Fantasy	18.78	3	16	1	3	0	0	0.159744	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	unbound	9a9d6e9bc555731e	Unbound: How Eight Technologies Made Us Human, Transformed Society, and Brought Our World to the Brink	History	25.52	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	tsubasa	09555be379ad9253	Tsubasa: WoRLD CHRoNiCLE 2 (Tsubasa WoRLD CHRoNiCLE #2)	Sequential Art	16.28	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	throwing rocks at the google bus	7858914fad68493c	Throwing Rocks at the Google Bus: How Growth Became the Enemy of Prosperity	Nonfiction	31.12	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	this one summer	51653ef291ab7ddc	This One Summer	Sequential Art	19.49	4	16	2	5	13	4	0.256542	t	t	11	lista_espera	
esc_duplicado	thirst	709822d0b5bcb7f4	Thirst	Fiction	17.27	5	16	3	11	3	3.3333333333333335	0.636943	t	t	6	comprar	
esc_duplicado	torch is passed	4eed62cf5f8d8edf	The Torch Is Passed: A Harding Family Story	Add a comment	19.09	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	secret of dreadwillow carse	b5ea0b5dabed25a8	The Secret of Dreadwillow Carse	Childrens	56.13	1	16	1	6	1	4	0.106895	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	pioneer woman cooks	142d767a56a9254d	The Pioneer Woman Cooks: Dinnertime: Comfort Classics, Freezer Food, 16-Minute Meals, and Other Delicious Ways to Solve Supper!	Food and Drink	56.41	1	16	1	1	0	\N	0.017727	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	past never ends	5ee94540d0749ea0	The Past Never Ends	Mystery	56.50	4	16	1	2	0	\N	0.035398	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	natural history of us	cedf82b5086e4691	The Natural History of Us (The Fine Art of Pretending #2)	Young Adult	45.22	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	nameless city	7d385d34d12e60ff	The Nameless City (The Nameless City #1)	Sequential Art	38.16	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	murder that never was	d01ac97e2b8947c2	The Murder That Never Was (Forensic Instincts #5)	Fiction	54.11	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	most perfect thing	aadee1c326d286e3	The Most Perfect Thing: Inside (and Outside) a Bird's Egg	Science	42.96	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	mindfulness and acceptance workbook for anxiety	31075275518532d7	The Mindfulness and Acceptance Workbook for Anxiety: A Guide to Breaking Free from Anxiety, Phobias, and Worry Using Acceptance and Commitment Therapy	Add a comment	23.89	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	life changing magic of tidying up	0da9aa9d24677fc0	The Life-Changing Magic of Tidying Up: The Japanese Art of Decluttering and Organizing	Nonfiction	16.77	3	16	2	2	0	\N	0.119261	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	inefficiency assassin	8c9e6bf2467d740d	The Inefficiency Assassin: Time Management Tactics for Working Smarter, Not Longer	Default	20.59	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	gutsy girl	acd86a5426e21ca0	The Gutsy Girl: Escapades for Your Life of Epic Adventure	Nonfiction	37.13	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	electric pencil	a30b270e25489e5c	The Electric Pencil: Drawings from Inside State Hospital No. 3	Nonfiction	56.06	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	death of humanity	bd261725b99f5983	The Death of Humanity: and the Case for Life	Philosophy	58.11	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	bulletproof diet	43c6a960757cf559	The Bulletproof Diet: Lose up to a Pound a Day, Reclaim Energy and Focus, Upgrade Your Life	Health	49.05	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	art forger	80cfab6bcff3a244	The Art Forger	Add a comment	40.76	3	16	5	6	4	2	0.147203	t	t	15	lista_espera	
esc_duplicado	age of genius	a3d2a4250807f1e9	The Age of Genius: The Seventeenth Century and the Birth of the Modern Mind	History	19.73	1	16	1	1	0	\N	0.050684	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	activists tao te ching	7d6d2a6c0276f81b	The Activist's Tao Te Ching: Ancient Advice for a Modern Revolution	Spirituality	32.24	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	spark joy	87b0615b6e1f4d7b	Spark Joy: An Illustrated Master Class on the Art of Organizing and Tidying Up	Nonfiction	41.83	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	soul reader	e6af5bf1163c1151	Soul Reader	Default	39.58	2	16	4	8	0	0	0.202122	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	security	6f78a0d744c35456	Security	Horror	39.25	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	saga volume 6	c849f0b2f5d6a742	Saga, Volume 6 (Saga (Collected Editions) #6)	Fantasy	25.02	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	saga volume 5	53a3d11bb568cc8b	Saga, Volume 5 (Saga (Collected Editions) #5)	Sequential Art	51.04	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	reskilling america	d7310206583a54b6	Reskilling America: Learning to Labor in the Twenty-First Century	Nonfiction	19.83	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	rat queens vol 3	c82a3e358c773c73	Rat Queens, Vol. 3: Demons (Rat Queens (Collected Editions) #11-15)	Sequential Art	50.40	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	princess jellyfish 2 in 1 omnibus vol 01	0fa6dceead7ce47a	Princess Jellyfish 2-in-1 Omnibus, Vol. 01 (Princess Jellyfish 2-in-1 Omnibus #1)	Sequential Art	13.61	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	princess between worlds	0e691eda369f4e09	Princess Between Worlds (Wide-Awake Princess #5)	Fantasy	13.34	5	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	pop gun war volume 1	e80f8e518b300dfe	Pop Gun War, Volume 1: Gift	Sequential Art	18.97	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	political suicide	7392c0032f92d816	Political Suicide: Missteps, Peccadilloes, Bad Calls, Backroom Hijinx, Sordid Pasts, Rotten Breaks, and Just Plain Dumb Mistakes in the Annals of American Politics	History	36.28	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	patience	9429b4d59c537af5	Patience	Sequential Art	10.16	3	16	4	57	4	4.75	5.610236	t	t	1	comprar	
esc_duplicado	outcast vol 1	889139b8e9c4cb36	Outcast, Vol. 1: A Darkness Surrounds Him (Outcast #1)	Sequential Art	15.44	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	orange	11809b1d323b3057	orange: The Complete Collection 1 (orange: The Complete Collection #1)	Sequential Art	48.41	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	online marketing for busy authors	9ffa38d3b832433a	Online Marketing for Busy Authors: A Step-By-Step Guide	Self Help	46.35	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	on a midnight clear	b757c0c361e689ce	On a Midnight Clear	Add a comment	14.07	3	16	1	1	0	0	0.071073	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	obsidian	3c346ab1e76ae1f6	Obsidian (Lux #1)	Young Adult	14.86	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	my paris kitchen	784bc2279baa878d	My Paris Kitchen: Recipes and Stories	Food and Drink	33.37	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	masks and shadows	fa9610a50a1bf149	Masks and Shadows	Fantasy	56.40	2	16	2	4	0	0	0.070922	t	f	\N	descartar	estrellas_bajo_umbral
esc_duplicado	mama tried	72f9d5be3472d34e	Mama Tried: Traditional Italian Cooking for the Screwed, Crude, Vegan, and Tattooed	Food and Drink	14.02	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	lumberjanes vol 2	460089f796fb3f82	Lumberjanes, Vol. 2: Friendship to the Max (Lumberjanes #5-8)	Sequential Art	46.91	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	lumberjanes vol 1	b6ee99bcf06fc91f	Lumberjanes, Vol. 1: Beware the Kitten Holy (Lumberjanes #1-4)	Sequential Art	45.61	3	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	lumberjanes vol 3	57e5a4d515c8ce44	Lumberjanes Vol. 3: A Terrible Plan (Lumberjanes #9-12)	Sequential Art	19.92	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	layered	7b75cc7f223791f4	Layered: Baking, Building, and Styling Spectacular Cakes	Food and Drink	40.11	1	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	judo	228f74b74f3a08ae	Judo: Seven Steps to Black Belt (an Introductory Guide for Beginners)	Add a comment	53.90	2	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
esc_duplicado	join	18ad3ed896c7ce05	Join	Science Fiction	35.67	5	16	1	1	1	5	0.028035	t	f	\N	descartar	ediciones_bajo_umbral
esc_duplicado	in the country we love	b136b1b180ca753a	In the Country We Love: My Family Divided	Nonfiction	22.00	4	16	\N	\N	\N	\N	\N	f	f	\N	descartar	sin_coincidencia_ol
\.


--
-- Name: decision_libros decision_libros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decision_libros
    ADD CONSTRAINT decision_libros_pkey PRIMARY KEY (escenario, upc);


--
-- PostgreSQL database dump complete
--

\unrestrict ndYghLj0HhFaqRnUsxyWsggWEGXwy7hhMPDnrjDcuaTSuKFndwZpdOpoH4ajgGc

