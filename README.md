# 3d-fow-generator
Fog of War room cover generator for RPG 3D scenarios

## Features
- **Customizable** "Fog of War" cover for your RPG rooms (OpenForge, Printable Secenery, Fat Dragon, ...)

- For every side of the room you can select **different wall options**:
 
	- **Wall on Tile**: this type of wall is part of and overlaps the floor grid of the room (Floor and wall are typically printed as one or glued together).
	- **Separate Wall**: the wall is outside the floor grid (Typically the wall is a separate part which is attached to the side of the floor part)
	- **Facade**: this type of wall is higher than the rest of the inside walls and typically used as the ouside facade of buildings
	- **No wall**: the room is open on this side. Convenient for corridors if you want to have multiple FoW covers stringed together.

- **Support feet** are automatically created when missing walls would prevent the cover from staying in place. The feet can be optionally placed at the corners or at the edges of the room cover.

- The covers are automatically **labeled** for easier distinguishing

## Instructions
1. Install [OpenSCAD](https://openscad.org/)
2. Open `fow.scad`
3. Set the room size and wall taxonomy for every side
4. Start Rendering with F6 key
5. Save STL file with F7 key
6. Print (see setting below)
7. Have fun covering and hiding fantastic rooms for your players ;-)

## Print Settings
- Nozzle: 0.4 mm
- Layer height: 0.10 or 0.15 mm
- Material: PLA
- Infill: 20%
