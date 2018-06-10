---
layout: post
status: publish
published: true
title: 'Une borne d''arcade à base de Raspberry Pi - Partie 2/3 : Chameleon Pi fork,
  Ajouter vos propres écrans'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 382
wordpress_url: http://nagarianblog.azurewebsites.net/2014/10/11/une-borne-darcade-base-de-raspberry-pi_11/
date: '2014-10-11 23:00:00 -0500'
date_gmt: '2014-10-11 22:00:00 -0500'
categories:
- Python
- Raspberry Pi
tags:
- borne arcade
- python
- raspberry pi
comments: []
---
<p>Dans cet avant-dernier article à propos de Chameleon Pi, vous allez découvrir comment ajouter différentes images pour l'écran de veille. Mais surtout, à la fin de celui-ci vous saurez comment faire pour rajouter d'autres écrans dans Chameleon Pi, sans trop vous prendre la tête !<br />
<!--more--></p>
<ul>
<li>Partie 1/3 : Let's Play the Game</li>
<li><strong>Partie 2/3 : Chameleon Pi fork, ou la refonte d'un menu</strong>
<ul>
<li>Organisation du projet</li>
<li>Configuration, Emulateurs et menu des Options</li>
<li><strong>Ecran de veille, nouveau écran et bonus</strong></li>
</ul>
</li>
<li>Partie 3/3 : MCP23017 - PiArcade, ou l'art de re-coder ce qui existe déjà</li>
</ul>
<p>&nbsp;</p>
<h2>Modifier les images de l'écran de veille</h2>
<p>Pour ce qui est de l'écran de veille du sélecteur, j'ai repris les images qui étaient déjà utilisées dans la première version, à savoir les images représentant les messages d'erreurs des différentes consoles. Sauf que si vous désirez changer les images affichées cela est faisable très facilement, il suffit de rajouter votre dossier d'image dans le dossier <strong>resources/VOTRE_NOM_DE_DOSSIER</strong>, puis de modifier le fichier frame/screensaver.py. Et plus précisément la première ligne de la fonction <strong>LoadImage</strong>.</p>
<p>[python]self.picture = pygame.image.load( &quot;resources/&quot; + &quot;error/error&quot;+ ( &quot;%02d&quot; % random.randrange( 1, 18) ) + &quot;.png&quot; )[/python]</p>
<p>Je ne pense pas avoir besoin d'expliquer plus, sur les modifications à apporter sur cette ligne. Une fois fait, il ne restera plus qu'à admirer le résultat.</p>
<h2>Ajouter un nouvel écran</h2>
<p>Pour pouvoir arriver à faire cela, plusieurs étapes sont nécessaires.</p>
<h3>1) Dupliquer le fichier IFrame</h3>
<p>C'est dans celui-ci, que vous devrez mettre toute la logique de votre nouvel écran. Comme je l'ai expliqué auparavant, pour chacun des nouveaux affichages, vous aurez les 5 fonctions principales. Ainsi, une fois que vous aurez dupliqué le fichier IFrame, vous devez modifier le nom de la classe. Puis vous n'aurez plus qu'à écrire la logique de fonctionnement de votre nouvel écran, en initialisant les ressources lourdes de XNA dans le <strong>LoadContent</strong>, les variables de classe dans le <strong>__init__</strong>. Puis vous écrivez la logique de rafraichissement de votre écran dans l'<strong>Update</strong> tout comme la gestion des touches. Puis, il ne vous restera plus qu'à dessiner vos éléments sur l'écran à l'aide de la fonction <strong>Draw</strong>.<br />
Vous aurez probablement besoin d'utiliser pygame, pour pouvoir charger en mémoire les différentes ressources. Aussi n'oubliez pas de l'inclure. De plus si vous n'êtes pas familier avec la librairie pygame n'hésitez pas à regarder le fonctionnement des autres frames !</p>
<h3>2) Naviguer entre les frames</h3>
<p>C'est bien beau de créer une nouvelle frame, cependant si l'on ne peut pas y accéder c'est un peu inutile. Aussi, vous aurez sans doute remarqué que la fonction Update retourne une valeur un peu particulière. Il s'agit d'un tuple :</p>
<p>[bash]return (&quot;CONTINUE&quot;, None)[/bash]</p>
<p>Cette valeur est celle par défaut, et elle permet de faire en sorte que la frame en cours continue de s'afficher. Aussi il faut absolument que la fonction Update renvoi un tuple similaire sinon boum !<br />
Parmi les tuples que vous pouvez renvoyer, vous avez les choix suivants :</p>
<p>[python]return (&quot;CONTINUE&quot;, None) # ce tuple permet de continuer à afficher l'écran en cours<br />
return (&quot;EXIT&quot;, 1) # ce tuple permet d'arrêter notre sélecteur ; le nombre correspond au code retour que le programme doit retourner quand il s'arrêtera<br />
return (&quot;NAVIGATE&quot;, &quot;OptionsMenu&quot;) # ce tuple permet de naviguer vers un nouvel écran ; le second paramètre correspond à l'écran vers lequel on veut naviguer<br />
return (&quot;NAVIGATE&quot;, &quot;GameChoiceMenu&quot;, (self.current + 2, self.emulatorItems[self.current])) # ce tuple est le même que le précédent mais précise que nous pouvons passer un autre tuple comme argument pour la fenêtre suivante. Ainsi, si vous avez besoin de passer plusieurs arguments, vous devez passer un seul tuple avec autant de valeur que nécessaire.<br />
return (&quot;RETURN&quot;, None) # ce tuple permet de quitter l'écran en cours et revenir dans l'écran précédent [/python]</p>
<p>Donc il ne vous reste plus qu'à aller modifier un des écrans pécédent pour pouvoir mettre la condition qui vous permettra de naviguer vers votre nouvelle frame.</p>
<h3>3) Modifier selector.py</h3>
<p>A ce moment précis si vous essayez d'afficher votre nouvel écran en appuyant sur le bouton que vous aurez défini, vous aurez une jolie erreur. Et pour cause, je ne vous ai pas encore tout dit au niveau de la navigation. En effet, dans mon implémentation de XNA-Like, je n'ai pas réussi à trouver une façon satisfaisante pour pouvoir mettre en place la navigation sans toucher au fichier selector.py. Aussi, pour que votre frame s'affiche vous devez rajouter 2 éléments dans ce fameux fichier.<br />
En premiers lieux, vous devez rajouter l'importation de votre fichier en haut du fichier donc une ligne semblable à :</p>
<p>[python]from frame.gamechoice import GameChoiceMenu[/python]</p>
<p>Et ensuite vous devez rajouter une condition supplémentaire au niveau de la condition de navigation, qui devra instancier votre frame dans la variable <strong>newFrame</strong></p>
<p>[python]elif action[1] == &quot;OptionsMenu&quot;:<br />
    newFrame = OptionsMenu()[/python]</p>
