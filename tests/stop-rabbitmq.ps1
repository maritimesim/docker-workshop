# Stop and remove all 20 RabbitMQ Docker containers

$numInstances = 20

Write-Host "Stopping and removing $numInstances RabbitMQ containers..." -ForegroundColor Red

for ($i = 1; $i -le $numInstances; $i++) {
    $containerName = "my-rabbit-$i"
    
    Write-Host "Stopping and removing: $containerName" -ForegroundColor Yellow
    
    docker stop $containerName
    docker rm $containerName
}

Write-Host "All RabbitMQ containers have been stopped and removed!" -ForegroundColor Green