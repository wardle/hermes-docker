FROM clojure:openjdk-11-tools-deps-1.11.1.1113-buster as builder
WORKDIR /usr/src
RUN git clone --depth 1 --branch v0.12.681 https://github.com/wardle/hermes
WORKDIR /usr/src/hermes
RUN clj -T:build uber :out '"hermes.jar"'

FROM amazoncorretto:11-alpine-jdk as index
ARG trud_api_key
COPY --from=builder /hermes.jar /hermes.jar
RUN mkdir cache
RUN echo $trud_api_key >api-key.txt
RUN echo "trud api key" "$trud_api_key"
RUN java -jar hermes.jar --db snomed.db download uk.nhs/sct-clinical cache-dir /cache api-key api-key.txt release-date 2022-05-18
RUN java -jar hermes.jar --db snomed.db download uk.nhs/sct-drug-ext cache-dir /cache api-key api-key.txt release-date 2022-05-18
RUN java -jar hermes.jar --db snomed.db compact
RUN java -jar hermes.jar --db snomed.db --locale en-GB index

FROM amazoncorretto:11-alpine-jdk
COPY --from=builder /hermes.jar /hermes.jar
COPY --from=index /snomed.db /snomed.db
CMD ["java", "-XX:+UseContainerSupport","-XX:MaxRAMPercentage=85","-XX:+UnlockExperimentalVMOptions","-XX:+UseZGC","-jar","/hermes.jar", "-a", "0.0.0.0", "-d", "snomed.db", "-p", "8080", "--allowed-origins", "*", "serve"]