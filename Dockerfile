# Use a base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Create a non-root user and group
RUN groupadd -r myuser && useradd -r -g myuser myuser

# Set environment variables securely via Docker
ENV DOTNET_ENVIRONMENT=development

# Set the working directory and create it
WORKDIR /source

# Copy project files and set permissions
COPY --chown=myuser:myuser PrimeService/PrimeService.csproj /source/PrimeService/
COPY --chown=myuser:myuser PrimeService.Tests/PrimeService.Tests.csproj /source/PrimeService.Tests/
COPY --chown=myuser:myuser PrimeApi/PrimeApi.csproj /source/PrimeApi/

# Switch to the non-root user
# USER myuser

# Copy all project files as the non-root user
COPY --chown=myuser:myuser . /source/

# Install required packages as root
RUN dotnet add /source/PrimeService.Tests/PrimeService.Tests.csproj package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.4 && \
    dotnet add /source/PrimeService.Tests/PrimeService.Tests.csproj package Microsoft.EntityFrameworkCore.Analyzers --version 8.0.4

# Restore dependencies and build the project
RUN dotnet restore /source/PrimeService.Tests/PrimeService.Tests.csproj && \
    dotnet build /source/PrimeService.Tests/PrimeService.Tests.csproj --configuration Release --no-restore

# Expose the ports
EXPOSE 6000
EXPOSE 6001

# Default command to run
CMD ["dotnet", "test", "/source/PrimeService.Tests/PrimeService.Tests.csproj"]

# Copy the configuration directory and file
COPY conf.d /source/conf.d/
