library(RSelenium)
library(dplyr)
library(RJSONIO)
library(digest)
library(httr)
library(RCurl)

#створення симулятора браузера

rD <- rsDriver(port = as.integer(round(runif(1, 1000,9999))),browser = "chrome")
remDr <- rD[["client"]]
remDr$navigate("http://facebook.com")

#функція, що авторизує фейсбук

fb_login(login,password){
  user <- remDr$findElement(using = "id", "email")
  user$sendKeysToElement(list(login))
  pass <- remDr$findElement(using = "id", value = "pass")
  pass$sendKeysToElement(list(password))
  login <- remDr$findElement(using = "css selector", value = ".uiButton.uiButtonConfirm")
  login$clickElement()
}

#авторизація

fb_login("***","***")

#функція для пошуку груп

getdata <- function() {
  post4 <- remDr$findElements(using = "css selector", value = ".touchable.primary")
  post3 <- remDr$findElements(using = "css selector", value = ".touchable.primary")
  postLink <- unlist(lapply(post3, function(x){x$getElementAttribute("href")}))
  name2 <- unlist(lapply(post4, function(x){x$getElementText()}))
  
  return(data_frame(name2,postLink))
}

#функція для скролу сторінки

scroll <- function(x){
  i = 0
  while(i < x) { 
    page <- remDr$findElement("css", "body")
    page$sendKeysToElement(list(key = "end"))
    i  =  i + 1
  }
}

#власне, ключові слова для пошуку вписувалися в тіло посилання на сторінці пошуку після q=
#на зразок цього виразу

remDr$navigate("https://m.facebook.com/search/pages/?ssid=eaf255354fc9a6c59b727265b85d5f3a&search_source=filter&q=евромайдан")

#результати видачі скролились 500 разів (насправді, специфіка роботи симулятора така, що на практиці це менше)
scroll(500)

#після того, як скрол розгорнув повну сторінку видачі всі результати парсились у таблицю
p_evromaidan2 <- getdata()

#я створив ряд таких таблиць для кожного результату пошуку і потім їх об'єднав в одну
pages_maidan <- rbind(p_evromaidan,p_evromaidan2,p_maidan,p_revolution)

p_evromaidan #євромайдан
p_evromaidan2 #евромайдан
p_maidan #майдан
p_revolution #революція