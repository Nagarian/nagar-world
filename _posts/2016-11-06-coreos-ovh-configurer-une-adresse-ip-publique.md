---
layout: post
status: publish
published: true
title: 'CoreOS - OVH : configurer une adresse IP publique'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 2241
wordpress_url: http://www.nagar-world.fr/?p=2241
date: '2016-11-06 18:42:22 -0600'
date_gmt: '2016-11-06 17:42:22 -0600'
categories:
- Docker
tags:
- Docker
- CoreOS
- OVH
- config
comments: []
---
<p>CoreOS est un système d'exploitation linux destiné à l'orchestration de container. Il est principalement prévu pour être utilisé dans des plateformes de cloud, de par sa simplicité d'utilisation et par sa simplicité de maintenance (mise à jour automatique notamment)</p>
<p>De ce fait, j'ai dernièrement eu le besoin de déployer une VM avec ce système sur un hyperviseur ESXI chez OVH. L'opération n'étant guère compliqué mis à par un élément peu documenté de la part d'OVH ou de l'équipe de CoreOS : <strong>Configurer une adresse IP publique sur la VM</strong>.</p>
<p><!--more--></p>
<p>En effet, afin de rendre accessible la VM CoreOS depuis internet, il est nécessaire de configurer une adresse IP publique. OVH propose l'achat d'adresse IP publique et fournit une documentation assez complète à <a href="http://guide.ovh.com/BridgeClient">cette adresse</a> pour effectuer la manipulation. Cependant, CoreOS ne fait pas partit des distributions présentes dans la documentation. Du coup, la configuration fut un poil plus complexe, et pour vous éviter de galérer comme moi voici la solution.</p>
<p>CoreOS propose de configurer entièrement le système à partir d'un fichier de configuration du nom de <strong>cloud-config.yml</strong>. Je ne vais pas rentrer dans les détails, leur documentation est assez fournie pour comprendre le fonctionnement. Par contre, pour la mise en place, une des méthodes les plus simples est celle du fichier ISO que je vous recommande (<a href="https://coreos.com/os/docs/latest/config-drive.html">lien ici</a>)</p>
<p>Donc, pour pouvoir activer l'IP publique et se connecter à distance en ssh voici la configuration nécessaire :</p>
<p>[bash]#cloud-config<br />
ssh_authorized_keys:<br />
  - ssh-rsa ACAAB3NzaC1yc2EAASADAQABAAABAQC+U0...<br />
coreos:<br />
  units:<br />
    - name: static.network<br />
      runtime: true<br />
      content: |<br />
        [Match]<br />
        Name=ens33</p>
<p>        [Network]<br />
        DNS=213.186.33.99</p>
<p>        [Route]<br />
        Gateway={GATEWAY_VM}</p>
<p>        [Address]<br />
        Address={IP.FAIL.OVER}/32<br />
        Broadcast={IP.FAIL.OVER}<br />
        Peer={GATEWAY_VM}/32</p>
<p>        [DHCP]<br />
        RequestBroadcast=no[/bash]</p>
<p>Remplacer les champs <strong>{GATEWAY_VM}</strong> et <strong>{IP.FAIL.OVER}</strong> avec les informations fournies par OVH (pour plus de détails sur ces 2 champs, referez-vous à la <a href="http://guide.ovh.com/BridgeClient">documentation</a>) et remplacer la clé SSH par la vôtre.</p>
<p>Si cela ne marche pas, c'est probablement que vous ne ciblez pas la bonne interface réseau (sur la configuration que je propose nommé en <strong>ens33</strong>) Pour trouver le bon nom à renseigner, le plus simple et de se connecter sur la VM à partir de l'interface VSphere en mode console (pour pouvoir accéder à l'interface, vous devrez activer l'autologin lors du boot, <a href="https://coreos.com/os/docs/latest/booting-on-vmware.html#logging-in">manip dispo ici</a>) puis un simple <strong>ifconfig</strong> permettra d'obtenir le bon nom à renseigner.</p>
