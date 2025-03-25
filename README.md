# Delicious-Kyzylyk
В данном репозитории несколько проектов под разные нужды

## Быстрый подъем прокси сервера
Скопировать строку и вставить в терминал нажатием ПКМ  

> sudo git clone https://github.com/MihailGorbunov/Delicious-Kyzylyk.git && cd Delicious-Kyzylyk && sudo chmod +x install.sh && ./install.sh

## Сервер выдачи конфигов CyberMesh

### Установка и настройка
* На новом сервере ввести следующую команду для установки репозитория
    >sudo git clone https://github.com/MihailGorbunov/Delicious-Kyzylyk.git && cd Delicious-Kyzylyk\nginx_cybermesh_config_fileserver && sudo chmod +x dockerinstall.sh && ./dockerinstall.sh


* Настроить отдельный сервер с XRay используя быструю ссылку выше
    * С данного сервера скопировать ключи подключения, которые выводятся в консоль по завершению установки  
    Н-р:
    >user_1:  
    >vless://...#PIEROGI_1  
    >user_2:  
    >vless://...#PIEROGI_2  
    >user_3: ...

* Вставить ключи в файл **Delicious-Kyzylyk\nginx_cybermesh_config_fileserver\connstring.txt**
    > nano Delicious-Kyzylyk\nginx_cybermesh_config_fileserver\connstring.txt   

    > Нажать комбинации клавиш: CTRL+V, CTRL+S, CTRL+X  

    > chmod +x Delicious-Kyzylyk\nginx_cybermesh_config_fileserver\parseConnstring.sh  

    > ./Delicious-Kyzylyk\nginx_cybermesh_config_fileserver\parseConnstring.sh
* Если все прошло успешно, в консоль будут выведены ключи подключения
* Запустить сервер введя команды поочередно

    > sudo docker compose -f docker-compose.cert.yml up --build -d  
    > sudo docker compose up --build -d  

### Удаление пользователей

Допустим, вы хотите удалить пользователя, которому выдали ссылку  
> cybermesh://nginx.remotemodelstudio.com/**config_e2b1aefc-c3d8-9b27a3a9d9f1**#NAME  

Жирным в ссылке указано название файла конфигурации пользователя.  
Для удаления надо ввести:   
> rm Delicious-Kyzylyk\nginx_cybermesh_config_fileserver\share\\*название_конфига*