---
layout: post
status: publish
published: true
title: St'hack 2014 Dungeon of Lol Write-Up
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 432
wordpress_url: http://nagarianblog.azurewebsites.net/2014/03/16/sthack-2014-dungeon-of-lol-write-up-2/
date: '2014-03-16 15:06:00 -0500'
date_gmt: '2014-03-16 14:06:00 -0500'
categories:
- CTF
- Ghost in the Shellcode
tags:
- CTF
- ghost in the shellcode
- sécurité informatique
comments: []
---
<p>Ce week-end se tenait la St'hack, un autre ctf tout comme Ghost In The ShellCode. Celui-ci ce déroule à Bordeaux, et cela a été l'occasion de participer à une journée de conférence, et une soirée de challenges.<br />
Durant celle-ci, j'ai réussi à résoudre une épreuve, et je vous propose donc de découvrir la manière dont je l'ai résolu. Il s'agissait de l'épreuve "Dungeon Of Lol"<br />
<!--more--><br />
Ce week-end se tenait la St'hack, un autre ctf tout comme Ghost In The ShellCode. Celui-ci ce déroule à Bordeaux, et cela a été l'occasion de participer à une journée de conférence, et une soirée de challenges. Plus d'info <a href="https://www.sthack.fr/">à cette adresse</a>.</p>
<p>Durant le CTF se trouvait une épreuve "Dungeon Of Lol", le but de cette épreuve était de retrouver le flag dissimulés au travers d'un jeu codé avec Unity.</p>
<p><a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Accueil-1.png" rel="attachment wp-att-822"><img class="size-medium_large wp-image-822 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Accueil-1-768x599.png" alt="Sthack-DoL-Accueil-1" width="700" height="546" /></a></p>
<h2>1ere partie : Découverte du challenge et hypothèses</h2>
<p>Le jeu se compose d'un grille de 4 salles sur 4, et il nous est permis de ne changer que de 8 salles, à l'issu de cela soit on gagne, soit on perd. En relisant, l’énoncé on découvre que le flag consiste à trouver le bon chemin à parcourir pour trouver la sortie. Cependant en re-testant plusieurs fois le jeu on se rend compte que celui-ci comporte des bugs. Ainsi, on peut refaire plusieurs fois le même chemin sans que l'issu soit la même.<br />
De plus le point de spawn de notre personnage est aléatoire entre 2 salles, la 0 0 et la 0 1. On en déduit que le flag ne peut pas être la suite de chiffre correspondant au salle parcouru. Donc la seconde hypothèse est que flag correspondant aux directions prises par notre personnage.<br />
<a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Game1-2.png" rel="attachment wp-att-812"><img class="size-medium_large wp-image-812 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Game1-2-768x599.png" alt="Sthack-DoL-Game1-2" width="700" height="546" /></a></p>
<h2>2eme partie : Décompilation et analyse</h2>
<p>Une fois que l'on sait ce que l'on cherche, il nous faut regarder ce que l'on a à notre disposition. Pour résumer en dehors, des dlls Unity, System et Mono (librairie utilisés pour le portage de code sur les autres plateformes); les ressources graphiques, on trouve 3 éléments que l'on peut exploiter :</p>
<ul>
<li>dungeonoflol.exe, l'éxécutable permettant de lancer le jeu</li>
<li>Assembly-CSharp.dll, une dll qui à l'air de contenir toutes la logique du jeu</li>
<li>YeOldeContent.dll, une dll qui a première vue n'a rien à faire ici, c'est louche! (surtout qu'elle se trouve dans un dossier Plugins)</li>
</ul>
<p>Le plus intéressant à étudier en premier lieu, c'est l'Assembly-CSharp.dll, donc c'est le moment de sortir JustDecompile ou un équivalent (JetBrains, ...)<br />
<a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile-1.png" rel="attachment wp-att-842"><img class="size-medium_large wp-image-842 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile-1-768x417.png" alt="Sthack-DoL-Decompile-1" width="700" height="380" /></a><br />
En regardant les premières classes, on tombe rapidement sur DungeonGenerator avec une variable nommé :</p>
<p>[csharp]public string Ox080085 = &quot;FlagBitch&quot;;[/csharp]</p>
<p>Après quelques recherche dans tout la DLL, il semblerait qu'il s'agisse d'un troll. x)</p>
<p><a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile2-1.png" rel="attachment wp-att-852"><img class="size-medium_large wp-image-852 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile2-1-768x417.png" alt="Sthack-DoL-Decompile2-1" width="700" height="380" /></a></p>
<p>On arrive à la classe HeroMove, qui possède une fonction CheckCollision(Vector3 movement), mais également elle fait l'importation de la DLL bizarre repéré auparavant : YeOldeContent.dll.</p>
<p>A partir de là, on peut soit explorer la piste de l'importation de la dll, cependant, en essayant de l'ouvrir avec JustDecompile, celui-ci refuse de l'ouvrir : elle n'est pas coder en CSharp! Il faut donc passer par IDA. Cependant après l'avoir ouvert avec, celle-ci à l'air suffisamment complexe pour ne pas être comprise facilement.</p>
<p>J'ai donc décidé de mettre de côté cette piste. Malgré tout, vous pouvez toujours allez lire <a href="http://cubeslam.net/2014/03/15/sthack-unity2d-dllimport-and-monty-python/">cet article</a> écrit par l'auteur du challenge. Il s'agit de la solution initiale qui avait été prévu!</p>
<h2>3eme partie : Bourrinage et prise de tête</h2>
<p>Je suis donc repartit sur l'étude de la fonction CheckCollision, celle-ci comporte la condition qui détermine la fin du jeu, c'est-à-dire dès que l'on a parcouru 8 salles on vérifie si on a bon et on s'arrête. J'ai donc eu l'idée d'aller modifier cette condition là afin de faire en sorte que dès que l'on a parcouru la deuxième salle, on fait la condition de fin. Pour cela, j'ai utilisé IDA afin de localiser le code hexa à modifier.<br />
<a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile3-1.png" rel="attachment wp-att-862"><img class="size-medium_large wp-image-862 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile3-1-768x417.png" alt="Sthack-DoL-Decompile3-1" width="700" height="380" /></a><br />
Puis une fois localiser, il suffit d'aller modifier le code hexa de la condition :<br />
<code>ldc.i4.8</code><br />
pour le passer en<br />
<code>ldc.i4.2</code><br />
soit modifier 1E en 18 à l'aide d'un éditeur hexa comme par exemple hexplorer.<br />
<a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile4-1.png" rel="attachment wp-att-872"><img class="size-full wp-image-872 aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/03/Sthack-DoL-Decompile4-1.png" alt="Sthack-DoL-Decompile4-1" width="710" height="411" /></a><br />
Grâce à cela, il suffit de jouer au jeu et dès que l'on passe à la deuxième salle, le jeu va exécuter la condition et donc checker si le chemin emprunter correspond au chemin voulu. et vu que la fonction a été bien coder il va seulement vérifier le parcours que l'on a fait (ce qui nous évite de faire crasher le programme ce qui ne nous aurait pas arranger!)<br />
De ce fait, nous saurons si le premier mouvement est correct dès qu'on l'aura effectuer. il ne nous reste donc plus qu'à re-modifier  l'hexa de la DLL en l'incrémentant et faire les test nécessaire en jouant au jeu afin de trouver le bon chemin. Et petit à petit, on découvre la totalité du chemin et on obtient le flag nécessaire à la validation du challenge.</p>
<p>Ainsi le flag à trouver était "RightDownDownLeftDownRightDown"</p>
