# --- ビルドステージ ---
# .NET 8 SDKイメージをベースにする
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# ソリューション全体をコピー
COPY . .

# 依存関係を復元
RUN dotnet restore "MyBlazorAutoApp.sln"

# アプリケーションをビルドして発行
RUN dotnet publish "MyBlazorAutoApp/MyBlazorAutoApp.csproj" -c Release -o /app/publish --no-restore

# --- 実行ステージ ---
# ASP.NET Coreランタイムイメージをベースにする
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# App RunnerはPORT環境変数でポートを指定する
ENV ASPNETCORE_URLS="http://+:8080"
EXPOSE 8080

ENTRYPOINT ["dotnet", "MyBlazorAutoApp.dll"]