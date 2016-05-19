# 概要
Amon2を利用した勉強用web app

## 起動
```
carton exec -- plackup -Ilib -R ./lib --access-log /dev/null -p 5000 -a ./script/scheduler-server
```
