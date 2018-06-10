---
layout: post
status: publish
published: true
title: Level Up +1 n'est pas ++
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 442
wordpress_url: http://nagarianblog.azurewebsites.net/2014/01/27/level-up-1-nest-pas-2/
date: '2014-01-27 20:56:00 -0600'
date_gmt: '2014-01-27 19:56:00 -0600'
categories:
- CTF
- Ghost in the Shellcode
tags: []
comments: []
---
<div>Lors du CTF Ghost In The ShellCode, j'ai voulu faire un brute-forcer afin de cracker une serial constituant le flag d'une épreuve (cf <a href="http://www.nagar-world.fr/2014/01/fais-moi-voir-ce-que-tu-as-dans-le.html">article précédent</a>).<br />
Je suis partie sur une fonction récursive, qui va se rappeler elle-même en incrémentant la valeur à tester et faire le test.Cependant je me suis heurter à une petit détail que l'on a tendance à oublier : <b>la différence entre ++ et + 1</b> ...<br />
<!--more--><br />
Lors du CTF Ghost In The ShellCode, j'ai voulu faire un brute-forcer afin de cracker une serial constituant le flag d'une épreuve (cf <a href="http://www.nagar-world.fr/2014/01/fais-moi-voir-ce-que-tu-as-dans-le.html">article précédent</a>).<br />
Je suis partie sur une fonction récursive, qui va se rappeler elle-même en incrémentant la valeur à tester et faire le test.</div>
<p>[csharp]static void brute(int imbrication)<br />
{<br />
 int serial = 0;<br />
 for (int j = 0; j &amp;amp;lt; 33; j++)<br />
 {<br />
  int i = (j == 32)? 0 : j + 1;<br />
  if (imbrication &amp;amp;lt; 19)<br />
  {<br />
   brute(imbrication++);<br />
  }</p>
<p>  serialToTest[imbrication] = i;</p>
<p>  if (ProductKeyVerifier.VerifyKeySimplify(serialToTest, out serial))<br />
  {<br />
   Console.WriteLine(serial.ToString());<br />
   return;<br />
  }<br />
 }<br />
}<br />
[/csharp]</p>
<div>Cependant aux vues des résultats retournés, quelque chose ne marchait pas comme il le devrait. En effet, une fois que le débugger est arrivé à 19 (CAD que <strong>imbrication</strong> soit égal à 19) , qu'il est fait ses 33 tours dans le for et donc qu'il remonte d'un niveau, la variable imbrication qui se trouve dans la stack et qui se duplique à chaque fois que l'on descend d'un niveau aurait dût être à 18, mais ce n'est pas le cas, elle était à 19 ! =O</div>
<p><a style="margin-left: 1em; margin-right: 1em;" href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/Sans-titre-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/Sans-titre-1.png" alt="" width="640" height="360" border="0" /></a></p>
<h3>Mais comment cela se fait?</h3>
<div>Le problème réside lors de l'appel à la fonction brute(imbrication++); En effet, au lieu de faire</div>
<p>[csharp]int imbrication_copy = imbrication +1;<br />
brute(imbrcation_copy);<br />
[/csharp]</p>
<div>Notre machine va plutôt faire :</div>
<p>[csharp]imbrication = imbrication + 1;<br />
brute(imbrication);[/csharp]</p>
<div>En voyant cela, on comprend que <strong>maVariable++</strong> est en fait une fonction (chose que l'on oublie) et que par conséquent elle est exécutée avant d’appeler notre autre fonction. Et donc, il est normal que notre variable reste incrémenter à la sortie de notre fonction car elle modifie sa valeur au lieu de nous transmettre une copie.</div>
<h3>La solution ?</h3>
<div>Le problème est donc identifié ! Lorsque l'on appelle une fonction et que l'on passe en argument une variable++, la variable sera incrémentée puis sera passée en argument. Donc, si l'on veut passer en argument une variable augmenté de 1 sans modifier celle-ci dans notre fonction actuelle, il faut donc marquer explicitement</div>
<p>[csharp]brute(imbrication + 1);[/csharp]</p>
<p><a style="margin-left: 1em; margin-right: 1em;" href="http://zanyimages.com/Sports%20Lovers/Well%20Done%20!.jpg"><img src="http://zanyimages.com/Sports%20Lovers/Well%20Done%20!.jpg" alt="" width="320" height="286" border="0" /></a></p>
