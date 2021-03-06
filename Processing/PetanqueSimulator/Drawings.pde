/*
  * Les méthodes de dessin du jeu
 * Maxime Touroute
 * Nicolas Sintes
 * Vincent Montalieu
 * Avril 2015
 */

// Un compteur pour des effets animés
float compteur_dessin = 1;
float seconde = 0;

/*
Dessin de l'ecran d'accueil
 */
void draw_menu()
{

  float cl = sin(compteur_dessin/40);
  compteur_dessin++;

  if (compteur_dessin % int(framerate/3) == 0) seconde++;

  background(220+cl*100, 200+cl*80, 200+cl*10);

  image(menu_background,0,0);
  image(menu_img, 0, 0);

  if (seconde % 2 == 0) image(menu_x, 0, 0);
}

/*
Dessin du jeu
 */
void draw_game()
{
  // Le dessin du jeu depend de l'etat dans lequel est le jeu (GAME_STATE)

  // INIT_LANCER : la boule n'a pas encore ete lancee
  if (GAME_STATE == INIT_LANCER)
  {

    background(background_img);
    drawSpeedVector();
    draw_boule();
    draw_cochonnet();
    draw_legende();
    draw_texts();
  }

  // La boule est en vol
  else if (GAME_STATE == LANCER_BOULE)
  {
    background(background_img);
    draw_trajectoire();

    if (CHEAT_MODE)
    {
      draw_trajectoire_triche();
      if (temps < commande.instant_fin_commande_triche)
        draw_reacteurs();
    }

    drawSpeedVector();
    draw_boule();
    draw_cochonnet();

    draw_legende();
    draw_texts();
  }
  // STATE : Fin du jeu: affichage du score
  else if (GAME_STATE == END_GAME) 
  { 
    // Petit effet de couleur clignotante sur le score
    if (compteur_dessin < 10) fill(255, 0, 0);
    else if (compteur_dessin >= 10 && compteur_dessin < 20) fill(0);
    else if (compteur_dessin < 30) fill(255, 0, 0);
    else fill(0);

    compteur_dessin+=7;

    textSize(60);
    textAlign(CENTER, CENTER);

    if (position_boule_x*SCALE < window_size_x+10)
    {
      text("SCORE:" + int(score) + "%", 400, 120);
    } else
    {
      text("OUT OF BOUNDS !", 400, 120);
    }

    fill(0, 0, 0);
    textSize(25);
    textAlign(CENTER, CENTER);
    text("TRY AGAIN? [T]", 400, 170); 
    fill(0, 0, 0);
  }
}

/*
Dessine la trajectoire de la boule
 */
void draw_trajectoire()
{

  // Affichage de la trajectoire au fur et a mesure de l'avancement de la boule
  for (int i = 0; (!CHEAT_MODE && i < temps) || (CHEAT_MODE && ( ( i < temps && i < commande.instant_fin_commande_manuelle ) || (i >= commande.instant_fin_commande_triche && i < commande.instant_fin_commande_manuelle) )  ); i++)
  {
    // Dessin de la ligne
    stroke(214, 0, 0);  // Couleur du trait
    strokeWeight( 2 ); //Epaisseur du trait
    line(commande.coordonnees_trajectoire_x[i]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y[i]*SCALE-HAUTEUR_SOL, 
    commande.coordonnees_trajectoire_x[i+1]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL); 

    // Points rouges
    strokeWeight(8); // Epaisseur du trait
    point(commande.coordonnees_trajectoire_x[i+1]*SCALE, window_size_y-commande.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL);
  }
}

/*
Dessine la trajectoire de la boule en cas de triche
 */
void draw_trajectoire_triche()
{
  // On fait ici attention de ne pas deborder sur la fin de trajectoire
  for (int i = 0; i < temps && i < commande.instant_fin_commande_triche; i++)
  {

    if(commande.coordonnees_trajectoire_y_triche[i] < 0 && commande.coordonnees_trajectoire_y_triche[i+1] < 0) 
    {
      stroke(51,24,0,170);
      strokeWeight(15);
          line(commande.coordonnees_trajectoire_x_triche[i]*SCALE, 
          window_size_y-commande.coordonnees_trajectoire_y_triche[i]*SCALE-HAUTEUR_SOL, 
          commande.coordonnees_trajectoire_x_triche[i+1]*SCALE, 
          window_size_y-commande.coordonnees_trajectoire_y_triche[i+1]*SCALE-HAUTEUR_SOL); 
    }
        // Dessin de la ligne
    stroke(10, 214, 0,255);  // Couleur du trait
    
    strokeWeight( 2 ); //Epaisseur du trait
    line(commande.coordonnees_trajectoire_x_triche[i]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y_triche[i]*SCALE-HAUTEUR_SOL, 
    commande.coordonnees_trajectoire_x_triche[i+1]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y_triche[i+1]*SCALE-HAUTEUR_SOL); 

    // Points verts
    strokeWeight(8); // Epaisseur du trait
    point(commande.coordonnees_trajectoire_x_triche[i+1]*SCALE, window_size_y-commande.coordonnees_trajectoire_y_triche[i+1]*SCALE-HAUTEUR_SOL);
  }
}



