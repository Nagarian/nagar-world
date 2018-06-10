---
layout: post
status: publish
published: true
title: 'Créer une applications Windows Modern-UI en C# : Comment choisir ?'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 372
wordpress_url: http://nagarianblog.azurewebsites.net/2014/10/18/creer-une-applications-windows-modern/
date: '2014-10-18 19:15:00 -0500'
date_gmt: '2014-10-18 18:15:00 -0500'
categories:
- C#
- Windows Phone
- Windows 8
tags:
- C#
- Labo WP
- Windows 8
- Windows Phone
- XAML
comments: []
---
<p>A l'heure actuelle, Microsoft est en cours d'unification de ses plateformes dans le but que les développeurs n'aient qu'un seul programme à maintenir à jour, et que ce même programme marche sur tout l'éco-système Windows, des ordinateurs aux téléphones, en passant par les tablettes (et bientôt sur XBox One, et les objets connectés)</p>
<p>Cependant, cette période de transition n'est pas terminée, et du fait de la fragmentation, une application sur Windows 8 n'utilisera pas les mêmes contrôles utilisateur, ni les mêmes fonctions que sur Windows Phone. Microsoft a donc opté pour une solution de médiation en maintenant les différents types d'applications, et en créant un nouveau type d'application : <strong>les applications universelles</strong>.</p>
<p>Celles-ci se basent sur le fonctionnement des applications Windows 8 donc WinRT. Mais elles possèdent une structure bien particulière. Mais le principal but de cet article est de savoir comment choisir le type de projet que l'on doit créer dans Visual Studio afin de produire l'application que l'on souhaite.<br />
<!--more--><br />
Afin d'illustrer, les différents types d'applications que l'on peut faire, j'ai repris un projet réalisé dans le cadre d'une initiation à Windows Phone que j'ai eu l'occasion de donné, et je l'ai porté sur les différents projets que l'on peut réaliser avec Visual Studio 2013. Pour le récupérer c'est par ici : <a href="https://github.com/Nagarian47/LaboWP_LePendu">https://github.com/Nagarian47/LaboWP_LePendu</a></p>
<h2>Les applications Windows 8</h2>
<p>[caption id="attachment_552" align="aligncenter" width="768"]<img class="size-medium_large wp-image-552" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/AppWindows-768x495.png" alt="Les applications Windows 8 WinRT" width="768" height="495" /> Les applications Windows 8 WinRT[/caption]</p>
<p>Avec l'arrivée de Windows 8, Microsoft a apporté un vent de fraîcheur au niveau des applications Windows. En effet, ils ont introduit des applications "sandboxé" et qui se lancent en plein écran, mais nous avons la possibilité de les "snapper". Mais du point de vue du programmeur, ils ont surtout dévoilé de nouvelle APIs permettant aux développeurs de coder dans le langage qu'ils souhaitent (C#, VB et JS) tout en leur garantissant que quelque soit le langage utilisé, tous se confondraient pour l'utilisateur. De plus, les contrôles ont un rendu et des comportements strictement identiques. Ces nouvelles APIs se regroupent sous l’appellation WinRT (pour WINdows RunTime)</p>
<p><a style="margin-left: 1em; margin-right: 1em;" href="http://blog.loicrebours.fr/wp-content/uploads/2012/05/winRT.png"><img src="http://blog.loicrebours.fr/wp-content/uploads/2012/05/winRT.png" alt="" width="640" height="318" border="0" /></a></p>
<p>WinRT a été l'occasion pour les ingénieurs de Microsoft, de réorganiser quasiment l'ensemble des apis Windows, et c'est justement là que réside le principal problème. En effet, en ayant modifié une partie du fonctionnement des librairies standard, le fait de porter une application sur la plateforme peut entraîner de la casse. Mais demande surtout de repenser certains concepts, comme pour la lecture d'un fichier texte par exemple (les <b>Streams</b> contre l'asynchronisme avec <b>await </b>et <b>async</b>)</p>
<p>Entre Windows 8 et 8.1, Microsoft a poursuivi son travail de portage des API et sur la dernière version en date, la majorité des fonctionnalités existantes ont été portés, en plus de l'ajout de nouvelles comme l'impression 3D par exemple. Dans la suite de l'article je ne parlerais plus de Windows 8, mais uniquement 8.1 car il n'est plus réellement intéressant de travailler en 8.0 et ce n'est pas Visual Studio 2013 qui va me contredire puisqu'il ne nous propose plus le choix !</p>
<p>Pour en revenir, sur la création de projet C# pour les <b>applis Windows 8.1</b>, nous avons donc un seul type de choix, il s'agit de <strong>WinRT</strong>.</p>
<h2>Les applications Windows Phone</h2>
<p>Avant de lancer Windows 8, Microsoft avait développé le système Windows Phone 7 et les applications tournés en Silverlight. Lors du passage sur la version 8 de Windows Phone, Silverlight est resté. Mais lors de la mise à jour vers 8.1 Microsoft a voulu franchir un cap, en proposant de faire des applications qui reposeraient sur les mêmes APIs que Windows 8.1. De ce fait, ils ont mis en place 2 catégories d'applications C# sur Windows Phone. Nous retrouvons donc :</p>
<ul>
<li>Les applications fonctionnant sous WinRT et compatible uniquement WP 8.1 (qui peuvent être convertis en Windows 8 très rapidement et "sans casse"</li>
<li>Les applications Silverlight compatibles soit 8.0 - 8.1, soit 8.1 only (ne fonctionnant que sous Windows Phone)</li>
</ul>
<p>[caption id="attachment_562" align="aligncenter" width="768"]<img class="size-medium_large wp-image-562" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/AppWindowsPhone1-768x495.png" alt="Les applications Windows Phone WinRT" width="768" height="495" /> Les applications Windows Phone WinRT[/caption]</p>
<p>Ainsi nous retrouvons ces 2 catégories lorsque l'on veut créer une application Windows Phone. Mais Microsoft voulant habituer les développeurs aux nouvelles APIs WinRT (pour avoir plus d'applications sur les 2 plateformes), a légèrement brouillé la vue des applications Silverlight. Pour cela ils ont mis les applications WinRT en premier dans la liste et il faut scroller pour voir les applis Silverlight.</p>
<p>[caption id="attachment_572" align="aligncenter" width="768"]<img class="size-medium_large wp-image-572" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/AppWindowsPhone2-768x495.png" alt="Les applications Silverlight" width="768" height="495" /> Les applications Silverlight[/caption]</p>
<p>Pour ce qui est des applications Silverlight, lorsque l'ont choisi ce type-là, il nous est ensuite demandé quelle version de Windows Phone nous voulons cibler Si vous choisissez 8.0 votre application sera disponible pour les téléphones sous 8.0 et 8.1 alors que si vous choisissez 8.1, elles ne seront disponibles que pour la dernière version du système.</p>
<p>Pour vous aider à choisir quelle version prendre, il vous faut connaître quels sont les majeures différences entre ces versions. En effet, sur une appli 8.0 vous aurez accès à toutes les fonctionnalités existant sur Windows Phone avant la venue de la mise à jour 8.1. Pour pouvoir utiliser les nouvelles fonctionnalités de 8.1 (comme le centre de notification par exemple) vous devrez prendre la version Silverlight 8.1 où la version WinRT. Pour choisir entre ces 2 versions restantes, le choix se fera en fonction des fonctionnalités systèmes que vous désirerez accéder. Par exemple :</p>
<ul>
<li>si votre app est une application de musique, vous devrez soit faire une appli Silverlight 8.0 soit une appli WinRT car la version Silverlight 8.1 ne supporte pas l'AudioBackgroundTask</li>
<li>si votre app utilise le presse-papier, les sonneries du téléphone, le lockscreen ou certaines autres choses, vous devrez faire une application Silverlight 8.0 ou 8.1</li>
</ul>
<div>Pour plus d'informations à ce niveau, je vous invite à aller lire <a href="http://msdn.microsoft.com/fr-FR/library/windows/apps/dn642082(v=vs.105).aspx">cette page du MSDN</a>, elle vous récapitule toutes les différences entre les différents types.</div>
<h2>Les applications Universelles</h2>
<p>[caption id="attachment_582" align="aligncenter" width="768"]<img class="size-medium_large wp-image-582" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/AppUniversal-768x495.png" alt="Les applications universelles" width="768" height="495" /> Les applications universelles[/caption]</p>
<p>Avec la sortie de Windows Phone 8.1, Microsoft a annoncé la sortie des applications universelles. Celles-ci permettent de n'avoir qu'un seul code source pour toutes les plateformes. Sur le papier, le concept est vraiment intéressant, mais la réalité est légèrement différente. En effet, lorsque nous créons une application universelle, nous nous retrouvons face à une solution qui ressemble à sa :</p>
<p>[caption id="attachment_592" align="aligncenter" width="386"]<img class="size-full wp-image-592" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/UniversalSolution.png" alt="La répartition d'une application universelle" width="386" height="399" /> La répartition d'une application universelle[/caption]</p>
<p>Comme vous pouvez le voir, nous avons un projet <b>Windows 8.1</b>, un projet <b>Windows Phone 8.1</b> et un "projet" particulier appelé <b>Shared</b>. Pour ce qui est des deux premiers, il s'agit de projet du type WinRT comme nous l'avons vu précédemment. Il n'y a strictement <b>aucune différence entre un projet Universal et sa version classique WinRT</b>. La seule chose à retenir entre un projet WinRT Windows et un projet WinRT Windows Phone, c'est qu'ils utilisent les mêmes namespaces. Les différences résident dans les contrôles utilisateurs disponibles, certains restent spécifiques à la plateforme initiale comme par exemple le contrôle Pivot.</p>
<p>C'est là qu'intervient le "projet" Shared puisque la majorité du code peut être mise en commun, pourquoi ne le mutualiserions-nous pas ? Et bien c'est à ça qu'il sert. nous mettons en commun tout ce qui peut l'être et pour le code spécifique nous le mettons dans le projet correspondant. Au moment de la compilation tous les fichiers du "projet" shared sont "copiés" vers le projet en cours de compilation pour être inclus dans le package produit.</p>
<h2>Conclusion</h2>
<div>Lorsque vous voudrez créer une application pour les plateformes Microsoft. Il vous faudra donc :</div>
<div>
<ol>
<li>Réfléchir sur quelle plateforme nous comptons la sortir ?</li>
<li>Sur quelle version de l'OS de la plateforme nous voulons le sortir ?</li>
<li>Quelles sont les fonctionnalités dont je vais avoir besoin ?</li>
</ol>
</div>
<p>[caption id="attachment_602" align="aligncenter" width="768"]<img class="size-medium_large wp-image-602" src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/10/Appsbyplateform-768x548.png" alt="Quelles types d'applications doit-on choisir ?" width="768" height="548" /> Quelles types d'applications doit-on choisir ?[/caption]</p>
<p>Nous avons fait le tour de la question, je vous rappelle que si vous désirez savoir qu'elles sont les autres différences, vous pouvez les voir sur un projet basique : <a href="https://github.com/Nagarian47/LaboWP_LePendu">https://github.com/Nagarian47/LaboWP_LePendu</a> ou sinon vous pouvez lire <a href="http://msdn.microsoft.com/fr-FR/library/windows/apps/dn642082(v=vs.105).aspx">cette page du MSDN</a>.</p>
<p>Happy Coding !<br />
PS : Merci à Gillian Perard, pour les graphismes du pendu ! Son site : <a href="http://gillianperard.fr/" target="_blank">http://gillianperard.fr/</a></p>
