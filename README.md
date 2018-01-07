################################ Ma  Jun ##################################

OS： Macos Sierra

IDE: Intellij Idea 2017

DB: mysql (docker latest)

App Server: apache-tomcat-8.5.20

JDK: 1.8.0_121

Build Tool: Maven 


Web UrlS:
http://localhost:8080/rio-web/user/add/14/500

http://localhost:8080/rio-web/coins/user/40

http://localhost:8080/rio-web/transaction/transfer/76/77/10

说明：
1. build工具使用maven，配置见https://github.com/timeknows11/demo/tree/master/rio_web/pom.xml

2. 8080 端口为 API 端口, 8081端口为ops端口, 实现访问 http://host:8081/ops/jstack 返回当前 java 进程 jstack
   方案： 修改tomcat/conf目录里面server.xml文件， 复制Service name="Catalina2"，也就是说tomcat的webapps里有两个项目rio-web和rio-ops,rio-web使用8080，rio-ops使用8081
   
   URL:http://localhost:8081/rio-ops/ops/jstack
   TODO： 后续提供tomcat的dockerfile
   
3. 数据存储使用 mysql
   docker pull mysql
   docker run --name mysql -p 3306:3306  -e MYSQL_ROOT_PASSWORD=123456 -d mysql:latest
   docker ps
   docker exec -it dcad0deeeda1 bash

4. microservice 应用启动脚本见https://github.com/timeknows11/demo/tree/master/rio_web/rio.sh
