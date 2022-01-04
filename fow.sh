#!/bin/bash

set -e

: ${OPENSCAD:="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"}

declare -a wall_taxonomies=("WoT" "SepW" "None")


for x in {2..10}
do
	for y in {2..10}
	do
		for wall_tax_N in "${wall_taxonomies[@]}"
		do
			for wall_tax_E in "${wall_taxonomies[@]}"
			do
				for wall_tax_S in "${wall_taxonomies[@]}"
				do
					for wall_tax_W in "${wall_taxonomies[@]}"
					do

					mkdir -p _out
					$OPENSCAD -o _out/fow+${x}x${y}+${wall_tax_N},${wall_tax_E},${wall_tax_S},${wall_tax_W}.stl \
						-D "room_size=[${x},${x}]" \
						-D "wall_taxonomy_N=\"${wall_tax_N}\"" \
						-D "wall_taxonomy_E=\"${wall_tax_E}\"" \
						-D "wall_taxonomy_S=\"${wall_tax_S}\"" \
						-D "wall_taxonomy_W=\"${wall_tax_W}\"" \
						fow.scad

					done
				done
			done
		done
	done
done

