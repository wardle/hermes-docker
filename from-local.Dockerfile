FROM amazoncorretto:11-alpine-jdk
ARG hermes_jar
ARG snomed_db
ENV port 8080
COPY ${hermes_jar} /hermes.jar
COPY ${snomed_db} /snomed.db
EXPOSE ${port}    
CMD java -jar /hermes.jar --bind-address 0.0.0.0 --db snomed.db --port ${port} --allowed-origins "*" serve
