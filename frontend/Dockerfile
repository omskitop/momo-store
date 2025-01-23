# Используем легковесный образ Node.js на базе Alpine для сборки
FROM node:16-alpine AS builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json
COPY ./package.json ./package-lock.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальной код приложения
COPY . .

# Собираем приложение
RUN npm run build

# Используем Nginx для обслуживания приложения
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа в директорию Nginx
COPY --from=builder /app/dist /app

# Копируем конфигурацию Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Экспонируем порт
EXPOSE 80

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]