---
title: "Une borne d'arcade à base de Raspberry Pi - Partie 1/3 : Let's Play the Game"
wordpress_id: 412
wordpress_url: http://www.nagar-world.fr/2014/07/22/une-borne-darcade-base-de-raspberry-pi-3/
date: '2014-07-22 21:27:00 -0500'
date_gmt: '2014-07-22 20:27:00 -0500'
categories:
- Raspberry Pi
- Arduino
tags:
- python
- raspberry pi
---

Dans le cadre du laboratoire Electro-IT de mon école cette année, nous avons travaillé sur un projet de bornes arcade. Nous y avons travaillé dessus pendant un bon moment et pour cause, nous n'avons pas fait une, mais deux bornes ! Et qui plus est, chacune des bornes permet d'y jouer à deux dessus !

Bref il s'agit d'un projet complet, duquel je vais vous parler aujourd'hui.

PS : la photo ci-dessus n'est pas réprésentative des bornes que nous avons réalisé. Il s'agit d'un photo temporaire en attendant d'avoir fini l'assemblage final des bornes

<!--more-->

- **[Partie 1/3 : Let's Play the Game]({% post_url 2014-07-22-arcade-raspberry-pi-1 %})**
- [Partie 2/3 : Chameleon Pi fork, ou la refonte d'un menu]({% post_url 2014-09-27-arcade-raspberry-pi-2-1 %})
- Partie 3/3 : MCP23017 - PiArcade, ou l'art de re-coder ce qui existe déjà

# Origine du projet

Au tout début du projet, nous avions pour consigne de réaliser deux bornes d'arcade afin de rendre plus convivial la cafétéria de notre école, [Ingésup Bordeaux](http://www.ingesup.com/ecole-informatique/bordeaux.html). Nous avions pour contrainte de faire une borne à moindre coût possible. Donc c'est pour cela que nous nous sommes dirigés vers la Raspberry Pi.

![Raspberry Pi](/assets/images/uploads/2014/07/rpi_combo.png){:img: width="400" height="292"}

Pour la suite, nous avons eu le choix de la solution que nous voulions entreprendre. Et d'un avis commun, nous nous sommes décidés à faire en sorte que l'on puisse jouer à deux par bornes. En effet, quoi de plus fun que de s'affronter l'un contre l'autre sur un bon vieux Mario Kart ou un Mortal Combat ?

![Raspberry Pi 2 GPIO correspondance](/assets/images/uploads/2014/07/raspberry-pi-rev2-gpio-pinout.jpg){:img: .alignleft width="320" height="220"}

Cependant, la Raspberry Pi possède un total de 17 GPIO utilisables. Et pour deux joueurs avec 6 boutons, et 1 joystick (4 pins) par personne + 5 boutons de plus (Start, Select, Exit, Flipper Gauche, Flipper Droit) on atteint un total de 25 pins requis. Il nous a donc fallu utiliser une extension pour avoir plus de pins utilisables. Ce qui a entraîné d'autres contraintes fonctionnelles que nous verrons par la suite. Pour cela, nous aurions pu prendre des solutions déjà toutes prêtes, mais afin de respecter la contrainte technique du coût, nous nous sommes dirigés sur une puce, la `MCP23017`.Celle-ci ne coûte pas excessivement chère (moins de 3 $) et s'utilise en i2c branché sur la Raspberry.

Et pour finir la liste de course, nous nous sommes procuré des boutons de bornes d'arcade ainsi que le nombre de joystick nécessaire (tout cela peut se trouver sur des sites marchands comme Amazon ou autres) et pour donner un aspect plus rétro, nous avons récupéré des écrans d'ordinateur 4:3.

# Le choix du système

Lorsque la question du système que nous allions utiliser, est venue, nous avons regardé sur internet les différents projets qui avaient déjà été réalisés. Ainsi nous en avons trouvé tout un tas, cependant un a su retenir notre attention, il s'agit de Chameleon Pi.

[![Chameleon Pi](/assets/images/uploads/2014/07/chameleonpi.png)](http://chameleon.enging.com){:img: width="640" height="114"}

Les raisons à cela sont simples. Le nombre d'émulateur présent étant satisfaisant, l'interface de choix de l'émulateur et du jeu est simple, claire et design. De plus, le site officiel explique assez bien le fonctionnement du projet ce qui nous a permis de l'intégrer bien plus facilement. Pour plus d'informations vous pouvez vous rendre directement sur le site officiel du projet : [http://chameleon.enging.com/](http://chameleon.enging.com/)

# La réalisation du système

## La partie hardware

Comme dit précédemment, nous avons utilisé une Raspberry Pi, et une puce MCP23017. Nous avons cherché pendant un moment comment elle fonctionne et nous avons fini par trouver [ce blog](http://www.raspberrypi-spy.co.uk/2013/07/how-to-use-a-mcp23017-i2c-port-expander-with-the-raspberry-pi-part-1/) qui nous a permis de comprendre son fonctionnement. Aussi si vous voulez en apprendre plus, je vous conseille d'aller le lire, ce ne sera jamais perdu !

Voici le schéma de base du projet, pour des raisons de lisibilité, je n'ai pas mis les boutons montés sur la Raspberry Pi. Il suffit juste d'utiliser les pins disponibles comme cela a été fait pour les autres boutons.

![Schema reliant la puce MCP23017 à la raspberry et aux boutons du joystick](/assets/images/uploads/2014/07/Schema_b3-1.png){:img: width="640" height="526"}

Sur le schéma, les 2 pins les plus à gauche (GPA7 et GPB0) sont utilisables pour des boutons comme les autres pins. Les joysticks que nous avons pris s'utilisent comme les boutons, il y a une masse, et 4 pins qui correspondent à chacune des directions.

La connexion entre la Raspberry et la puce passe par les ports I2C. Nous n'avons pas mis de résistance entre chaque bouton, car nous avons constaté que tout le circuit supporté la tension délivrée, mais libre à vous d'en rajouter, cela vous permettra de sécuriser un peu plus la borne.

## La partie Software

Pour cette partie, nous avions trois opérations à effectuer :

- Trouver/Écrire un programme pour gérer les touches de la borne.
- Trier et configurer les émulateurs
- Modifier l'interface de la borne

### Gestion des touches

Notre borne possède 17 boutons et deux joysticks, mais ils ont beau être présent, ils ne vont pas fonctionner par la voix du Saint-esprit ! De ce fait, nous avons effectué des recherches pour voir ce que nos prédécesseurs avaient déjà trouvé à ce sujet. Nous sommes donc d'abord tombés sur ce projet-là : [Adafruit-Retrogame](https://github.com/adafruit/Adafruit-Retrogame). 

Celui-ci permet de gérer les boutons branchés directement sur la Raspberry. La configuration est assez simple à mettre en oeuvre. Il suffit de modifier retrogame.c, puis de le recompiler et lancer l’exécutable.

```bash
nano retrogame.c
make
sudo ./retrogame
```

Le mappage des touches se base sur les constantes définies dans le fichier `/usr/include/linux/input.h` de toute bonne distribution Linux, puisqu'il s'agit d'un classique. Ainsi il suffit de faire correspondre le numéro du pin GPIO de notre raspberry sur la touche que nous voulons émuler

```cpp
struct {
 int pin;
 int key;
} io[] = {
//   Input    Output (from /usr/include/linux/input.h)
 {  7, KEY_LEFT },//Joystick Gauche
 { 11, KEY_RIGHT },//Joystick Droit
 {  8, KEY_UP  },//Joystick Haut
 {  9, KEY_DOWN },//Joystick Bas
 { 25, KEY_X  },//Bouton Rouge = Saut
 { 10, KEY_Z  },//Bouton Bleu
 { 24, KEY_A  },//Bouton Vert
 { 22, KEY_S  },//Bouton Jaune
 { 27, KEY_Q  },//Bouton Vert D (etiquette)
 { 17, KEY_W  },//Bouton Jaune D (etiquette)
 { 23, KEY_ENTER }, //Bouton Blanc (o|&amp;amp;lt;)
 { 18, KEY_P  } //Bouton echap sur le schema
};
```

Pour les touches configurées sur la puce, nous avons eu un peu plus de mal. En effet, la difficulté était plus grande, car nous devions avoir un programme capable d'interagir avec la puce MCP23017, qui fonctionne par I2C. Mais qui émule l'appui sur une touche de clavier. Et de ce fait, peu de résultats sortaient sur internet. Cependant, nous sommes finalement tombés sur un autre projet disponible sur GitHub également : [PiArcade](https://github.com/guyz/piarcade).

Merci à son créateur **[Guy Zyskind](http://web.media.mit.edu/~guyzys/)**, pour son travail. Nous avons pu ainsi l'utiliser pour notre propre borne. Cependant, lorsque fut venue le moment de tester, le script n'a pas voulu fonctionner correctement. Ce qui m'a amené à devoir le modifier (pour cela rendez-vous dans un futur post de mon blog pour avoir plus de détails, en attendant [retrouver mon code ici](https://github.com/Nagarian47/piarcade)). Malgré tout, le second groupe qui bossait sur la deuxième borne, est parvenue à le faire fonctionner sans modification majeure.

Ce programme se configure et s'utilise ensuite de la même manière que Retrogame. C'est pour cela également que nous avons travaillé avec.

### Configuration des émulateurs

![Borne arcade](/assets/images/uploads/2014/07/1676971-ms_pac_man_arcade_machine.jpg){:img: .alignright width="177" height="320"}
Pour cette étape, nous avons tout d'abord fait le tri parmi toutes les consoles disponibles. En effet, notre but était de faire des bornes d’arcade, de ce fait toutes les consoles comme la Commodore, l'Amstrad, l’Apple ][ et d'autres, dont on a besoin d’un clavier pour jouer n’étaient pas adaptés. De ce fait nous les avons tout simplement enlevés.

Nous avons aussi séparé les différentes consoles qui se lançaient en appuyant sur le bouton 2 ou 3, pour leurs données leur part entière sur le menu. Je parle notamment de la Gameboy Advance, pour laquelle nous devions appuyer sur le numéro 2 sur la console Gameboy, du menu principal.

Ce qui fait que nous avons gardé aux total 7 consoles :

- L’Atari 2600
- La Megadrive
- La Gameboy/ Gameboy Color
- La Gameboy Advance
- La NES
- La Super Nintendo (SNES)
- Et évidemment la Borne Arcade propulsé par MAME

Nous avons ensuite configuré tous ces émulateurs pour qu’ils utilisent tous les mêmes touches, et nous avons fait en sorte que tout se lance automatiquement sur le jeu choisi par notre interface. De ce fait, on évite que des petits malins aillent toucher aux configurations !

De plus, nous avons choisi de désactiver la plupart des fonctionnalités comme le SMB (qui permet d’utiliser les roms se trouvant dans un dossier disponible sur le même réseau) ou le montage automatique des jeux présents sur une clé USB branché sur la borne. Nous avons pris cette décision dans un double intérêt :

- Le premier, dans un but de sécurité. Étant donné que la borne sera utilisée dans un lieu public nous voulons éviter tout risque de débordements.
- Le deuxième, afin d’augmenter la vitesse de démarrage de l’OS. En effet, si ChameleonPi met autant de temps à démarrer, ce n’est pas pour rien, c’est à cause du fait qu’il check sur tout le réseau pour les connexions disponibles, et ils montent tous les périphériques USB.

Mais bien évidemment tout cela reste ré-activable, nous avons juste commenté les lignes qui se trouvent dans les fichiers `/opt/selector/tools/AUTOEXEC.launcher` et `/opt/selector/tools/AUTOEXEC.system` pour faire cela.

### Modification de l'interface

Nous nous sommes donc penchés sur l’OS et nous avons regardé comment il était composé. Nous avons constaté que seuls deux dossiers allaient nous intéresser, le dossier /roms qui sert à stocker toutes les roms pour les différents jeux, et le dossier /opt/selector.

![Chameleon Pi Ynov version](/assets/images/uploads/2014/07/splash-1.png){:img: .alignleft width="320" height="256"}

Ce dernier contient toute l’interface de gestion de l’interface. Dans celui-ci, le fonctionnement est assez rudimentaire et s’articule autour d’un fichier : select.sh. Comme son extension le précise, il s’agit d’un script bash. Il s’occupe de lancer le menu codé en python emselect.py, s’appuyant sur la bibliothèque PyGame. Qui une fois la console choisie, ou une autre option choisie, retourne un code statuts différent. Le script saute dans la bonne condition, exécute le code qu’il faut puis réaffiche le menu principal.

De ce fait le premier point négatif est apparu, l’utilisation de plusieurs technologies alourdi les transitions et il faut attendre plusieurs secondes avant de pouvoir accéder au nouveau menu (le menu du choix du jeu notamment).

Et deuxième point négatif chacun des menus codés en python, l’ont été en mode script. Les scripts c’est bien, mais personnellement je préfère la POO ! Et pour un projet comme celui-là, cela ne me paraît pas envisageable de le faire autrement. En effet, coder un projet en mode scripting entraîne un dédoublement du code, diminue la compréhension du code et dégrade la maintenabilité. Et par conséquent diminue l’incitation des gens à contribuer à son amélioration, ce qui est dommage pour un projet open-source !

Bref, c’est pour cela que je me suis lancé à faire la refonte de tout le code présent dans le dossier `/opt/selector`. J’ai, à l’heure actuelle, fini de tout factoriser, et réorganiser le code. Et afin de permettre à tout le monde d’y accéder, j’ai mis les sources sur mon GitHub. Ainsi, pour les personnes utilisant déjà ChameleonPi, j’ai également confectionné un script qui vous permettra de mettre à jour votre interface assez facilement. Pour plus de détails, je vous donne rendez-vous dans le prochain article qui sera justement consacré à toute cette refonte, il recensera également toutes les modifications apportées, ainsi que les ajouts et les quelques suppressions.

En attendant vous pouvez dès maintenant, télécharger et utiliser ma version du selector à cette adresse : [ChameleonPi-selector](http://github.com/Nagarian47/ChameleonPi-selector)

NB : sur cette version j'ai fait en sorte de laisser actifs le SMB, et montage de clé USB, et squasfs au démarrage.

# Le rendu ... final?

Nos bornes bien que pas tout à fait finalisées sont parfaitement fonctionnelles et jouables... dans leurs boîtes en cartons ! =D

![Borne arcade prototype](/assets/images/uploads/2014/07/WP_20140527_005-1.jpg){:img: width="640" height="360"}

Comme vous pouvez-le voir, le design extérieur est ultra tendance, mais c'est parce que vous n'avez pas vu l'intérieur :

![Borne arcade prototype intérieur](/assets/images/uploads/2014/07/WP_20140527_002-1.jpg){:img: width="640" height="360"}

Bref, on peut les utiliser, mais comme elle ne sont pas encore montés, vous n'aurez pas plus de photos.

En attendant, je vous propose de tester par vous même notre rendus. Et n'hésiter pas à ré-utiliser et à améliorer le projet.

Pour pouvoir télécharger notre version de Chameleon Pi, vous pouvez suivre ce lien : <http://1drv.ms/1ogdZBi>

Et si vous désirez seulement la nouvelle version de l'interface, vous pouvez vous rendre sur celui-là : <https://github.com/Nagarian47/ChameleonPi-selector>

Et pour terminer, je vous propose de vous abonner à mon flux RSS, car dans mes prochains articles, je vous donnerai plus de détails vis-à-vis du projet. En commençant par l'explication de la nouvelle structure que j'ai apporté au sélecteur de consoles et de jeux !
