FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Employees/Employees.csproj", "Employees/"]
RUN dotnet restore "Employees/Employees.csproj"
COPY . .
WORKDIR "/src/Employees"
RUN dotnet build "Employees.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Employees.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Employees.dll"]
