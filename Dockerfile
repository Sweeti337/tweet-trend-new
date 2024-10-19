# Correct example
FROM openjdk:8

COPY  jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrendfinal.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "ttrendfinal.jar"]