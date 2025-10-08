# 테스트용 단순 Dockerfile
FROM amazoncorretto:21-alpine3.19

WORKDIR /app

# 필수 패키지 설치
RUN apk add --no-cache curl

# 미리 빌드된 JAR 파일 복사
COPY application/build/libs/application-*-SNAPSHOT.jar app.jar

# 로그 디렉토리 생성
RUN mkdir -p /app/logs

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
