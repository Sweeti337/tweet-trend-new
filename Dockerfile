# Correct example
FROM openjdk:8

COPY ./jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar ttrendfinalnew.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "ttrendfinalnew.jar"]