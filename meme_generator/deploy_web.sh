#!/bin/bash

# build
flutter build web --web-renderer=canvaskit
# deploy
scp -r build/web siam:/var/www/html/surfjam

