---
title: "Une borne d'arcade à base de Raspberry Pi - Partie 2/3 : Chameleon Pi fork, Refonte d'un menu"
wordpress_id: 402
wordpress_url: http://www.nagar-world.fr/2014/09/27/une-borne-darcade-base-de-raspberry-pi-2/
date: '2014-09-27 13:54:00 -0500'
date_gmt: '2014-09-27 12:54:00 -0500'
categories:
- Python
- Raspberry Pi
tags:
- borne arcade
- python
- raspberry pi
---

Après deux mois de silence, je me suis enfin décidé à publier la suite de mon précédent article. Et si j'ai mis autant de temps, c'est pour une bonne raison, je cherchais comment rédiger cet article, pour le rendre le plus intéressant possible. Aussi j'en suis arrivé à la conclusion de redécouper l'article initial que j'avais prévu en trois articles distincts ! La suite d'article traitant de la borne d'arcade passe donc à cinq.

Bref dans ces trois articles, je vais vous expliquer le fonctionnement de l'écran principal de Chameleon Pi, c'est-à-dire le menu de sélection de la console et du jeu. Dans ce premier article, je vais vous décrire les changements que j'ai opérés par rapport à la version initiale.

<!--more-->

- [Partie 1/3 : Let's Play the Game]({% post_url 2014-07-22-arcade-raspberry-pi-1 %})
- **[Partie 2/3 : Chameleon Pi fork, ou la refonte d'un menu]({% post_url 2014-09-27-arcade-raspberry-pi-2-1 %})**
  - **[Organisation du projet]({% post_url 2014-09-27-arcade-raspberry-pi-2-1 %})**
  - [Configuration, Emulateurs et menu des Options]({% post_url 2014-10-04-arcade-raspberry-pi-2-2 %})
  - [Ecran de veille, nouveau écran et bonus]({% post_url 2014-10-11-arcade-raspberry-pi-2-3 %})
- Partie 3/3 : MCP23017 - PiArcade, ou l'art de re-coder ce qui existe déjà

# Etat des lieux et fonctionnement global

![Schema structuration des scripts](/assets/images/uploads/2014/09/schema_fonctionnement-1.png){:img: .alignleft width="400" height="227"}

Au moment où j'ai repris le travail qui avait été effectué sur l'interface de Chamelon Pi, celle –ci s'articulait autour d'un fichier principal : `select.sh`. En effet, c'est lui qui s'occupait de gérer tout le système quand on l'appelait. Il lançait en premier lieux `emlaunch.py`, c'est-à-dire le menu de choix de l'émulateur. Puis quand l'utilisateur appuyait sur une touche, nous retournions un code retour et c'était le script select.sh qui traitait cette information et effectuait une action définie.

Par exemple, si le code retour était inclus entre 2 et 99, nous lancions un émulateur, s'il s'agissait de 100 on ouvrait un terminal, 199 c'était le menu des options. Par contre, si nous avions 0 ou 1, nous quittions select.sh… Sauf qu'il redémarrait aussitôt, puisque celui-ci était défini comme un script qui se lance par défaut.

De plus, si nous comptons entre 2 et 99, cela nous fait un total de 97 émulateurs ! Or vous vous en doutez Chameleon Pi a beau en avoir beaucoup, il n'atteint pas ce chiffre. Alors comment expliquer ce décalage ? C'est fort simple, le code retour pour un émulateur était défini en fonction de la console qu'il émule.

En gros, nous avions un fichier `machines.conf`, dans lequel nous définissions les différentes consoles de jeux que nous voulions (l'ordre à son importance !). Ensuite pour une même console, nous avions la possibilité de pouvoir lancer différents émulateurs afin de prendre celui qui serait le plus stable, en fonction de notre jeu. Pour choisir, l'émulateur que l'on désirait, nous appuyions sur 1, 2 ou 3, et en fonction de notre choix, le code retour différait. Pour tous les choix numéro 1, nous retournons un code compris entre 2 et 52, pour le choix 2 ce sera entre 53 et 72 et pour le choix 3 nous aurons donc entre 73 et 99.

Maintenant que nous savons le fonctionnement de select.sh, nous pouvons nous attarder sur les autres fichiers qui étaient utilisés. Commençons donc par le dossier `tools`, que j'ai gardé tel quel dans la nouvelle version. Celui-ci contient tous les scripts secondaires à Chameleon Pi. Parmis eux, certains doivent être lancés en ligne de commande, alors que d'autres seront disponibles à partir du menu d'options. Aussi je ne m'attarde pas trop dessus maintenant, nous aurons l'occasion d'en parler par la suite.

Nous avions également le dossier `imatges`, qui contenait toutes les ressources graphiques et sonores de notre sélecteur. Et enfin, sans compter select.sh, nous avions à la racine :

- 2 fichiers de configuration, `wifiwpa.config` et `machines.conf`. Le premier ne nous intéresse pas car annexe et le deuxième nous l'avons déjà vu.
- 3 scripts bash, `amstradfiles.sh`, `listfiles.sh`, `listfiles_sdl.sh`. Le premier servait à lancer l'Amstrad. Les deux autres par contre servaient à lister les jeux disponibles et choisir celui que l'on veut. La différence entre les deux résidait dans l'affichage, le _sdl correspondait à la version python, et l'autre en ligne de commande (chacun ses goûts !)
- 3 scripts python, `emlaunch.py`, `filesel.py` et `menusel.py`. Le premier permettait à l'utilisateur de choisir la console et l'émulateur avec lequel il souhaitait jouer. Le deuxième, à choisir le jeu auquel il souhaitait jouer, et le troisième constituaient le menu des options.

## Mon avis

Nous avons fini le tour du propriétaire, nous pouvons maintenant passer aux critiques sur la structure du projet. Tout d'abord, d'un point de vue utilisateur, ce n'est pas génial car nous avons un temps d'attente assez long pour passer d'un menu à un autre. Après nous avons quelques détails esthétiques pas très unifiés, par exemple le background entre chaque écran ne suit pas le même style.

Ensuite d'un point de vue fonctionnel, chaque écran peut être lancé indépendamment, ce qui ne représente pas un problème en temps normal, mais lorsque pour passer de l'un à l'autre nous transitons par un script bash, nous obligeons python à recharger toutes les libraires à chaque fois. De plus, par rapport au gain d'autonomie d'exécution pour chaque fichier, la duplication de code engendré est bien trop importante pour qu'il soit justifié.

Et pour finir, l'organisation des fichiers dans le projet, tout comme la structuration du code ressemble à un grand capharnaüm. Par exemple, nous avons un dossier `imatges` qui contient toutes les ressources utilisées en vrac, il n'y a que les images pour l'écran de veille qui soit organisé. Et pour le code nous sommes en programmation procédurale, donc celui-ci est relativement complexe à comprendre.

# Nouvelle structuration et organisation

Pour la restructuration du projet, je suis partie du code qui avait déjà été écrit dans le projet. En effet, de mes expériences avec les autres langages que j'ai eu utilisés auparavant, j'ai décidé de faire un travail de refactorisation et de remodèlement plutôt que de repartir de zéro.

Ainsi dans la version initiale, l'interface a été codé en utilisant la librairie python `Pygame`. Celle-ci est suffisamment complète mais est destinée à faire des jeux vidéo, et non pas des interfaces utilisateur. Mais l'un n'empêche pas l'autre ! me direz-vous. C'est vrai, et c'est la raison pour laquelle j'ai décidé de garder et utiliser cette bibliothèque pour faire l'interface.

Cependant, comme la plupart des frameworks de jeux vidéo, le programme ne fonctionne pas sur un système d'évenènement se déclenchant auquel on attache une action spécifique. Il fonctionne plutôt sur le principe d'une boucle infini dans laquelle, on met à jour nos variables puis on affiche les éléments graphiques à l'écran, et on recommence un tour de boucle.

Cela demande donc une certaine organisation pour éviter que le code ne parte dans tous les sens. De ce fait, j'ai pris la décision de reproduire le même schéma de fonctionnement que celui présent dans le (feu) framework XNA développé par Microsoft jusqu'en 2012, aujourd'hui repris dans le projet open-source [Monogame](http://www.monogame.net/).

Celui-ci est rudement simple d'utilisation. Nous avons à notre disposition, une classe principale `Game1` dans laquelle se trouvent 5 fonctions.

![Monogame structure class Game1](/assets/images/uploads/2014/09/Capture.png){:img: width="600" height="260"}

- `Initialize()` : cette fonction a pour but de ; comme son nom l'indique, initialiser toutes nos variables que l'on compte utiliser. Elle est appelée une seule fois, au lancement du jeu.
- `LoadContent()` : celle-ci a pour but est plus ou moins similaire à la précédente sauf que d'un point de vue logique, on initialisera toutes nos variables dans le Initialize alors que dans celle-ci nous chargerons les ressources graphiques, sonores, ou autres. Et tout comme Initialize, elle n'est appelé qu'une seule fois.
- `UnloadContent()` : cette fonction est plus ou moins inutile suivant le langage employé (à cause du garbage collector), mais elle a pour but de décharger les éléments lourds que l'on aura mis en mémoire dans la fonction précédente. Ainsi elle n'est appelé qu'une seule fois dans les jeux, c'est-à-dire lorsque l'on arrête le jeu.
- `Update()` : il s'agit de la fonction principale, et la plus importante. C'est cette fonction-là qui va contenir toutes la logique de mise à jour des variables que l'on utilise durant le jeu. Ainsi c'est dans cette fonction que nous mettrons en place toutes la logique de mise à jour de notre interface.
- `Draw()` : cette dernière fonction est également importante car c'est dans celle-là que nous disposons sur notre écran les différents éléments que nous devons afficher. Elle ne doit donc contenir aucune logique de mise à jour de l'interface, elle doit juste s'occuper d'afficher les éléments.

# Répartition des fichiers

![Monogame structure class Game1](/assets/images/uploads/2014/09/fileList-1.png){:img: .alignleft width="178" height="400"}

Pour ce qui est de l'organisation du projet, tout est dorénavant réparti en 4 dossiers. Le premier correspond à celui qui existait déjà de base, à savoir `tools`. Il contient tous les scripts externes (comme ceux pour modifier la sortie du son, ou ceux pour connecter/déconnecter les clés USB, etc.) qui peuvent être lancées en ligne de commande, ou alors directement depuis le menu des options (si vous voulez savoir comment faire, lisez la suite de cet article !).

Ensuite nous avons un dossier `configuration`, qui contient tous les fichiers servant à configurer le fonctionnement du sélecteur, comme par exemple le fichier `machines.conf`. Nous retrouverons le dossier `imatges` au travers du dossier `resources`, qui a pour l'occasion été réorganisé et redécoupé de façon fonctionnelle. Ainsi nous avons un sous-dossier `consoles`, et `error` qui contiennent respectivement les images des consoles utilisées dans le menu principal, et les images utilisées pour l'écran de veille. Puis nous trouvons un sous-dossier `font` qui contient toutes les polices d'écriture utilisée, et un sous-dossier `sound`, qui contient tous les sons utilisés pour rendre l'interface plus vivante et conviviale.

Et pour finir, un nouveau dossier fait son apparition, il s'agit du dossier `frame`. Celui-ci contiendra donc tous les différents écrans que nous voudrons utiliser dans notre interface de Chamelon Pi. Il contient également 2 fichiers supplémentaires. Le premier `folderExporer.py` est en fait une classe utilitaire que j'utilise afin de lister les fichiers se trouvant dans un dossier. `IFrame.py` est un fichier un peu spécial car il n'est pas utilisé à proprement parler dans l'application, mais il permet de pouvoir créer facilement une nouvelle frame si le besoin se fait sentir.

A la racine du dossier vous trouverez également 3 autres fichiers python. Le premier `frameCollection.py`, est aussi une classe utilitaire, `singleton.py` est un fichier python que j'utilise afin de pouvoir définir des variables accessibles depuis toute l'application. Le dernier fichier python, `selector.py` est le fichier principal de l'application. C'est lui qui va s'occuper de lancer les différents frames, et qui va charger les différentes librairies utilisées dans l'application. Il s'agit du fichier principal de toute l'interface python de notre sélecteur.

Nous avons également 2 scripts bash, dont `select.sh` qui est le fichier le plus important. En effet, pour que la raspberry puisse utiliser toutes ses capacités pour émuler les jeux, seul ce script tournera en fond de tâche et occupera encore quelques maigres ressources. Cela permet ainsi de récupérer celles qui auraient été prise par les librairies python et pygame. Et quant au fichier `installUpdate.sh`, ce script sert à mettre à jour une iso Chameleon Pi avec le fichier présent sur [mon repository GitHub](https://github.com/Nagarian47/ChameleonPi-selector)

![ChameleonPi écran accueil](/assets/images/uploads/2014/09/ChameleonPi-accueil-1.png){:img: width="640" height="508"}
