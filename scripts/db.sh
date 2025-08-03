#!/bin/bash

# Database management script for My Chat App

case "$1" in
  "start")
    echo "Starting PostgreSQL database..."
    docker-compose up -d
    echo "✅ PostgreSQL is running on localhost:5432"
    ;;
  "stop")
    echo "Stopping PostgreSQL database..."
    docker-compose down
    echo "✅ PostgreSQL stopped"
    ;;
  "restart")
    echo "Restarting PostgreSQL database..."
    docker-compose restart
    echo "✅ PostgreSQL restarted"
    ;;
  "status")
    echo "PostgreSQL container status:"
    docker ps --filter "name=my-chat-app-postgres"
    ;;
  "logs")
    echo "PostgreSQL logs:"
    docker-compose logs postgres
    ;;
  "reset")
    echo "⚠️  This will delete all data! Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      echo "Stopping and removing PostgreSQL container and data..."
      docker-compose down -v
      docker-compose up -d
      echo "✅ Database reset complete"
    else
      echo "Reset cancelled"
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|logs|reset}"
    echo ""
    echo "Commands:"
    echo "  start   - Start PostgreSQL database"
    echo "  stop    - Stop PostgreSQL database"
    echo "  restart - Restart PostgreSQL database"
    echo "  status  - Show container status"
    echo "  logs    - Show database logs"
    echo "  reset   - Reset database (delete all data)"
    exit 1
    ;;
esac 