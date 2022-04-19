#! /bin/pwsh
<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
docker-run.ps1 (c) 2022
Desc: description
Created:  2022-04-19T14:05:22.247Z
Modified: 2022-04-19T14:07:58.655Z
#>

Write-Host "WARN: Make sure you built the container first...`n" -ForegroundColor Yellow

$DOCKER_BUILDKIT = 1
$env:DOCKER_BUILDKIT = 1

docker run --rm -p 3000:3000 game_app_development_2022_proj_1
