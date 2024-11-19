# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart pub get --directory=server
RUN dart compile exe server/bin/server.dart -o server/bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/server/bin/server /app/bin/

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
