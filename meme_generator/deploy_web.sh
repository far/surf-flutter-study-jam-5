#!/bin/bash

# build
flutter build web --web-renderer=html
# deploy
scp -r build/web siam:/var/www/html/surfjam

