#define FISC_ERROR_NONE               0 //нет ошибок
#define FISC_ERROR_HOST_NOT_FOUND    -1 //хост не найден
#define FISC_ERROR_SERVICE_NOT_FOUND -2 //нет такого номера порта
#define FISC_ERROR_CREATE_SOCKET     -3 //не может создать сокет
#define FISC_ERROR_CONNECT_HOST      -4 //не может соединиться с сервером
#define FISC_ERROR_SEND_HOST         -5 //не смог послать данные
#define FISC_ERROR_SEND_DATA         -6 //во время посылки сообщения разорвалось сетевое соединение
#define FISC_ERROR_READ_DATA         -7 //не смог прочитаь данные
#define FISC_ERROR_LARGE_BLOCK       -8 //размер буфера для приема данных меньше чем необходимо
#define FISC_ERROR_INVALID_HANDLE    -9 //не отрыл сервер или неправильный дескриптор
#define FISC_ERROR_NO_MORE_HANDLE   -10 //при открытии сервера закончились дескрипторы

