# 1. Build stage: compileer en test
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

COPY . .
RUN dotnet restore Rise.sln
RUN dotnet test Rise.sln -c Release --no-restore
RUN dotnet publish src/Rise.Server/Rise.Server.csproj -c Release -o /app/publish

# 2. Runtime stage: draai de server
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "Rise.Server.dll"]
