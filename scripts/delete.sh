#docker stop $(docker ps -a -q)
#docker rmi -f chat-app
#docker rmi -f $(docker images -aq)
#docker rm -f $(docker ps -a -q)




docker stop chat-app-run
if [ $# -eq 0 ]; then
    docker rmi -f chat-app
else
    docker rmi -f chat-app:$1
fi
docker rm -f chat-app-run