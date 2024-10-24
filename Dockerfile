# Use the official .NET SDK image as the base for the build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy the csproj file and restore any dependencies (via NuGet)
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files and build the app
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the base for the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

# Copy the build output to the runtime environment
COPY --from=build-env /app/out .

# Expose the port on which the app will run
EXPOSE 80

# Start the web service
ENTRYPOINT ["dotnet", "HelloWorldWebService.dll"]