/*
Dessine la boule
 */
void draw_boule()
{
  stroke(80, 80, 80);  // Couleur du trait
  strokeWeight(2);
  fill(80, 80, 80);

  if (GAME_STATE == INIT_LANCER)
    ellipse(0*SCALE, window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-6, 20, 20); 
  else
    ellipse(position_boule_x*SCALE, window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-6, 20, 20);
}

/*
Dessine des vecteurs de poussee autour de la boule
 */
void draw_reacteurs()
{

  strokeWeight(4);
  stroke(255, 150, 58);
  fill(255, 0, 0);

  //ellipse(0*SCALE, window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-5, 10, 10); 
  drawArrow( (int) (position_boule_x*SCALE), (int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ), 
  (int) (position_boule_x*SCALE), (int) ( (window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5)-50*commande.vitesse_trajectoire_y[temps]) );

  drawArrow( (int) (position_boule_x*SCALE), (int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ), 
  (int) ( (position_boule_x*SCALE) + 50*commande.vitesse_trajectoire_x[temps] ), (int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ) );
}


/*
* Dessine le cochonnet !
 */
void draw_cochonnet()
{
  stroke(0, 0, 0);  // Couleur du trait
  strokeWeight(2);
  fill(255, 51, 51);
  ellipse(position_cochonnet*SCALE, window_size_y-HAUTEUR_SOL, 8, 8);
}



/**
 * Dessine le vecteur vitesse initiale
 */
void drawSpeedVector() {
  stroke(0, 0, 255);  // Couleur du trait
  strokeWeight(4); //Epaisseur du trait
  drawArrowPolar(0*SCALE, int(window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-5), int(player_force*20), int(player_angle_dattaque));
}

/**
 * Dessine un vecteur en coordonées polaires avec repère inversé selon les y
 */
void drawArrowPolar(int x_origine, int y_origine, int r, int theta) {
  drawArrow(x_origine, y_origine, x_origine + int(r*cos(radians(theta))), y_origine - int(r*sin(radians(theta))));
}

/**
 * Dessine un vecteur en coordonées cartésiennes
 */
void drawArrow(int x1, int y1, int x2, int y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
}

/*
Draw the texts
 */
void draw_texts()
{
  if (GAME_STATE == LANCER_BOULE || GAME_STATE == END_GAME || GAME_STATE == INIT_LANCER)
  {
    textSize(15);
    textAlign(LEFT, CENTER);
    fill(0, 0, 0);
    text("X: " + nf(position_boule_x, 1, 2), 720, 30);
    text("Y: " + nf(position_boule_y, 1, 2), 720, 50); 

    text("Vx: " + nf(commande.vitesse_trajectoire_x[temps], 1, 2), 630, 30);
    text("Vy: " + nf(commande.vitesse_trajectoire_y[temps], 1, 2), 630, 50); 



    fill(0, 0, 0);
    textAlign(LEFT);
    textSize(15);
    text("Time:" + int(temps) + " periods", 410, 65);
    text("Balls      :", 20, 100); 
    text("Strengh : " + nf(player_force, 1, 1) + "m/s", 20, 120);
    text("Angle    : " + int(player_angle_dattaque) + "°", 20, 140); 

    // Le nombre de balles restantes
    fill(64);
    strokeWeight(0); //Epaisseur du trait
    for (int i = 0; i < lancers_restants; i++)
      ellipse(95+15*i, 95, 10, 10);


    textAlign(LEFT);
    fill(20, 20, 51);

    textSize(20);
    if (CHEAT_MODE) text("Open Loop", 410, 35); 
    else  text("Manual", 410, 35);
  } else
  {
    textSize(15);
    textAlign(CENTER, CENTER);
    text("ERROR draw_texts()", 400, 20); 
    fill(0, 0, 0);
  }
}


void draw_legende()
{
  image(legende_img, 0, 0);
}



