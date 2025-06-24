# Start 20 RabbitMQ Docker containers with incremented port mappings and names

$basePort = 15672
$numInstances = 20

Write-Host "Starting $numInstances RabbitMQ containers..." -ForegroundColor Green

for ($i = 1; $i -le $numInstances; $i++) {
    $port = $basePort + $i - 1
    $containerName = "my-rabbit-$i"
    $hostname = "my-rabbit-$i"
    
    Write-Host "Starting container: $containerName on port $port" -ForegroundColor Yellow
    
    docker run -d `
        --name $containerName `
        --hostname $hostname `
        -e RABBITMQ_DEFAULT_USER=sim `
        -e RABBITMQ_DEFAULT_PASS=sim `
        -p ${port}:15672 `
        rabbitmq:3-management
}

Write-Host "All containers started! Access them at:" -ForegroundColor Green
for ($i = 1; $i -le $numInstances; $i++) {
    $port = $basePort + $i - 1
    Write-Host "  my-rabbit-$i : http://localhost:$port (sim/sim)" -ForegroundColor Cyan
}