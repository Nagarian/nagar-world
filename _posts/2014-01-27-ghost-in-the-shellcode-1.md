---
layout: post
status: publish
published: true
title: Fais moi voir ce que tu as dans le ventre !
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 452
wordpress_url: http://nagarianblog.azurewebsites.net/2014/01/27/fais-moi-voir-ce-que-tu-as-dans-le/
date: '2014-01-27 19:37:00 -0600'
date_gmt: '2014-01-27 18:37:00 -0600'
categories:
- CTF
- Ghost in the Shellcode
tags:
- CTF
- ghost in the shellcode
- sécurité informatique
- JustDecompile
comments: []
---
<p>Premier CTF dans le cadre du labo sécurité, celui de Ghost In The ShellCode. Dans celui-ci j'ai appris quelques notions plus ou moins sympathique. Par exemple, j'ai découvert un logiciel plutôt complet, JustDecompile de Telerik...</p>
<div class="separator" style="background: black; clear: both; margin: 0 5; text-align: center;"><img src="http://ghostintheshellcode.com/img/gitsc-logo.png" alt="" border="0" /></div>
<p><!--more--></p>
<div>Le week-end dernier je me suis initié aux joies des CTF <a href="http://ghostintheshellcode.com/">Ghost In The Shell Code</a> dans le cadre du labo sécurité informatique présent dans mon école. Pour ceux qui ne savent pas ce que c'est qu'un CTF, ou plutôt Capture The Flag, il s'agit d'une compétition par équipes dans lequel chacune des équipes doit réussir à résoudre le plus de challenges possible dans le temps imparti (pour celui-là le délai était de quarante-huit heures). Pour plus de détails, vous pouvez lire ce <a href="http://en.wikipedia.org/wiki/Capture_the_flag#Computer_security">paragraphe-là</a>.</div>
<div>
<p>[embed]https://www.youtube.com/embed/qzDyqWHzhjA[/embed]</p>
</div>
<div>Bref, pour en revenir sur le but de mon article, il se trouve que durant ce CTF, ils ont eu l'excellente idée de mettre toutes les épreuves en relation dans un jeu 3D réalisé avec Unity. Et une des épreuves disponible consister à trouver une serial à rentrer dans le jeu afin d'accéder à une zone non permise.</div>
<div><a href="http://2.bp.blogspot.com/-96Z3DwSeBz4/UuaqU5YUhUI/AAAAAAAAACk/JVuHJ68sfaQ/s1600/Capture+d%E2%80%99%C3%A9cran+(72).png"><img src="http://2.bp.blogspot.com/-96Z3DwSeBz4/UuaqU5YUhUI/AAAAAAAAACk/JVuHJ68sfaQ/s1600/Capture+d%E2%80%99%C3%A9cran+(72).png" alt="Capture d'écran" width="100%" /></a></div>
<div>Donc après quelques recherches et surtout laisser une oreille attentive sur le canal IRC mis en place pour l'occasion, je découvre un magnifique lien vers un programme permettant de décompiler du C#, Telerik JustDecompile (<a href="http://www.telerik.com/products/decompiler.aspx">lien de téléchargement</a>). Ce logiciel est entièrement gratuit et est suffisamment complet, donc quelques minutes après je me suis retrouvé avec le code source de la classe vérifiant cette serial =D</div>
<div><a href="http://1.bp.blogspot.com/-jaauMyJ_Ja0/UuY7QnLM5wI/AAAAAAAAACU/jn72JAqQ0Yw/s1600/Capture+d%E2%80%99%C3%A9cran+(71).png"><img src="http://1.bp.blogspot.com/-jaauMyJ_Ja0/UuY7QnLM5wI/AAAAAAAAACU/jn72JAqQ0Yw/s1600/Capture+d%E2%80%99%C3%A9cran+(71).png" alt="Capture d'écran de JustDecompile" width="100%" /></a></div>
<div>Oh joie, il ne reste plus qu'à comprendre le fonctionnement de tout cela !Ainsi ce logiciel permet de récupérer le code source de tous les programmes codés en C# y compris les DLLs. Donc si vous avez besoin d'aller modifier quelques octets vous saurez comment faire. Sinon pour les autres vous pourrez récupérer le code source de vos programmes compilés dont vous avez malheureusement perdus les sources.</div>
