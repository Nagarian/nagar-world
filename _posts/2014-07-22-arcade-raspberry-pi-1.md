---
layout: post
status: publish
published: true
title: 'Une borne d''arcade à base de Raspberry Pi - Partie 1/3 : Let''s Play the
  Game'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
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
comments: []
---
<a style="margin-left: 1em; margin-right: 1em;" href="http://idata.over-blog.com/6/08/19/81/Fevrier-2014/arcade-Raspberry-pi.jpg"><img src="http://idata.over-blog.com/6/08/19/81/Fevrier-2014/arcade-Raspberry-pi.jpg" alt="" border="0" /></a>

Dans le cadre du laboratoire Electro-IT de mon école cette année, nous avons travaillé sur un projet de bornes arcade. Nous y avons travaillé dessus pendant un bon moment et pour cause, nous n'avons pas fait une, mais deux bornes ! Et qui plus est, chacune des bornes permet d'y jouer à deux dessus !

Bref il s'agit d'un projet complet, duquel je vais vous parler aujourd'hui.

PS : la photo ci-dessus n'est pas réprésentative des bornes que nous avons réalisé. Il s'agit d'un photo temporaire en attendant d'avoir fini l'assemblage final des bornes

<!--more-->

<ul>
<li><b>Partie 1/3 : Let's Play the Game</b></li>
<li>Partie 2/3 : Chameleon Pi fork, ou la refonte d'un menu</li>
<li>Partie 3/3 : MCP23017 - PiArcade, ou l'art de re-coder ce qui existe déjà</li>
</ul>
# Origine du projet

Au tout début du projet, nous avions pour consigne de réaliser deux bornes d'arcade afin de rendre plus convivial la cafétéria de notre école, <a href="http://www.ingesup.com/ecole-informatique/bordeaux.html">Ingésup Bordeaux</a>. Nous avions pour contrainte de faire une borne à moindre coût possible. Donc c'est pour cela que nous nous sommes dirigés vers la Raspberry Pi.

<a style="margin-left: 1em; margin-right: 1em;" href="/assets/images/uploads/2014/07/rpi_combo-1.png"><img class="aligncenter" src="/assets/images/uploads/2014/07/rpi_combo-1.png" alt="" width="400" height="292" border="0" /></a>

Pour la suite, nous avons eu le choix de la solution que nous voulions entreprendre. Et d'un avis commun, nous nous sommes décidés à faire en sorte que l'on puisse jouer à deux par bornes. En effet, quoi de plus fun que de s'affronter l'un contre l'autre sur un bon vieux Mario Kart ou un Mortal Combat ?

<a href="http://www.megaleecher.net/sites/default/files/images/raspberry-pi-rev2-gpio-pinout.jpg"><img class="alignleft" src="http://www.megaleecher.net/sites/default/files/images/raspberry-pi-rev2-gpio-pinout.jpg" alt="" width="320" height="222" border="0" /></a>

Cependant, la Raspberry Pi possède un total de 17 GPIO utilisables. Et pour deux joueurs avec 6 boutons, et 1 joystick (4 pins) par personne + 5 boutons de plus (Start, Select, Exit, Flipper Gauche, Flipper Droit) on atteint un total de 25 pins requis. Il nous a donc fallu utiliser une extension pour avoir plus de pins utilisables. Ce qui a entraîné d'autres contraintes fonctionnelles que nous verrons par la suite. Pour cela, nous aurions pu prendre des solutions déjà toutes prêtes, mais afin de respecter la contrainte technique du coût, nous nous sommes dirigés sur une puce, la

<strong>MCP23017</strong>.Celle-ci ne coûte pas excessivement chère (moins de 3 $) et s'utilise en i2c branché sur la Raspberry.

Et pour finir la liste de course, nous nous sommes procuré des boutons de bornes d'arcade ainsi que le nombre de joystick nécessaire (tout cela peut se trouver sur des sites marchands comme Amazon ou autres) et pour donner un aspect plus rétro, nous avons récupéré des écrans d'ordinateur 4:3.

# Le choix du système

Lorsque la question du système que nous allions utiliser, est venue, nous avons regardé sur internet les différents projets qui avaient déjà été réalisés. Ainsi nous en avons trouvé tout un tas, cependant un a su retenir notre attention, il s'agit de Chameleon Pi.

