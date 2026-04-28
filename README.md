Laravel Kubernetes Deployment - Docker Setup

This project demonstrates a production-ready Laravel 11 application containerized with Docker, featuring a multi-stage build and automated health checks for Kubernetes deployment.

🚀 1. Application Features
Custom Route: / returns "Laravel Kubernetes Deployment Test".

Health Check: /health endpoint for monitoring (returns HTTP 200).

PHP
// Health check implementation in routes/web.php
Route::get('/health', function () {
    return response()->json(['status' => 'ok'], 200);
});
🐳 2. Docker Architecture
We use a Multi-stage Build to keep the final production image lightweight (~180MB) and secure.

PHP 8.3-FPM: Optimized for performance.

Nginx: High-performance web server.

Supervisor: Orchestrates Nginx and PHP-FPM processes.

Non-root User: Runs as www-data for enhanced security.

🛠 3. Build & Registry Commands
Build the Image
Bash
# Build with version tag
docker build -t mazidhossain/laravel-app:v1.0.1 .

# Tag as latest (optional)
docker tag mazidhossain/laravel-app:v1.0.1 mazidhossain/laravel-app:latest
Push to Docker Hub
Bash
docker login
docker push mazidhossain/laravel-app:v1.0.1
docker push mazidhossain/laravel-app:latest
Image URL: https://hub.docker.com/r/mazidhossain/laravel-app

🧪 4. Local Testing
Run the container locally to verify everything is working:

Bash
docker run -d \
  --name laravel-test \
  --publish 8080:8080 \
  --env APP_KEY="base64:LG2Tv3nNQbzKIMKutFRAZq3K5pLL3BdqwMOy/X89jQY=" \
  mazidhossain/laravel-app:v1.0.1
Verification:

App: http://localhost:8080

Health: http://localhost:8080/health

📂 5. Project Structure
Dockerfile: Multi-stage production build.

.dockerignore: Excludes unnecessary files (vendor, env).

docker/: Config files for Nginx, PHP, and Supervisor
