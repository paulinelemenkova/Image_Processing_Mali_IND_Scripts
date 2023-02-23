#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO 15 arc sec global data set (here: Mali)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

exec bash

# Extract a subset of ETOPO1m for the study area
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R-13/5/9.5/25.5 -Gml1_relief.nc
gmt grdcut GEBCO_2019.nc -R-13/5/9.5/25.5 -Gml_relief.nc
gdalinfo -stats ml1_relief.nc
# Topography: Minimum=27.000, Maximum=1590.000, Mean=327.682, StdDev=101.355

# Make color palette
gmt makecpt -Cgeo -V -T27/1590 > pauline.cpt
# gmt makecpt -Cdem1 -V -T27/1590 > pauline.cpt
gmt makecpt -Csrtm -V -T27/1590 > pauline.cpt
# elevation etopo1 world elevation dem1 dem2 dem3 globe geo srtm turbo terra earth

#####################################################################
# create mask of vector layer from the DCW of country's polygon
gmt pscoast -R-13/5/9.5/25.5 -JD-4/18/9.5/25.5/6.5i -Dh -M -EML > Mali.txt
#####################################################################

ps=Topo_ML.ps
# Make background transparent image
gmt grdimage ml_relief.nc -Cpauline.cpt -R-13/5/9.5/25.5 -JD-4/18/9.5/25.5/6.5i -I+a15+ne0.75 -t40 -Xc -P -K > $ps
.5i
# Add isolines
gmt grdcontour ml1_relief.nc -R -J -C1000 -A1000+f7p,26,darkbrown -Wthinner,darkbrown -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J \
    -Ia/thinner,blue -Na -N1/thicker,tomato -W0.1p -Df -O -K >> $ps
    
#------------------------->
# CLIPPING
# 1. Start: clip the map by mask to only include country
gmt psclip -R-13/5/9.5/25.5 -JD-4/18/9.5/25.5/6.5i Mali.txt -O -K >> $ps

# 2. create map within mask
# Add raster image
gmt grdimage ml_relief.nc -Cpauline.cpt -R-13/5/9.5/25.5 -JD-4/18/9.5/25.5/6.5i -I+a15+ne0.75 -Xc -P -O -K >> $ps
# Add isolines
gmt grdcontour ml1_relief.nc -R -J -C500 -Wthinnest,darkbrown -O -K >> $ps
# Add coastlines, borders, rivers
gmt pscoast -R -J \
    -Ia/thinner,blue -Na -N1/thicker,tomato -W0.1p -Df -O -K >> $ps

# 3: Undo the clipping
gmt psclip -C -O -K >> $ps
#-------------------------<
    
# Add color legend
gmt psscale -Dg-13.3/8.1+w16.5c/0.15i+h+o0.3/0i+ml+e -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg50f10a100+l"Colormap: 'earth' Colors for global topography relief [R=-T29/896, H, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    --MAP_TITLE_OFFSET=0.7c \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_LABEL=8p,25,black \
    --FONT_TITLE=13p,0,black \
        -Bpxg4f1a2 -Bpyg4f2a2 -Bsxg2 -Bsyg2 \
    -B+t"Topographic map of Mali" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=9p,0,black \
    --FONT_ANNOT_PRIMARY=9p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.0c/-2.4c+c10+w500k+l"Equidistant conic projection. Scale (km)"+f \
    -UBL/0p/-70p -O -K >> $ps