<a style="margin-left: 1em; margin-right: 1em;" href="http://chameleon.enging.com/data1/images/cpi_h6.jpg"><img class="aligncenter" src="http://chameleon.enging.com/data1/images/cpi_h6.jpg" alt="" width="640" height="114" border="0" /></a>

Les raisons à cela sont simples. Le nombre d'émulateur présent étant satisfaisant, l'interface de choix de l'émulateur et du jeu est simple, claire et design. De plus, le site officiel explique assez bien le fonctionnement du projet ce qui nous a permis de l'intégrer bien plus facilement. Pour plus d'informations vous pouvez vous rendre directement sur le site officiel du projet : <a href="http://chameleon.enging.com/">http://chameleon.enging.com/</a>

# La réalisation du système

## La partie hardware

Comme dit précédemment, nous avons utilisé une Raspberry Pi, et une puce MCP23017. Nous avons cherché pendant un moment comment elle fonctionne et nous avons fini par trouver <a href="http://www.raspberrypi-spy.co.uk/2013/07/how-to-use-a-mcp23017-i2c-port-expander-with-the-raspberry-pi-part-1/">ce blog</a> qui nous a permis de comprendre son fonctionnement. Aussi si vous voulez en apprendre plus, je vous conseille d'aller le lire, ce ne sera jamais perdu !

Voici le schéma de base du projet, pour des raisons de lisibilité, je n'ai pas mis les boutons montés sur la Raspberry Pi. Il suffit juste d'utiliser les pins disponibles comme cela a été fait pour les autres boutons.

<a style="margin-left: 1em; margin-right: 1em;" href="/assets/images/uploads/2014/07/Schema_b3-1-1024x843.png"><img class="aligncenter" src="/assets/images/uploads/2014/07/Schema_b3-1-1024x843.png" alt="" width="640" height="526" border="0" /></a>

Sur le schéma, les 2 pins les plus à gauche (GPA7 &amp; GPB0) sont utilisables pour des boutons comme les autres pins. Les joysticks que nous avons pris s'utilisent comme les boutons, il y a une masse, et 4 pins qui correspondent à chacune des directions.

La connexion entre la Raspberry et la puce passe par les ports I2C. Nous n'avons pas mis de résistance entre chaque bouton, car nous avons constaté que tout le circuit supporté la tension délivrée, mais libre à vous d'en rajouter, cela vous permettra de sécuriser un peu plus la borne.

## La partie Software

<div>
Pour cette partie, nous avions trois opérations à effectuer :

<ul>
<li>Trouver/Écrire un programme pour gérer les touches de la borne.</li>
<li>Trier et configurer les émulateurs</li>
<li>Modifier l'interface de la borne</li>
</ul>
### Gestion des touches

<div>Notre borne possède 17 boutons et deux joysticks, mais ils ont beau être présent, ils ne vont pas fonctionner par la voix du Saint-esprit ! De ce fait, nous avons effectué des recherches pour voir ce que nos prédécesseurs avaient déjà trouvé à ce sujet. Nous sommes donc d'abord tombés sur ce projet-là :

<a href="https://github.com/adafruit/Adafruit-Retrogame">Adafruit-Retrogame</a>. Celui-ci permet de gérer les boutons branchés directement sur la Raspberry. La configuration est assez simple à mettre en oeuvre. Il suffit de modifier retrogame.c, puis de le recompiler et lancer l’exécutable.

[bash]$ nano retrogame.c

$ make

$ sudo ./retrogame

[/bash]

Le mappage des touches se base sur les constantes définies dans le fichier <strong>/usr/include/linux/input.h</strong> de toute bonne distribution Linux, puisqu'il s'agit d'un classique. Ainsi il suffit de faire correspondre le numéro du pin GPIO de notre raspberry sur la touche que nous voulons émuler

