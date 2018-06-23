---
layout: post
status: publish
published: true
title: 'Une borne d''arcade à base de Raspberry Pi - Partie 2/3 : Chameleon Pi fork,
  Cutomize your own selector'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 392
wordpress_url: http://www.nagar-world.fr/2014/10/04/une-borne-darcade-base-de-raspberry-pi/
date: '2014-10-04 23:00:00 -0500'
date_gmt: '2014-10-04 22:00:00 -0500'
categories:
- Raspberry Pi
tags:
- borne arcade
- python
- raspberry pi
comments: []
---
Dans cet article, nous allons voir comment modifier votre version de Chameleon Pi, pour qu'elle corresponde à vos propres goûts.

Plutôt que de vous expliquer le fonctionnement du projet par fichier, je vais plutôt vous détailler les points-clés du code, en recoupant en fonction des différentes modifications que vous serez susceptible de vouloir apporter à votre version de Chameleon PI.

<!--more-->

- [Partie 1/3 : Let's Play the Game]({% post_url 2014-07-22-arcade-raspberry-pi-1 %})
- **[Partie 2/3 : Chameleon Pi fork, ou la refonte d'un menu]({% post_url 2014-09-27-arcade-raspberry-pi-2-1 %})**
  - [Organisation du projet]({% post_url 2014-09-27-arcade-raspberry-pi-2-1 %})
  - **[Configuration, Emulateurs et menu des Options]({% post_url 2014-10-04-arcade-raspberry-pi-2-2 %})**
  - [Ecran de veille, nouveau écran et bonus]({% post_url 2014-10-11-arcade-raspberry-pi-2-3 %})
- Partie 3/3 : MCP23017 - PiArcade, ou l'art de re-coder ce qui existe déjà

# Singleton : un moyen simple d'avoir un fichier de configuration

Tout d'abord, afin de pouvoir mettre en place un fichier de configuration pour l'utilisation des touches, j'ai utilisé la modularité de python et j'en ai fait un fichier : selectorConfig.py. Ce fichier permet ainsi de définir des « constantes » que l'on pourra accéder depuis n'importe où dans le code, car toutes les variables contenues dans ce fichier sont ensuite inclues dans le fichier singleton.py. Pour pouvoir ensuite les utiliser il suffira simplement de faire :

```bash
Singleton.MA_VARIABLE
```

Pour précision, c'est dans ce fichier que j'ai défini les touches utilisées dans toute l'interface du sélecteur. Si vous souhaitez juste changez la configuration des touches, il suffit de se reporter à la documentation de `pygame.locals` pour savoir les noms des constantes utilisées

# Ajouter ou modifier une console ou un émulateur

De la même manière, afin de définir comment rajouter une console ou un émulateur dans le sélecteur, le programme va se reposer sur 2 fichiers comme auparavant : `machines.conf` et `select.sh`. Ainsi pour pouvoir rajouter un émulateur la manipulation est sensiblement la même que ce qui existait déjà. Pour commencer, nous devons définir les différentes machines que nous voulons dans le fichier `machines.conf`.

## Définir les consoles à utiliser : Machines.conf

Ce fichier de configuration est celui qui va définir les différentes consoles disponibles dans le menu du choix des consoles. L'ordre des consoles est également important car c'est ce fichier qui permet de faire la correspondance entre les émulateurs et le code retour que l'on utilise dans le fichier select.sh. En effet la toute première console qui se trouve dans le fichier correspondra au numéro 2 dans select.sh. Ensuite la deuxième console correspond au choix numéro 3, et ainsi de suite jusqu'à la 49ème console (encore faut-il en avoir autant !). Pour ce qui est du code retour pour les émulateurs alternatifs, on ne définit aucune ligne pour eux, mais on le calcule très facilement à partir de l'index de notre console. Ainsi pour le premier émulateur alternatif, nous prenons le code retour correspondant à la console de base, et on ajoute 50. Ainsi dans mon fichier machines.conf, l'arcade se trouve en deuxième position, il donc comme code retour 3, pour utiliser l'émulateur alternatif nous ajoutons 50 et nous obtenons 53 ce qui correspond à l'émulateur advmenu.

Ensuite pour pouvoir rajouter une console, il suffit de rajouter une ligne formatée comme cet exemple :

```text
GameBoy|gameboy.png|gnuboy|http://vba.ngemu.com/|http://chameleon.enging.com/?q=gameboy|http://chameleon.enging.com/?q=visualboyadvance|/roms/gameboy/|.GBC|.GB
```

Ainsi, pour séparer chacune des propriétés nous utilisons le symbole `|` de ce fait, d'un point de vue générique nous avons une ligne qui contient :

```text
Le nom de la console| Le nom de l'image à mettre dans le dossier /opt/selector/resources/consoles folder | Le nom (des)de l'émulateur(s) | Une url du site du projet de l'émulateur | Une url vers l'aide sur la console | Une url vers une page expliquant le fonctionnement de l'émulateur principal | Chemin absolu vers le dossier où sont stockés les roms | Toutes les extensions de roms que l'on autorise à apparaitre dans le sélecteur (que l'on sépare par le symbole « | » )
```

Les changements opérés par rapport à la version initiale, sont uniquement le rajout des deux dernières valeurs. La première est utilisée afin de déterminer qu'elle sera le dossier racine pour la console pour le « chroot » que l'on verra ultérieurement. Tandis que la seconde sert à l'affichage des jeux lors du choix depuis notre interface. En effet, nous nous sommes aperçu que certains émulateurs créer les fichiers de sauvegarde dans le même dossier que celui où se trouve le jeu. Ainsi l'interface était rapidement polluée avec les divers noms en double avec juste une extension qui change. Ainsi, avec ce paramètre, auquel nous pouvons énumérer diverses extensions possibles, nous simplifions l'affichage, mais aussi nous diminuons les risques de faire crasher les émulateurs.

PS : vous pouvez à tout moment rajouter une nouvelle ligne de commentaire dans le fichier options.conf, pour cela il vous suffit de commencer la ligne par un `#`

## Définir les émulateurs à lancer : `select.sh`

Une fois que les consoles que l'on a choisies ont été rajoutés dans le fichier de configuration, il nous faut définir quel émulateur nous devons lancer en fonction du numéro calculé précédemment. Pour cela, il suffit d'insérer dans le fichier `select.sh`, un nouveau case dans le switch-case.

Par exemple, pour pouvoir lancer l'émulateur advmenu pour qu'il lance les jeux de bornes arcade (dont le code retour que nous avons calculé précédemment est le 53) nous avons placé les lignes suivantes :

```bash
53)
    advmenu "$fileSelected"
    _main ;;
```

Voilà maintenant, vous savez tout ce qu'il faut savoir pour pouvoir rajouter un émulateur ou une nouvelle console dans le sélecteur.

# Modifier les options disponibles dans le menu des options

Une des nouvelles fonctionnalités que j'ai apportées au projet, c'est la possibilité de configurer entièrement le menu des options (accessible par la touche `O`). J'entends par-là, que nous pouvons ajouter très facilement une nouvelle option sans rien connaître en python. En effet, tout se situe dans le fichier `options.conf`, `select.sh` et le dossier `tools`.

Celui-ci s'utilise de la manière suivante, nous définissons toutes les options dans le fichier options.conf, nous leur attribuons un numéro à chacune. Puis nous rajoutons un nouveau case dans le fichier `select.sh` qui s'occupera de lancer le script ou la commande que l'on veut exécuter.

**NB :** il est préférable d'utiliser un script qui se situera dans le dossier `tools`, afin de garder une cohérence dans la structure du projet.

Pour ce qui est de la structure du fichier `options.conf`, elle suit le schéma suivant :

```text
Titre Générale de la fenêtre
Sous-titre de la fenêtre (qui changera en fonction du sous-menu choisi)
```

Ces deux premières lignes ne nécessitant pas plus d'explication, car elle tombe sous le sens, je vais donc plutôt m'attarder un peu sur les suivantes.

```text
(numéro au-dessus de 100)|(Nom de l'option correspondante)
(numéro au-dessus de 100)|(Nom du sous menu)
    (numéro au-dessus de 100)| (Nom de l'option correspondante
```

Ainsi, mise à part les 2 premières lignes qui doivent s'y trouver impérativement, toutes les autres peuvent être modifié sans retenue. Le premier et le deuxième choix correspondent aux options qui seront disponibles depuis le menu racine des options. A la différence près, que le deuxième choix amènera dans un sous-menu, ou sera disponible la troisième option.

Pour pouvoir créer des sous-menus, il suffit de rajouter une tabulation ou quatre espaces, au début de la ligne suivante qui constituera le premier choix du sous-menu.

**NB :** à l'heure actuelle, l'option récursive n'est pas encore implémentée, donc nous ne pouvons avoir que 2 niveaux de menus. Ce qui est déjà pas mal !

Pour définir le nombre correspondant à l'option à activer dans le fichier select.sh, J'ai pris le parti que toutes les options du menu racine allait de 101 à 109. Et dès que l'on désire avoir un sous-menu, on décale le chiffre des unités dans les dizaines et on continue à incrémenter le nombre de 1 à 9 suivants les sous-options que l'on veut. Par exemple, on veut un sous menu sous l'option 104, ses sous options auront pour numéro 141, 142, etc.

Si vous allez examiner ce fichier par vous-même vous verrez que certaines options continuent avec

```bash
|./fichier.sh
```

cela constitue une nouvelle fonctionnalité que j'avais commencé à implémenter. En effet j'avais pour objectif de pouvoir spécifier un des scripts présent dans le dossier `/opt/selector/tools` et que le programme s'exécuterait en arrière-plan et afficherait (ou pas) sa sortie sur notre interface en python. Cependant n'ayant pas réussi à trouver les fonctions adéquates, cette feature a été mise de côté.

**PS :** vous pouvez à tout moment rajouter une nouvelle ligne de commentaire dans le fichier `options.conf`, pour cela il vous suffit de commencer la ligne par un `#`
