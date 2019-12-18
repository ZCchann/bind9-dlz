## 使用教程

构建命令：docker build -t bind9-docker .

构建完成后启动系统：

启动命令：

docker run -it -d --net=host --restart always --privileged -e "mysql=host=server_ip dbname=mysql_name ssl=false port=3306 user=mysql_name pass=mysql_password threads=50" --name bind-dlz bind9-docker

请自行调整host dbname user pass 等参数

host=mysql服务器IP

dbname=数据库名称

user=数据库连接用户名

pass=数据库连接密码

若需要将日志导出到宿主机上 命令如下：

先在宿主上创建bind的日志路径

mkdir -p /var/log/bind

然后启动容器时增加命令

-v /var/log/bind:/var/log/bind
