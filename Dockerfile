# Correct example
FROM openjdk:8

ADD  jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrendfinalnew.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "ttrendfinalnew.jar"]