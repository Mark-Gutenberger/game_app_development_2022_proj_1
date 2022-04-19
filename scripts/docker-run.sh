#! /bin/bash
# SPDX-License-Identifier: MIT
# Author: Mark Gutenberger <mark-gutenberger@outlook.com>
# docker-run.sh (c) 2022
# Desc: runs the docker image
# Created:  2022-03-24T02:07:04.958Z
# Modified: 2022-04-19T14:08:00.414Z

printf "\e[33mWARN: Make sure you built the container first...\e[0m\n"

DOCKER_BUILDKIT=1
docker run --rm -p 3000:3000 game_app_development_2022_proj_1
