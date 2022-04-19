@REM SPDX-License-Identifier: MIT
@REM Author: Mark Gutenberger <mark-gutenberger@outlook.com>
@REM docker-run.cmd (c) 2022
@REM Desc: description
@REM Created:  2022-03-24T02:50:13.998Z
@REM Modified: 2022-04-19T14:06:10.385Z


echo "WARN: Make sure you built the container first..."

set DOCKER_BUILDKIT=1
docker run --rm -p 3000:3000 game_app_development_2022_proj_1