# Texts
# Cities for area -R-13/5/9.5/25.5
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-6.76 11.45 Sikasso
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-5.66 11.32 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-5.67 12.50 Koutiala
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-5.47 12.38 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-6.20 13.50 Ségou
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-6.26 13.45 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-11.63 14.65 Kayes
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-11.43 14.45 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-4.09 14.38 Mopti
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-4.19 14.49 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-7.83 12.30 Kalabancoro
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-8.03 12.57 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
0.05 16.33 Gao
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.05 16.27 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-8.70 12.85 Kati
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-8.07 12.75 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-4.7 13.35 San
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-4.9 13.3 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB -Gdarkgoldenrod@50 >> $ps << EOF
-3.94 22.72 Taoudenni
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-3.98 22.67 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
1.46 18.50 Kidal
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
1.41 18.44 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-2.95 16.35 Timbuktu
-2.95 16.00 (Tombouctou)
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-3.01 16.75 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-0.25 17.01 Bourem
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.35 16.95 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-3.43 18.96 Araouane
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-3.53 18.90 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
0.11 20.36 Tessalit
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
1.01 20.20 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-4.45 13.91 Djenné
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-4.55 13.97 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB >> $ps << EOF
-7.42 11.10 Bougouni
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-7.48 11.42 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB -Gsaddlebrown@70 >> $ps << EOF
-10.47 14.70 Yélimané
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-10.57 15.12 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB -Gsaddlebrown@70 >> $ps << EOF
-9.40 15.14 Nioro du Sahel
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-9.55 15.18 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB -Gsaddlebrown@80 >> $ps << EOF
-5.33 15.33 Nampala
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-5.43 15.28 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,lemonchiffon+jLB -Gsaddlebrown@80 >> $ps << EOF
0.60 15.70 Ansongo
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
0.50 15.66 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f15p,30,yellow+jLB >> $ps << EOF
-7.90 12.70 Bamako
EOF
gmt psxy -R -J -Sa -W0.5p -Gred -O -K << EOF >> $ps
-8.00 12.63 0.35c
EOF
#
# countries
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
-11.0 19.1 M A U R I T A N I A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
-11.5 10.50 G U I N E A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
-2.5 13.1 B U R K I N A
-2.0 12.5 F A S O
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
-0.45 23.5 A L G E R I A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
2.2 14.2 N I G E R
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
1.5 10.7 B E N I N
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
-2.2 10.2 G H A N A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB+a300 >> $ps << EOF
-12.95 14.4 SENEGAL
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,darkbrown+jLB >> $ps << EOF
-7.95 9.6 CÔTE D\'IVOIRE
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB+a90 >> $ps << EOF
4.5 10.1 N I G E R I A
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,19,gray25+jLB+a90 >> $ps << EOF
0.75 9.7 TOGO
EOF
#
# water
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,30,blue1+jLB >> $ps << EOF
-5.2 17.12 Lake
-5.2 16.82 Faguibine
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,30,blue1+jLB >> $ps << EOF
-3.2 15.70 Lake
-3.2 15.30 Niangay
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f22p,29,cornsilk+jLB >> $ps << EOF
-3.8 17.7 M  A  L  I
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,32,blue1+jLB+a12 >> $ps << EOF
-2.8 16.89 Niger
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,30,cadetblue1+jLB >> $ps << EOF
-8.2 11.85 Selingue
-8.2 11.47 Dam
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,30,cadetblue1+jLB >> $ps << EOF
-9.75 13.02 Sotuba
-9.75 12.72 Dam
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,30,blue1+jLB -Ggoldenrod@75 >> $ps << EOF
-11.00 14.2 Félou
-11.00 13.9 Falls
EOF
# land features
gmt pstext -R -J -N -O -K \
-F+f17p,20,salmon4+jLB >> $ps << EOF
-9.8 20.3 S A H A R A   D E S E R T
EOF
gmt pstext -R -J -N -O -K \
-F+f15p,20,wheat+jLB >> $ps << EOF
-8.5 14.5 S   A   H   E   L
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,4,gray25+jLB+a300 -Ggoldenrod@75 >> $ps << EOF
-11.8 14.4 Mandingue Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,darkgreen+jLB -Glightbrown@60 >> $ps << EOF
-9.0 14.0 Boucle du Baoulé
-8.8 13.50 National Park
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,20,cornsilk1+jLB >> $ps << EOF
-3.8 19.5 A z a w a d
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,20,lightyellow+jLB >> $ps << EOF
0.86 19.50 Adrar des
1.00 19.10 Ifoghas
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,cornsilk1+jLB >> $ps << EOF
-1.56 15.30 Hombori Tondo Mt.
EOF
gmt psxy -R -J -St -W0.5p -Gmagenta -O -K << EOF >> $ps
-1.66 15.26 0.30c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,cornsilk1+jLB+a30 >> $ps << EOF
-2.85 14.5 Dogon
-2.55 14.3 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,21,darkgreen+jLB -Glightbrown@60 >> $ps << EOF
1.75 15.9 Ansongo Giraffe
2.1 15.5 Reserve
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,20,cornsilk1+jLB >> $ps << EOF
-2.05 22.45 Tanezrouft
-2.05 22.10 Desert
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,20,salmon4+jLB >> $ps << EOF
-9.8 17.3 Aoukar
-9.8 16.8 Depression
EOF

# insert map
# Countries codes: ISO 3166-1 alpha-2. Continent codes AF (Africa), AN (Antarctica), AS (Asia), EU (Europe), OC (Oceania), NA (North America), or SA (South America). -EEU+ggrey
gmt psbasemap -R -J -O -K -DjTL+w3.5c+o-0.2c/-0.2c+stmp >> $ps
read x0 y0 w h < tmp
gmt pscoast --MAP_GRID_PEN_PRIMARY=thin,grey -Rg -JG-1.0/8.0N/$w -Da -Glightgoldenrod1 -A5000 -Bga -Wfaint -EML+gred -Sdodgerblue -O -K -X$x0 -Y$y0 >> $ps
#gmt pscoast -Rg -JG12/5N/$w -Da -Gbrown -A5000 -Bg -Wfaint -ECM+gbisque -O -K -X$x0 -Y$y0 >> $ps
gmt psxy -R -J -O -K -T  -X-${x0} -Y-${y0} >> $ps

# Add GMT logo
gmt logo -Dx7.0/-3.1+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.7c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
2.5 10.4 Digital elevation data: SRTM/GEBCO, 15 arc sec resolution grid
EOF

# Convert to image file using GhostScript
gmt psconvert Topo_ML.ps -A0.5c -E720 -Tj -Z
