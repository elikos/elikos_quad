# elikos_quad
Ce repo contient l'arborescence de fichiers nécessaire au fonctionnement du quadricoptère.

# Pour démarrer avec l'utilisation de ce repo
	git submodule init
	git submodule update --recursive
# Pour mettre à jour
Faire un git pull des modifications sur chaque repo.  
Notez que les packages realsense et mavros doivent etre sur la branche indigo-devel.

# Script iarc7.sh
Script pour lancer les processus pour la compétition.
`./iarc7.sh`
Arguments :
- `start` : Démarrage des processus.
	- `--vicon` : Démarrage de vicon_bridge.
	- `--static` : Démarrage d'une transformation statique pour la vision.
		- `X Y Z` : Position de la transformation statique.  
- `stop` : Arrêt des processus.
- `-i` ou `--init` : Appel au rosservice /elikos_origin_init.
