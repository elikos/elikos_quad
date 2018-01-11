# elikos_quad
Ce repo contient l'arborescence de fichiers nécessaire au fonctionnement du quadricoptère.

# Pour démarrer avec l'utilisation de ce repo

## Installation des dépendances
    ./elikos_quad_build.sh init --dep

ou

	sudo apt-get install -y ros-$ROS_DISTRO-mavros ros-$ROS_DISTRO-mavros-extras ros-$ROS_DISTRO-pointgrey-camera-driver ros-$ROS_DISTRO-moveit ros-$ROS_DISTRO-mavros-msgs ros-$ROS_DISTRO-control-toolbox
    sudo apt install -y python-pip
    sudo pip install --upgrade pip
    sudo pip install numba scipy numpy numpy-quaternion catkin_tools

## Initialisation et update des submodules
    ./elikos_quad_build.sh init --submod

ou

	git submodule init
	git submodule update --recursive --remote

### Pour mettre à jour
Faire un git pull des modifications sur chaque repo (inutile si `--remote` est utilisé).  
Notez que les packages realsense et mavros doivent etre sur la branche indigo-devel.

## Build
    . ./elikos_quad_build.sh build

ou build et source en ordre: `driver-ws`, `util-ws` et `elikos-ws`. Le point devant le point-slash est nécessaire afin de source correctement à l'aide d'un script.

# Script elikos_quad_build.sh

Scrip pour build et setup le workspace.  
`. ./elikos_quad_build.sh`  
Arguments :
- `build` : Build et source les workspaces en ordre [défaut].
- `init`
	- `--dep` : Installation des dépendances.
	- `--submod` : Initialisation et update des submodules.
	- `--alias` : Ajoute l'alias `srcquad` qui source `elikos-ws/` dans `~/.bashrc` et source le fichier.
- `clean` : Clean tous les workspaces.

# Script elikos2017.sh
Script pour lancer les processus pour la compétition.  
`./elikos2017.sh`  
Arguments :
- `start` : Démarrage des processus.
	- `--vicon` : Démarrage de vicon_bridge.
	- `--static` : Démarrage d'une transformation statique pour la vision.
		- `X Y Z` : Position de la transformation statique.  
- `stop` : Arrêt des processus.
- `init` : Appel au rosservice /elikos_origin_init.
- `setpoint` : Transformation statique de elikos_arena_origin a elikos_setpoint.
	- `X Y Z` : Position de la transformation statique

# Script elikos_camera.sh
Script de demarrage des drivers de camera.
- `start` : Démarrage des processus.
- `stop` : Arrêt des processus.
