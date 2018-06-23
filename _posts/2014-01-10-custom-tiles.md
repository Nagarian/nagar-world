---
title: Générer une tuile personnaliser sur Windows Phone
wordpress_id: 462
wordpress_url: http://www.nagar-world.fr/2014/01/10/generer-une-tuile-personnaliser-sur/
date: '2014-01-10 09:37:00 -0600'
date_gmt: '2014-01-10 08:37:00 -0600'
categories:
- C#
- Windows Phone
tags:
- C#
- Windows Phone
- XAML
- background agent
---

L'un des avantages des applications Windows Phone par rapport à la concurrence vient des tuiles caractérisant l'OS. Celles-ci permettent aux utilisateurs de pouvoir récupérer des informations de la part de ces diverses applications sans avoir à la lancer, ou alors au contraire l'inciter à l'ouvrir pour voir du nouveau contenu.

Cependant, pour nous développeurs, Microsoft nous permet de customiser celles-ci, mais cela reste plus ou moins limité. En effet, nous pouvons modifier l'image de la tuile, une description (si l'on choisit le template Flip), le titre, un compteur, etc.. (Plus d'info [ici](http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202948(v=vs.105).aspx)) Mais après, nous ne pouvons pas par exemple modifier la police d'écriture du texte, sa disposition, son placement, etc ...

![Basic tile](/assets/images/uploads/2014/01/basicTile.png)

<!--more-->

L'un des avantages des applications Windows Phone par rapport à la concurrence vient des tuiles caractérisant l'OS. Celles-ci permettent aux utilisateurs de pouvoir récupérer des informations de la part de ces diverses applications sans avoir à la lancer, ou alors au contraire l'inciter à l'ouvrir pour voir du nouveau contenu.

Cependant, pour nous développeurs, Microsoft nous permet de customiser celles-ci, mais cela reste plus ou moins limité. En effet, nous pouvons modifier l'image de la tuile, une description (si l'on choisit le template Flip), le titre, un compteur, etc.. (Plus d'info [ici](http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202948(v=vs.105).aspx)) Mais après, nous ne pouvons pas par exemple modifier la police d'écriture du texte, sa disposition, son placement, etc ...

![Basic tile](/assets/images/uploads/2014/01/basicTile.png)

Bien que cela puisse suffire pour des applications comme les lecteurs de flux RSS, il arrive un moment où l'on souhaite faire quelque chose de plus poussé, comme pour celle de Bing Météo.

![Advanced tile](/assets/images/uploads/2014/01/avancedTile.png)

Mais la question que l'on se pose : "Comment font-ils?"

# WriteableBitmap à votre service !

L'astuce consiste à générer une image avec toutes les informations que l'on souhaite montrer, l'enregistrer et récupérer l'Uri permettant d'y accéder, puis la passer à notre méthode pour mettre à jour notre (nos) tuile(s). Pour cela, la classe `WriteableBitmap` possède une méthode fort pratique qui permet de convertir directement une composante XAML en un WriteableBitmap.

```csharp
var medBmp = new WriteableBitmap(691, 336); //Medium tile size
medBmp.Render(maTexteAEcrire, null);
```

Pour pouvoir l'utiliser, nous instancions donc un nouvel objet WriteableBitmap avec les dimensions que nous souhaitons pour notre image (336*336 pour les tiles carrés, 691*336 pour les tiles rectangulaires)

puis nous "dessinons" dedans grâce à la méthode `Render`, un `UIElement`, que l'on positionne grâce à une translation avec le second paramètre, qui est du type `Transform`, que l'on peut spécifier comme étant null si nous désirons positionner l'élément aux coordonnées 0,0 de notre image.

## Dessiner, oui, mais pas n'importe comment

A ce moment-là, vous pensez sûrement qu'il suffit juste d'instancier un UserControl ou de récupérer un DataTemplate et de l'utiliser directement dans la méthode. Cependant, vous rencontrerez un double problème, le premier est que tous les textes ne se positionnent pas correctement. Et les images ne se chargent pas.

![Fail](/assets/images/uploads/2014/01/fail0.png)

## Régler le positionnement

On pourrait donc essayer de créer une Grid dans le code, puis d'ajouter les éléments un par un, puis de mettre directement la Grid dans notre WriteableBitmap. Mais vous risquez d'obtenir le même résultat. Donc pour le coup, la méthode la plus efficace est de créer les éléments, un par un et de les rajouter au fur et à mesure sur le WriteableBitmap.

```csharp
var ratioText = new TextBlock();
ratioText.FontSize = 150;
ratioText.FontWeight = FontWeights.Normal;
ratioText.Text = "2,46";
ratioText.Foreground = new SolidColorBrush(Colors.White);
medBmp.Render(ratioText, new TranslateTransform() { X = ((691 - ratioText.ActualWidth) / 2), Y = ((336 - ratioText.ActualHeight) / 2) });
```

Dans cet exemple, je vous montre également comment résoudre le problème du positionnement. Pour cela, il faut donc positionner les éléments manuellement à partir d'une transformation. J'utilise donc un `TranslateTransform`, de plus puisque les tailles des tuiles sont fixes, nous pouvons centrer nos éléments grâce à un simple calcul comme ici.

A partir de là, vous avez toutes les cartes en main pour écrire où vous voulez, comme vous voulez et de la couleur que vous voulez sur votre tuile.

## Régler le cas des images

Positionner c'est bien mais sur une jolie image c'est mieux ! Donc intéressons-nous maintenant au problème des images.

Tout d'abord, il faut savoir que pour pouvoir dessiner dans un WriteableBitmap, il faut que tous les éléments aient été chargés en mémoire. De plus, lorsque nous voulons y insérer une image à partir d'un `BitmapImage`, le processus le crée, mais il charge son contenu dans un thread différent. Par conséquent, il nous faut nous abonner à l’événement ImageOpened et continuer la création de notre WriteableBitmap dans celui-ci.

```csharp
BitmapImage _largeImage = new BitmapImage(new Uri("/Assets/Tiles/BackFlipCycleTileLarge.png", UriKind.Relative));
_largeImage.CreateOptions = BitmapCreateOptions.IgnoreImageCache; 
_largeImage.ImageOpened += (s, e) =>
{
    //Continuer la création de l'image ici
};
```

Voilà maintenant vous savez construire une tile entièrement customisable, il vous faut juste réfléchir au design que vous désirez adopter pour votre tuile. En attendant, nous allons plutôt nous intéresser à comment mettre en place notre WriteableBitmap sur la tile de notre application.

# Enregistrer pour réutiliser

Lorsque l'on veut définir l'image avant ou arrière d'une tuile, nous pouvons seulement donner l'Uri de l'emplacement de l'image. Donc avec notre méthode, nous sommes obligés d’enregistrer quelque-part notre image, pour pouvoir l'attribuer à une tuile.

Cependant, une contrainte supplémentaire va venir s'ajouter par rapport à tout cela, en effet on pourrait tout simplement enregistrer l'image dans le dossier qui nous est imparti pour l'application, mais Windows Phone ne permet pas cela, car il existe un dossier spécial prévu pour cela, il s'agit du dossier `/Shared/ShellContent/`, vous pouvez y accéder de cette manière :

```csharp
medBmp.Invalidate();

using (var store = IsolatedStorageFile.GetUserStoreForApplication())
{
    var filename = "/Shared/ShellContent/TileBackgroundLarge.jpg";
    using (IsolatedStorageFile myIsolatedStorage = IsolatedStorageFile.GetUserStoreForApplication())
    {
        if (myIsolatedStorage.FileExists(filename))
        {
            myIsolatedStorage.DeleteFile(filename);
        }

        IsolatedStorageFileStream fileStream = myIsolatedStorage.CreateFile(filename);

        medBmp.SaveJpeg(fileStream, 691, 336, 0, 100);

        fileStream.Close();
        fileStream.Dispose();
    }
}

medBmp = null;

GC.Collect();
```

Pour information, la méthode `Invalidate()` de `WriteableBitmap` permet à l'image de se redessiner en entier, et éviter des bugs dans celle-ci. Ensuite, la condition permet de créer le dossier au cas où il n'existerait pas (cas peu probable, mais on sait jamais ^^). Puis il suffit d'utiliser la fonction `SaveJpeg` du `WritableBitmap` pour sauvegarder le fichier. Maintenant il ne reste plus qu'à mettre à jour la tuile et nous aurons terminé.

Les deux dernières lignes forcent la libération des ressources, ce n'est pas forcément nécessaire cependant j'ai pu lire sur [ce topic de StackOverflow](http://stackoverflow.com/questions/14710838/writeablebitmap-memory-leak) qu'il pouvait y avoir des problèmes de performances.

La dernière difficulté reste à former l'Uri, pour l'image de la tile. Le dossier de sauvegarde où se trouve notre image est "isostore:/Shared/ShellContent/TileBackgroundLarge.jpg" ce qui nous donne :

```csharp
ShellTile.ActiveTiles.First().Update(new FlipTileData
{
    WideBackgroundImage = new Uri("isostore:/Shared/ShellContent/TileBackgroundLarge.jpg", UriKind.Absolute),
    BackgroundImage = new Uri("isostore:/Shared/ShellContent/TileBackgroundNormal.jpg", UriKind.Absolute),
    Title = "",
    BackTitle = ""
});
```

> NB : La deuxième image est créée de la même manière que la première.

Ce qui nous donne au total :

```csharp
BitmapImage _largeImage = new BitmapImage(new Uri("/Assets/Tiles/BackFlipCycleTileLarge.png", UriKind.Relative));
_largeImage.CreateOptions = BitmapCreateOptions.IgnoreImageCache;
_largeImage.ImageOpened += (s, e) =>
{
    var medBmp = new WriteableBitmap(691, 336); //Medium tile size

    //Une fois que l'image est chargé on créer un UIElement de type Image et on insère le rendu à l'intérieur
    var medImage = new Image { Source = image };
    medBmp.Render(medImage, null);

    //à ce moment on écrit toute les informations qui l'on veut dessus

    //Attention cela peut paraître logique mais pensez à l'ordre dans lequel vos éléments, à chaque fois que l'on rajoute un éléments on écrit par dessus les autres.
    var ratioText = new TextBlock();
    ratioText.FontSize = 150;
    ratioText.FontWeight = FontWeights.Normal;
    ratioText.Text = "2,42";
    ratioText.VerticalAlignment = System.Windows.VerticalAlignment.Center;
    ratioText.HorizontalAlignment = System.Windows.HorizontalAlignment.Center;
    ratioText.Foreground = new SolidColorBrush(Colors.White);
    medBmp.Render(ratioText, new TranslateTransform()
    {
        X = ((691 - ratioText.ActualWidth) / 2),
        Y = ((336 - ratioText.ActualHeight) / 2)
    });

    //Une fois tout les éléments à mettre sur l'image, on demande à l'OS de redessiner l'ensemble
    medBmp.Invalidate();

    //Et ensuite on enregistre notre image
    using (var store = IsolatedStorageFile.GetUserStoreForApplication())
    {
        var filename = "/Shared/ShellContent/TileBackgroundLarge.jpg";
        using (IsolatedStorageFile myIsolatedStorage = IsolatedStorageFile.GetUserStoreForApplication())
        {
            if (myIsolatedStorage.FileExists(filename))
            {
                myIsolatedStorage.DeleteFile(filename);
            }

            IsolatedStorageFileStream fileStream = myIsolatedStorage.CreateFile(filename);
            medBmp.SaveJpeg(fileStream, 691, 336, 0, 100);
            fileStream.Close();
            fileStream.Dispose();
        }
    }

    medBmp = null;

    GC.Collect();

    ShellTile.ActiveTiles.First().Update(new FlipTileData
    {
        WideBackgroundImage = new Uri("isostore:/Shared/ShellContent/TileBackgroundLarge.jpg", UriKind.Absolute),
        Title = "",
        BackTitle = ""
    });
};
```

Pour plus d'informations, comme gérer la transparence, je vous invite à aller [voir ce lien-là](http://www.robfe.com/2012/02/building-on-the-fly-images-for-wp7-live-tiles/), il pourra vous apporter quelques informations supplémentaires.
