FROM FROM openjdk:11-jre-slim
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrendfinal.jar
ENTRYPOINT ["java", "-jar", "ttrendfinal.jar"]