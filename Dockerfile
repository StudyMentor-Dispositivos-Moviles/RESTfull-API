# Usa la imagen base de ASP.NET Core runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Usa la imagen SDK para construir la app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["1. API/1. API.csproj", "1. API/"]
RUN dotnet restore "1. API/1. API.csproj"
COPY . .
WORKDIR "/src/1. API"
RUN dotnet build "1. API.csproj" -c Release -o /app/build

# Publica la app en el directorio /app/publish
FROM build AS publish
RUN dotnet publish "1. API.csproj" -c Release -o /app/publish

# Usa la imagen base para la etapa final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "1. API.dll"]
