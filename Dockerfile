FROM worker-node2:8124/openjdk:latest
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} msrsample.jar
ENTRYPOINT ["java","-jar","/msrsample.jar"]
