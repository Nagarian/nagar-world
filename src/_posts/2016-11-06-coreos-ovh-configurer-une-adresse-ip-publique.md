---
title: 'CoreOS - OVH : configurer une adresse IP publique'
wordpress_id: 2241
wordpress_url: http://www.nagar-world.fr/?p=2241
date: '2016-11-06 18:42:22 -0600'
date_gmt: '2016-11-06 17:42:22 -0600'
categories:
- Docker
tags:
- CoreOS
- OVH
---

CoreOS est un système d'exploitation linux destiné à l'orchestration de container. Il est principalement prévu pour être utilisé dans des plateformes de cloud, de par sa simplicité d'utilisation et par sa simplicité de maintenance (mise à jour automatique notamment)

De ce fait, j'ai dernièrement eu le besoin de déployer une VM avec ce système sur un hyperviseur ESXI chez OVH. L'opération n'étant guère compliqué mis à par un élément peu documenté de la part d'OVH ou de l'équipe de CoreOS : **Configurer une adresse IP publique sur la VM**.

<!--more-->

En effet, afin de rendre accessible la VM CoreOS depuis internet, il est nécessaire de configurer une adresse IP publique. OVH propose l'achat d'adresse IP publique et fournit une documentation assez complète à [cette adresse](http://guide.ovh.com/BridgeClient) pour effectuer la manipulation. Cependant, CoreOS ne fait pas partit des distributions présentes dans la documentation. Du coup, la configuration fut un poil plus complexe, et pour vous éviter de galérer comme moi voici la solution.

CoreOS propose de configurer entièrement le système à partir d'un fichier de configuration du nom de `cloud-config.yml`. Je ne vais pas rentrer dans les détails, leur documentation est assez fournie pour comprendre le fonctionnement. Par contre, pour la mise en place, une des méthodes les plus simples est celle du fichier ISO que je vous recommande ([lien ici](https://coreos.com/os/docs/latest/config-drive.html))

Donc, pour pouvoir activer l'IP publique et se connecter à distance en ssh voici la configuration nécessaire :

```bash
#cloud-config
ssh_authorized_keys:
  - ssh-rsa ACAAB3NzaC1yc2EAASADAQABAAABAQC+U0...
coreos:
  units:
    - name: static.network
      runtime: true
      content: |
        [Match]
        Name=ens33

        [Network]
        DNS=213.186.33.99

        [Route]
        Gateway={GATEWAY_VM}

        [Address]
        Address={IP.FAIL.OVER}/32
        Broadcast={IP.FAIL.OVER}
        Peer={GATEWAY_VM}/32

        [DHCP]
        RequestBroadcast=no
```

Remplacer les champs `{GATEWAY_VM}` et `{IP.FAIL.OVER}` avec les informations fournies par OVH (pour plus de détails sur ces 2 champs, referez-vous à la [documentation](http://guide.ovh.com/BridgeClient)) et remplacer la clé SSH par la vôtre.

Si cela ne marche pas, c'est probablement que vous ne ciblez pas la bonne interface réseau (sur la configuration que je propose nommé en `ens33`) Pour trouver le bon nom à renseigner, le plus simple et de se connecter sur la VM à partir de l'interface VSphere en mode console (pour pouvoir accéder à l'interface, vous devrez activer l'autologin lors du boot, [manip dispo ici](https://coreos.com/os/docs/latest/booting-on-vmware.html#logging-in)) puis un simple `ifconfig` permettra d'obtenir le bon nom à renseigner.
