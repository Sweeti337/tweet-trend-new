FROM ubuntu:20.04
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrendfinal.jar
ENTRYPOINT ["java", "-jar", "ttrendfinal.jar"]