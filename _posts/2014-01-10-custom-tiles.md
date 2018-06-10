---
layout: post
status: publish
published: true
title: Générer une tuile personnaliser sur Windows Phone
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 462
wordpress_url: http://nagarianblog.azurewebsites.net/2014/01/10/generer-une-tuile-personnaliser-sur/
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
comments: []
---
<p>L'un des avantages des applications Windows Phone par rapport à la concurrence vient des tuiles caractérisant l'OS. Celles-ci permettent aux utilisateurs de pouvoir récupérer des informations de la part de ces diverses applications sans avoir à la lancer, ou alors au contraire l'inciter à l'ouvrir pour voir du nouveau contenu.</p>
<p>Cependant, pour nous développeurs, Microsoft nous permet de customiser celles-ci, mais cela reste plus ou moins limité. En effet, nous pouvons modifier l'image de la tuile, une description (si l'on choisit le template Flip), le titre, un compteur, etc.. (Plus d'info <a href="http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202948(v=vs.105).aspx">ici</a>) Mais après, nous ne pouvons pas par exemple modifier la police d'écriture du texte, sa disposition, son placement, etc ...</p>
<p><img class="wp-image-952 size-medium aligncenter" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/basicTile-1-300x152.png" alt="basicTile-1" width="300" height="152" /><br />
<!--more-->L'un des avantages des applications Windows Phone par rapport à la concurrence vient des tuiles caractérisant l'OS. Celles-ci permettent aux utilisateurs de pouvoir récupérer des informations de la part de ces diverses applications sans avoir à la lancer, ou alors au contraire l'inciter à l'ouvrir pour voir du nouveau contenu.</p>
<p>Cependant, pour nous développeurs, Microsoft nous permet de customiser celles-ci, mais cela reste plus ou moins limité. En effet, nous pouvons modifier l'image de la tuile, une description (si l'on choisit le template Flip), le titre, un compteur, etc.. (Plus d'info <a href="http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202948(v=vs.105).aspx">ici</a>) Mais après, nous ne pouvons pas par exemple modifier la police d'écriture du texte, sa disposition, son placement, etc ...</p>
<div class="separator" style="clear: both; text-align: center;"><a style="margin-left: 1em; margin-right: 1em;" href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/basicTile-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/basicTile-1.png" alt="" width="320" height="161" border="0" /></a></div>
<p>Bien que cela puisse suffire pour des applications comme les lecteurs de flux RSS, il arrive un moment où l'on souhaite faire quelque chose de plus poussé, comme pour celle de Bing Météo.</p>
<div class="separator" style="clear: both; text-align: center;"><a style="margin-left: 1em; margin-right: 1em;" href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/avancedTile-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/avancedTile-1.png" alt="" width="640" height="160" border="0" /></a></div>
<p>Mais la question que l'on se pose : "Comment font-ils?"</p>
<h2>WriteableBitmap à votre service !</h2>
<div>L'astuce consiste à générer une image avec toutes les informations que l'on souhaite montrer, l'enregistrer et récupérer l'Uri permettant d'y accéder, puis la passer à notre méthode pour mettre à jour notre (nos) tuile(s). Pour cela, la classe <b>WriteableBitmap </b>possède une méthode fort pratique qui permet de convertir directement une composante XAML en un WriteableBitmap.</div>
<p>[csharp]var medBmp = new WriteableBitmap(691, 336);//Medium tile size<br />
medBmp.Render(maTexteAEcrire, null);<br />
[/csharp]</p>
<p>Pour pouvoir l'utiliser, nous instancions donc un nouvel objet WriteableBitmap avec les dimensions que nous souhaitons pour notre image (336*336 pour les tiles carrés, 691*336 pour les tiles rectangulaires)<br />
puis nous "dessinons" dedans grâce à la méthode <b>Render</b>, un <b>UIElement</b>, que l'on positionne grâce à une translation avec le second paramètre, qui est du type <b>Transform</b>, que l'on peut spécifier comme étant null si nous désirons positionner l'élément aux coordonnées 0,0 de notre image.</p>
<h4>Dessiner, oui, mais pas n'importe comment</h4>
<div>A ce moment-là, vous pensez sûrement qu'il suffit juste d'instancier un UserControl ou de récupérer un DataTemplate et de l'utiliser directement dans la méthode. Cependant, vous rencontrerez un double problème, le premier est que tous les textes ne se positionnent pas correctement. Et les images ne se chargent pas.</div>
<div class="separator" style="clear: both; text-align: center;"></div>
<div class="separator" style="clear: both; text-align: center;"><a style="margin-left: 1em; margin-right: 1em;" href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/fail0-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/01/fail0-1.png" alt="" width="640" height="358" border="0" /></a></div>
<div>
<h4>Régler le positionnement</h4>
</div>
<div>On pourrait donc essayer de créer une Grid dans le code, puis d'ajouter les éléments un par un, puis de mettre directement la Grid dans notre WriteableBitmap. Mais vous risquez d'obtenir le même résultat. Donc pour le coup, la méthode la plus efficace est de créer les éléments, un par un et de les rajouter au fur et à mesure sur le WriteableBitmap.</div>
<p>[csharp]var ratioText = new TextBlock();<br />
ratioText.FontSize = 150;<br />
ratioText.FontWeight = FontWeights.Normal;<br />
ratioText.Text = &quot;2,46&quot;;<br />
ratioText.Foreground = new SolidColorBrush(Colors.White);<br />
medBmp.Render(ratioText, new TranslateTransform() { X = ((691 - ratioText.ActualWidth) / 2), Y = ((336 - ratioText.ActualHeight) / 2) });<br />
[/csharp]</p>
<div>Dans cet exemple, je vous montre également comment résoudre le problème du positionnement. Pour cela, il faut donc positionner les éléments manuellement à partir d'une transformation. J'utilise donc un <b>TranslateTransform</b>, de plus puisque les tailles des tuiles sont fixes, nous pouvons centrer nos éléments grâce à un simple calcul comme ici.</div>
<div>A partir de là, vous avez toutes les cartes en main pour écrire où vous voulez, comme vous voulez et de la couleur que vous voulez sur votre tuile.</div>
<h4>Régler le cas des images</h4>
<div>Positionner c'est bien mais sur une jolie image c'est mieux ! Donc intéressons-nous maintenant au problème des images.<br />
Tout d'abord, il faut savoir que pour pouvoir dessiner dans un WriteableBitmap, il faut que tous les éléments aient été chargés en mémoire. De plus, lorsque nous voulons y insérer une image à partir d'un <b>BitmapImage</b>, le processus le crée, mais il charge son contenu dans un thread différent. Par conséquent, il nous faut nous abonner à l’événement ImageOpened et continuer la création de notre WriteableBitmap dans celui-ci.</div>
<p>[csharp]BitmapImage _largeImage = new BitmapImage(new Uri(&quot;/Assets/Tiles/BackFlipCycleTileLarge.png&quot;, UriKind.Relative)); _largeImage.CreateOptions = BitmapCreateOptions.IgnoreImageCache; _largeImage.ImageOpened += (s, e) =&amp;amp;amp;amp;gt; { //Continuer la création de l'image ici };<br />
[/csharp]</p>
<div>Voilà maintenant vous savez construire une tile entièrement customisable, il vous faut juste réfléchir au design que vous désirez adopter pour votre tuile. En attendant, nous allons plutôt nous intéresser à comment mettre en place notre WriteableBitmap sur la tile de notre application.</div>
<h2>Enregistrer pour réutiliser</h2>
<div>Lorsque l'on veut définir l'image avant ou arrière d'une tuile, nous pouvons seulement donner l'Uri de l'emplacement de l'image. Donc avec notre méthode, nous sommes obligés d’enregistrer quelque-part notre image, pour pouvoir l'attribuer à une tuile.<br />
Cependant, une contrainte supplémentaire va venir s'ajouter par rapport à tout cela, en effet on pourrait tout simplement enregistrer l'image dans le dossier qui nous est imparti pour l'application, mais Windows Phone ne permet pas cela, car il existe un dossier spécial prévu pour cela, il s'agit du dossier "/Shared/ShellContent/", vous pouvez y accéder de cette manière :</div>
<p>[csharp]medBmp.Invalidate();<br />
using (var store = IsolatedStorageFile.GetUserStoreForApplication())<br />
{<br />
	var filename = &quot;/Shared/ShellContent/TileBackgroundLarge.jpg&quot;;<br />
	using (IsolatedStorageFile myIsolatedStorage = IsolatedStorageFile.GetUserStoreForApplication())<br />
	{<br />
		if (myIsolatedStorage.FileExists(filename))<br />
		{<br />
			myIsolatedStorage.DeleteFile(filename);<br />
		}</p>
<p>		IsolatedStorageFileStream fileStream = myIsolatedStorage.CreateFile(filename);<br />
		medBmp.SaveJpeg(fileStream, 691, 336, 0, 100);<br />
		fileStream.Close();<br />
		fileStream.Dispose();<br />
	}<br />
}</p>
<p>medBmp = null;<br />
GC.Collect();<br />
[/csharp]</p>
<div>Pour information, la méthode <b>Invalidate()</b> de WriteableBitmap permet à l'image de se redessiner en entier, et éviter des bugs dans celle-ci. Ensuite, la condition permet de créer le dossier au cas où il n'existerait pas (cas peu probable, mais on sait jamais ^^). Puis il suffit d'utiliser la fonction <b>SaveJpeg </b>du WritableBitmap pour sauvegarder le fichier. Maintenant il ne reste plus qu'à mettre à jour la tuile et nous aurons terminé.<br />
Les deux dernières lignes forcent la libération des ressources, ce n'est pas forcément nécessaire cependant j'ai pu lire sur <a href="http://stackoverflow.com/questions/14710838/writeablebitmap-memory-leak">ce topic de StackOverflow</a> qu'il pouvait y avoir des problèmes de performances.</div>
<div>La dernière difficulté reste à former l'Uri, pour l'image de la tile. Le dossier de sauvegarde où se trouve notre image est "isostore:/Shared/ShellContent/TileBackgroundLarge.jpg" ce qui nous donne :</div>
<p>[csharp]ShellTile.ActiveTiles.First().Update(new FlipTileData<br />
{<br />
    WideBackgroundImage = new Uri(&quot;isostore:/Shared/ShellContent/TileBackgroundLarge.jpg&quot;, UriKind.Absolute),<br />
    BackgroundImage = new Uri(&quot;isostore:/Shared/ShellContent/TileBackgroundNormal.jpg&quot;, UriKind.Absolute),<br />
    Title = &quot;&quot;,<br />
    BackTitle = &quot;&quot;<br />
});<br />
[/csharp]</p>
<div>NB : La deuxième image est créée de la même manière que la première.</div>
<p>Ce qui nous donne au total :</p>
<p>[csharp]BitmapImage _largeImage = new BitmapImage(new Uri(&quot;/Assets/Tiles/BackFlipCycleTileLarge.png&quot;, UriKind.Relative));<br />
_largeImage.CreateOptions = BitmapCreateOptions.IgnoreImageCache;<br />
_largeImage.ImageOpened += (s, e) =&amp;amp;amp;amp;gt;;<br />
{<br />
    var medBmp = new WriteableBitmap(691, 336);//Medium tile size </p>
<p>    //Une fois que l'image est chargé on créer un UIElement de type Image et on insère le rendu à l'intérieur<br />
    var medImage = new Image { Source = image };<br />
    medBmp.Render(medImage, null);</p>
<p>    //à ce moment on écrit toute les informations qui l'on veut dessus<br />
    //Attention cela peut paraître logique mais pensez à l'ordre dans lequel vos éléments, à chaque fois que l'on rajoute un éléments on écrit par dessus les autres.<br />
    var ratioText = new TextBlock();<br />
    ratioText.FontSize = 150;<br />
    ratioText.FontWeight = FontWeights.Normal;<br />
    ratioText.Text = &quot;2,42&quot;;<br />
    ratioText.VerticalAlignment = System.Windows.VerticalAlignment.Center;<br />
    ratioText.HorizontalAlignment = System.Windows.HorizontalAlignment.Center;<br />
    ratioText.Foreground = new SolidColorBrush(Colors.White);<br />
    medBmp.Render(ratioText, new TranslateTransform() { X = ((691 - ratioText.ActualWidth) / 2), Y = ((336 - ratioText.ActualHeight) / 2) });</p>
<p>    //Une fois tout les éléments à mettre sur l'image, on demande à l'OS de redessiner l'ensemble<br />
    medBmp.Invalidate();</p>
<p>    //Et ensuite on enregistre notre image<br />
    using (var store = IsolatedStorageFile.GetUserStoreForApplication())<br />
    {<br />
        var filename = &quot;/Shared/ShellContent/TileBackgroundLarge.jpg&quot;;</p>
<p>        using (IsolatedStorageFile myIsolatedStorage = IsolatedStorageFile.GetUserStoreForApplication())<br />
        {<br />
            if (myIsolatedStorage.FileExists(filename))<br />
            {<br />
                myIsolatedStorage.DeleteFile(filename);<br />
            }<br />
            IsolatedStorageFileStream fileStream = myIsolatedStorage.CreateFile(filename);</p>
<p>            medBmp.SaveJpeg(fileStream, 691, 336, 0, 100);<br />
            fileStream.Close();<br />
            fileStream.Dispose();<br />
        }</p>
<p>    }</p>
<p>    medBmp = null;<br />
    GC.Collect();</p>
<p>    ShellTile.ActiveTiles.First().Update(new FlipTileData<br />
    {<br />
        WideBackgroundImage = new Uri(&quot;isostore:/Shared/ShellContent/TileBackgroundLarge.jpg&quot;, UriKind.Absolute),<br />
        Title = &quot;&quot;,<br />
        BackTitle = &quot;&quot;<br />
    });<br />
};<br />
[/csharp]</p>
<div>Pour plus d'informations, comme gérer la transparence, je vous invite à aller <a href="http://www.robfe.com/2012/02/building-on-the-fly-images-for-wp7-live-tiles/">voir ce lien-là</a>, il pourra vous apporter quelques informations supplémentaires.</div>