<p>Maintenant vous êtes en mesure de rajouter autant d'écrans que vous voulez dans le sélecteur, happy coding !</p>
<h2>Informations complémentaires</h2>
<p>Je vais maintenant m'attarder un peu sur le fichier selector.py. En effet, c'est ce fichier qui permet de mettre en place la structure et la logique XNA-Like. Aussi il y a quelques trucs à savoir.<br />
Par exemple, le premier est que la structure dans laquelle sont stockés les frames est une stack définie dans le fichier <strong>frameCollection.py</strong> disponible à la racine du projet. Ainsi seul le dernier écran est mis à jour et afficher, dans la boucle. Par contre le screenSave, bien que reprenant la structure d'une frame classique ne fait pas partie de cette stack car elle a un fonctionnement un peu plus particulier. En effet, un « event » est lancé à intervalles réguliers si aucune action n'est effectuée, afin de pouvoir afficher les images aléatoirement. Et enfin le dernier truc à savoir sur cette partie est que le nombre d'affichage par seconde (FPS pour les intimes) est régulé à maximum 60 par seconde.<br />
Dans le dossier frame, se trouve une autre classe qui n'y a pas trop sa place (mais je ne voulais pas pour autant le mettre à la racine du projet) il s'agit de <strong>folderExplorer.py</strong>. Cette classe permet de lister tous les éléments disponibles dans un dossier, à deux détails près. Pour créer une nouvelle instance de cette classe, on définit un dossier de base qui constituera la racine. Par là j'entends que s'il y a un dossier, on peut y naviguer dedans et en ressortir mais on ne pourra pas aller dans le dossier parent du dossier racine. Nous avons ainsi une espèce de « chroot » et le deuxième détail, est par contre facultatif. En effet, on doit passer une liste (qui peut être vide) qui contient les extensions de fichier que l'on autorise à apparaître dans la propriété <strong>fileItemAllowed</strong>. Pour avoir une idée de son fonctionnement, vous pouvez jeter un œil dans le fichier <strong>gamechoice.py</strong>.<br />
Pour l'organisation des codes retours que l'on peut utiliser dans select.sh, voici un petit récapitulatif :</p>
<ul>
<li>Les choix 0 et 1 sont réservés car il s'agit des principaux codes retour d'un programme.</li>
<li>De 2 à 51, nous avons les choix correspondant au premier émulateur pour chaque console.</li>
<li>De 52 à 71, il s'agit de l'émulateur alternatif #1 pour les consoles</li>
<li>De 72 à 100, il s'agit de l'émulateur alternatif #2 pour les consoles</li>
<li>De 101 à autant que l'on veut, il s'agit des choix que l'on peut faire dans le menu des options.</li>
</ul>
<p>Ensuite toujours pour select.sh, l'exécution du sélecteur passe par la ligne suivante :</p>
<p>[bash]fileSelected=$(python selector.py $choice)<br />
choice=$?[/bash]</p>
<p>Ainsi nous récupérons le code retour dans la variable <strong>choice</strong>, et nous récupérons dans la variable <strong>fileSelected</strong> le chemin absolu vers la rom que nous voulons jouer. Par conséquent si vous voulez déboguer le programme python, je me suis débrouillé pour que l'on puisse le lancer en dehors du select.sh. Ainsi vous pouvez tout à fait développer le sélecteur sur votre ordinateur et le tester dessus, puis ensuite de transférer vos fichiers mis à jour sur la raspberry. Pour le tester il suffit de lancer la commande suivante :</p>
<p>[bash]python selector.py[/bash]</p>
<h2>Conclusion</h2>
<p>Voilà, je pense avoir fait le tour sur la nouvelle version de l'interface de ChameleonPi, que j'ai réalisée. Si vous avez encore des questions à ce sujet-là, n'hésitez pas à laisser un message, ci-dessous. De plus, n'hésitez surtout pas à améliorer et/ou customiser votre version de cette interface. Et ainsi créer votre propre branche sur GitHub, qui je vous rappelle est disponible à <a href="https://github.com/Nagarian47/ChameleonPi-selector">cette adresse</a>.</p>
<p>Je vous donne rendez-vous maintenant pour la dernière partie partie qui traitera des scripts permettant de jouer à la borne d'arcade à deux joueurs à l'aide de vrais boutons de bornes arcade utilisable à partir des pins GPIO.</p>
