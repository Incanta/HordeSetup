#!/usr/bin/env bash

WINEPREFIX=/home/user/.wine WINEARCH=win64 wineboot --init
dotnet HordeAgent.dll
