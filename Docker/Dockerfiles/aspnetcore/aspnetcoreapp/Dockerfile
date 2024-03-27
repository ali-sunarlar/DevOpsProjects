FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5116

ENV ASPNETCORE_URLS=http://+:5116

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["aspnetcore/aspnetcoreapp/aspnetcoreapp.csproj", "aspnetcore/aspnetcoreapp/"]
RUN dotnet restore "aspnetcore/aspnetcoreapp/aspnetcoreapp.csproj"
COPY . .
WORKDIR "/src/aspnetcore/aspnetcoreapp"
RUN dotnet build "aspnetcoreapp.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "aspnetcoreapp.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]