[cpp]struct {

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

[/cpp]

Pour les touches configurées sur la puce, nous avons eu un peu plus de mal. En effet, la difficulté était plus grande, car nous devions avoir un programme capable d'interagir avec la puce MCP23017, qui fonctionne par I2C. Mais qui émule l'appui sur une touche de clavier. Et de ce fait, peu de résultats sortaient sur internet. Cependant, nous sommes finalement tombés sur un autre projet disponible sur GitHub également : <a href="https://github.com/guyz/piarcade">PiArcade</a>.

Merci à son créateur <b><a href="http://web.media.mit.edu/~guyzys/">Guy Zyskind</a>, </b>pour son travail. Nous avons pu ainsi l'utiliser pour notre propre borne. Cependant, lorsque fut venue le moment de tester, le script n'a pas voulu fonctionner correctement. Ce qui m'a amené à devoir le modifier (pour cela rendez-vous dans un futur post de mon blog pour avoir plus de détails, en attendant <a href="https://github.com/Nagarian47/piarcade">retrouver mon code ici</a>). Malgré tout, le second groupe qui bossait sur la deuxième borne, est parvenue à le faire fonctionner sans modification majeure.

Ce programme se configure et s'utilise ensuite de la même manière que Retrogame. C'est pour cela également que nous avons travaillé avec.

</div>
### Configuration des émulateurs

<a href="http://static.giantbomb.com/uploads/original/12/121177/1676971-ms_pac_man_arcade_machine.jpg"><img class="alignright" src="http://static.giantbomb.com/uploads/original/12/121177/1676971-ms_pac_man_arcade_machine.jpg" alt="" width="177" height="320" border="0" /></a>Pour cette étape, nous avons tout d'abord fait le tri parmi toutes les consoles disponibles. En effet, notre but était de faire des bornes d’arcade, de ce fait toutes les consoles comme la Commodore, l'Amstrad, l’Apple ][ et d'autres, dont on a besoin d’un clavier pour jouer n’étaient pas adaptés. De ce fait nous les avons tout simplement enlevés.

Nous avons aussi séparé les différentes consoles qui se lançaient en appuyant sur le bouton 2 ou 3, pour leurs données leur part entière sur le menu. Je parle notamment de la Gameboy Advance, pour laquelle nous devions appuyer sur le numéro 2 sur la console Gameboy, du menu principal.

Ce qui fait que nous avons gardé aux total 7 consoles :

<ul>
<li>L’Atari 2600</li>
<li>La Megadrive</li>
<li>La Gameboy/ Gameboy Color</li>
<li>La Gameboy Advance</li>
<li>La NES</li>
<li>La Super Nintendo (SNES)</li>
<li>Et évidemment la Borne Arcade propulsé par MAME</li>
</ul>
Nous avons ensuite configuré tous ces émulateurs pour qu’ils utilisent tous les mêmes touches, et nous avons fait en sorte que tout se lance automatiquement sur le jeu choisi par notre interface. De ce fait, on évite que des petits malins aillent toucher aux configurations !

<div>
De plus, nous avons choisi de désactiver la plupart des fonctionnalités comme le SMB (qui permet d’utiliser les roms se trouvant dans un dossier disponible sur le même réseau) ou le montage automatique des jeux présents sur une clé USB branché sur la borne. Nous avons pris cette décision dans un double intérêt :

<ul>
<li>Le premier, dans un but de sécurité. Étant donné que la borne sera utilisée dans un lieu public nous voulons éviter tout risque de débordements.</li>
<li>Le deuxième, afin d’augmenter la vitesse de démarrage de l’OS. En effet, si ChameleonPi met autant de temps à démarrer, ce n’est pas pour rien, c’est à cause du fait qu’il check sur tout le réseau pour les connexions disponibles, et ils montent tous les périphériques USB.</li>
</ul>
Mais bien évidemment tout cela reste ré-activable, nous avons juste commenté les lignes qui se trouvent dans les fichiers <strong>/opt/selector/tools/AUTOEXEC.launcher</strong> et <strong>/opt/selector/tools/AUTOEXEC.system</strong> pour faire cela.

</div>
### Modification de l'interface

Nous nous sommes donc penchés sur l’OS et nous avons regardé comment il était composé. Nous avons constaté que seuls deux dossiers allaient nous intéresser, le dossier /roms qui sert à stocker toutes les roms pour les différents jeux, et le dossier /opt/selector.

<a href="/assets/images/uploads/2014/07/splash-1-1024x819.png"><img class="alignleft" src="/assets/images/uploads/2014/07/splash-1-1024x819.png" alt="" width="320" height="256" border="0" /></a>

Ce dernier contient toute l’interface de gestion de l’interface. Dans celui-ci, le fonctionnement est assez rudimentaire et s’articule autour d’un fichier : select.sh. Comme son extension le précise, il s’agit d’un script bash. Il s’occupe de lancer le menu codé en python emselect.py, s’appuyant sur la bibliothèque PyGame. Qui une fois la console choisie, ou une autre option choisie, retourne un code statuts différent. Le script saute dans la bonne condition, exécute le code qu’il faut puis réaffiche le menu principal.

De ce fait le premier point négatif est apparu, l’utilisation de plusieurs technologies alourdi les transitions et il faut attendre plusieurs secondes avant de pouvoir accéder au nouveau menu (le menu du choix du jeu notamment).

Et deuxième point négatif chacun des menus codés en python, l’ont été en mode script. Les scripts c’est bien, mais personnellement je préfère la POO ! Et pour un projet comme celui-là, cela ne me paraît pas envisageable de le faire autrement. En effet, coder un projet en mode scripting entraîne un dédoublement du code, diminue la compréhension du code et dégrade la maintenabilité. Et par conséquent diminue l’incitation des gens à contribuer à son amélioration, ce qui est dommage pour un projet open-source !

Bref, c’est pour cela que je me suis lancé à faire la refonte de tout le code présent dans le dossier <strong>/opt/selector</strong>. J’ai, à l’heure actuelle, fini de tout factoriser, et réorganiser le code. Et afin de permettre à tout le monde d’y accéder, j’ai mis les sources sur mon GitHub. Ainsi, pour les personnes utilisant déjà ChameleonPi, j’ai également confectionné un script qui vous permettra de mettre à jour votre interface assez facilement. Pour plus de détails, je vous donne rendez-vous dans le prochain article qui sera justement consacré à toute cette refonte, il recensera également toutes les modifications apportées, ainsi que les ajouts et les quelques suppressions.

En attendant vous pouvez dès maintenant, télécharger et utiliser ma version du selector à cette adresse : <a href="http://github.com/Nagarian47/ChameleonPi-selector">ChameleonPi-selector</a>

NB : sur cette version j'ai fait en sorte de laisser actifs le SMB, et montage de clé USB, et squasfs au démarrage.

# Le rendu ... final?

Nos bornes bien que pas tout à fait finalisées sont parfaitement fonctionnelles et jouables... dans leurs boîtes en cartons ! =D

<a style="margin-left: 1em; margin-right: 1em;" href="/assets/images/uploads/2014/07/WP_20140527_005-1-1024x576.jpg"><img src="/assets/images/uploads/2014/07/WP_20140527_005-1-1024x576.jpg" alt="" width="640" height="360" border="0" /></a>

Comme vous pouvez-le voir, le design extérieur est ultra tendance, mais c'est parce que vous n'avez pas vu l'intérieur :

<a style="margin-left: 1em; margin-right: 1em;" href="/assets/images/uploads/2014/07/WP_20140527_002-1-1024x576.jpg"><img src="/assets/images/uploads/2014/07/WP_20140527_002-1-1024x576.jpg" alt="" width="640" height="360" border="0" /></a>

Bref, on peut les utiliser, mais comme elle ne sont pas encore montés, vous n'aurez pas plus de photos.

En attendant, je vous propose de tester par vous même notre rendus. Et n'hésiter pas à ré-utiliser et à améliorer le projet.

Pour pouvoir télécharger notre version de Chameleon Pi, vous pouvez suivre ce lien : <a href="http://1drv.ms/1ogdZBi">http://1drv.ms/1ogdZBi</a>

Et si vous désirez seulement la nouvelle version de l'interface, vous pouvez vous rendre sur celui-là : <a href="https://github.com/Nagarian47/ChameleonPi-selector">https://github.com/Nagarian47/ChameleonPi-selector</a>

Et pour terminer, je vous propose de vous abonner à mon flux RSS, car dans mes prochains articles, je vous donnerai plus de détails vis-à-vis du projet. En commençant par l'explication de la nouvelle structure que j'ai apporté au sélecteur de consoles et de jeux !

</div>
