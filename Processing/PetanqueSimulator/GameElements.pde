/*
Les variables et constantes de jeu utilisees dans tout le programme
 * Maxime Touroute
 * Nicolas Sintes
 * Vincent Montalieu
 * Avril 2015
 */
/************* Constantes de jeu ****************/

// Etats du programme

int GAME_STATE;
int START_MENU = 1;
int INIT_LANCER = 3; // Moment où on choisit la vitesse et l'angle d'attaque
int LANCER_BOULE = 4; // Moment où la boule est lancée
int END_GAME = 10; // Moment où la boule est lancée

// Le mode triche
boolean CHEAT_MODE = false;

// La hauteur du sol
int HAUTEUR_SOL = 65; 

// La hauteur initiale du lancer
float HAUTEUR_INITIALE = 1.0;


// Le nombre de tentatives pour chaque lancer
int nombre_lancers = 3;
int lancers_restants = 0;

/************ Données du jeu ************/

PImage background_img;
PImage legende_img;
PImage menu_img;
PImage menu_x;
PImage menu_background;


int temps=0;

Commande commande = new Commande();



/* Données du joueur */
float player_force = 0;
float player_angle_dattaque = 0;
float position_boule_x;
float position_boule_y;
float score;
float position_cochonnet;

/**************************************/




