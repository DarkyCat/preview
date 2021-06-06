#!/bin/bash 

############################
#       ИНФОРМАЦИЯ
# Данный скрипт блокирует доступ к портам для всех, кроме разрешенных ИП-адресов.
# Посмотреть список текущих правил:
#   iptables -L -n
# Очистить правила: 
#   iptables -F
############################


# создаем новую цепочку/сеть
iptables -N bungee

# Указываем список портов для которых блокируется доступ (закрываются порты)
# Указывать порты можно как диапазоном (XXXX:XXXX), так и через запятую (XXX,XXXX,XXXX,XXXXX), а так-же можно комбинировать (XXXX,XXXX,XXXX:XXXX,XXXXXX)
# !!! Подставьте свои порты, которые вы используете вместо тех, что указаны в примере. При необходимости добавьте или удалите строки в которых указываются порты

#auth, lobby1, lobby2
iptables -I INPUT -p tcp -m multiport --dports 25530,25531,25533 -j bungee
#skywars
iptables -I INPUT -p tcp -m multiport --dports 1100:1160 -j bungee
#bedwars
iptables -I INPUT -p tcp -m multiport --dports 1200:1260 -j bungee
#mysql, redis
iptables -I INPUT -p tcp -m multiport --dports 3306,6379 -j bungee
# или например всё вместе одной командой
#   iptables -I INPUT -p tcp -m multiport --dports 25530,25531,25533,1100:1160,1200:1260,3306,6379 -j bungee


#Указываем список ип адресов, которые будут иметь доступ к портам, которые указали выше
#Все другие ип-адерса не будут иметь доступ к указанным портам
#Вместо X.X.X.X, укажите ип адреса ваших серверов. При необходимости добавьте или удалите строки
iptables -A bungee --src X.X.X.X -j ACCEPT
iptables -A bungee --src X.X.X.X -j ACCEPT
iptables -A bungee --src X.X.X.X -j ACCEPT
# Разрешаем локальный трафик (не трогаем тут ничего)
iptables -A bungee --src 127.0.0.1 -j ACCEPT
# Блокируем все остальные ИП-адреса, которые не указаны выше (ТОЖЕ НЕ ТРОГАЕМ)
iptables -A bungee -j DROP