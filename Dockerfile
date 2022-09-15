﻿FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["actions/actions.csproj", "actions/"]
RUN dotnet restore "actions.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "actions.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "actions.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "actions.dll"]
