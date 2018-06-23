---
title: Level Up +1 n'est pas ++
wordpress_id: 442
wordpress_url: http://www.nagar-world.fr/2014/01/27/level-up-1-nest-pas-2/
date: '2014-01-27 20:56:00 -0600'
date_gmt: '2014-01-27 19:56:00 -0600'
categories:
- CTF
- Ghost in the Shellcode
tags: []
---

Lors du CTF Ghost In The ShellCode, j'ai voulu faire un brute-forcer afin de cracker une serial constituant le flag d'une épreuve (cf [article précédent]({% post_url 2014-01-27-ghost-in-the-shellcode-1 %})).

Je suis partie sur une fonction récursive, qui va se rappeler elle-même en incrémentant la valeur à tester et faire le test.Cependant je me suis heurter à une petit détail que l'on a tendance à oublier : **la différence entre ++ et + 1**...

<!--more-->

Lors du CTF Ghost In The ShellCode, j'ai voulu faire un brute-forcer afin de cracker une serial constituant le flag d'une épreuve (cf [article précédent]({% post_url 2014-01-27-ghost-in-the-shellcode-1 %})).

Je suis partie sur une fonction récursive, qui va se rappeler elle-même en incrémentant la valeur à tester et faire le test.

```csharp
static void brute(int imbrication)
{
  int serial = 0;
  for (int j = 0; j &amp;amp;lt; 33; j++)
  {
    int i = (j == 32)? 0 : j + 1;
    if (imbrication &amp;amp;lt; 19)
    {
      brute(imbrication++);
    }

    serialToTest[imbrication] = i;

    if (ProductKeyVerifier.VerifyKeySimplify(serialToTest, out serial))
    {
      Console.WriteLine(serial.ToString());
      return;
    }
  }
}
```

Cependant aux vues des résultats retournés, quelque chose ne marchait pas comme il le devrait. En effet, une fois que le débugger est arrivé à 19 (CAD que `imbrication` soit égal à 19) , qu'il est fait ses 33 tours dans le for et donc qu'il remonte d'un niveau, la variable imbrication qui se trouve dans la stack et qui se duplique à chaque fois que l'on descend d'un niveau aurait dût être à 18, mais ce n'est pas le cas, elle était à 19 ! =O

![example de code](/assets/images/uploads/2014/01/Sans-titre.png)

# Mais comment cela se fait ?

Le problème réside lors de l'appel à la fonction brute(imbrication++); En effet, au lieu de faire

```csharp
int imbrication_copy = imbrication +1;
brute(imbrcation_copy);
```

Notre machine va plutôt faire :

```csharp
imbrication = imbrication + 1;
brute(imbrication);
```

En voyant cela, on comprend que `maVariable++` est en fait une fonction (chose que l'on oublie) et que par conséquent elle est exécutée avant d’appeler notre autre fonction. Et donc, il est normal que notre variable reste incrémenter à la sortie de notre fonction car elle modifie sa valeur au lieu de nous transmettre une copie.

# La solution ?

Le problème est donc identifié ! Lorsque l'on appelle une fonction et que l'on passe en argument une variable++, la variable sera incrémentée puis sera passée en argument. Donc, si l'on veut passer en argument une variable augmenté de 1 sans modifier celle-ci dans notre fonction actuelle, il faut donc marquer explicitement.

```csharp
brute(imbrication + 1);
```

![Well done](/assets/images/uploads/2014/01/Well-20Done-20-.jpg)
