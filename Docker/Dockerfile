# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set a non-root build user for security
RUN useradd -m builduser
USER builduser

# Set working directory
WORKDIR /source

# Copy only the .csproj files first and restore as distinct layers
COPY --chown=builduser:builduser PrimeService/PrimeService.csproj PrimeService/
COPY --chown=builduser:builduser PrimeService.Tests/PrimeService.Tests.csproj PrimeService.Tests/
RUN dotnet restore PrimeService.Tests/PrimeService.Tests.csproj

# Copy everything else and build the project
COPY --chown=builduser:builduser . .
RUN dotnet build PrimeService.Tests/PrimeService.Tests.csproj --configuration Release --no-restore
RUN dotnet publish PrimeService.Tests/PrimeService.Tests.csproj --configuration Release --no-build --output /app

# Stage 2: Create the runtime container
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set up a non-root user for running the app
RUN useradd -m appuser
USER appuser

# Set working directory
WORKDIR /app

# Copy the published application and configuration files from the build stage
COPY --from=build /app ./
COPY conf.d/ /app/conf.d/

# Set environment variables securely via Docker
ENV DOTNET_ENVIRONMENT=Production

# Expose a port if needed
# EXPOSE 80

# Entry point for the application
ENTRYPOINT ["dotnet", "PrimeService.Tests.dll"]
