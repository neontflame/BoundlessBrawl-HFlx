@echo off
title BOUNDLESS BRAWL!! Compile Helper
echo ------------ BOUNDLESS BRAWL!! A Lunatic's Platform Fighter ------------
title BOUNDLESS BRAWL!! Compile Helper - Installing haxelibs
echo Installing haxelibs
haxelib set lime 8.2.2
haxelib set openfl 9.4.1
haxelib set flixel 6.1.0
haxelib set flixel-addons 3.3.2
haxelib set flixel-tools 1.5.1
haxelib set flixel-ui 2.6.4
haxelib set hscript-iris 1.1.3
echo Building game
title BOUNDLESS BRAWL!! Compile Helper - Building game
lime build hl
title BOUNDLESS BRAWL!! Compile Helper - Running game
lime run hl