library(RCurl)
library(httr)
library(RJSONIO)
library(lubridate)
library(dplyr)
library(gtools)

# функція авторизації у вк

get_access_token <- function(){
  accessURL <- "https://oauth.vk.com/access_token"
  authURL <- "https://oauth.vk.com/authorize"
  vk <- oauth_endpoint(authorize = authURL,
                       access = accessURL)
  myapp <- oauth_app(app_name, client_id, client_secret)
  ig_oauth <- oauth2.0_token(vk, myapp,  
                             type = "application/x-www-form-urlencoded",
                             cache=FALSE)
  my_session <-  strsplit(toString(names(ig_oauth$credentials)), '"')
  access_token <- paste0('access_token=', my_session[[1]][4])
  
  access_token
}

#авторизація додатка
client_id <- "5506320"
client_secret <- "POJRC0WPl6FeeQFtaoBQ"
app_name <- "analyseR"

access_token <-get_access_token()

#функція для пошуку груп
vk_group_search <- function(name){
  api <- paste0('https://api.vk.com/method/groups.search?q=',name)
  request <- paste(api, access_token, sep='&')
  region_list <- fromJSON(getURL(request))
  region_df <- as_data_frame(do.call("rbind",sapply(region_list$response,function(x) {as_data_frame(unlist(x))})))
  region_df
}

#формувалися окремі таблиці за кожним запитом 
#нюанс - слова пи салися англ транслітерацією, оскільки моя сторінка вк англомовна, то апі-пошук на кирилицю не працює, але при транслітерації результати видаються на всіх мовах

maidan <- vk_group_search("maidan")
evromaidan <- vk_group_search("evromaidan")
ato <- vk_group_search("ato")
revolutsiya <- vk_group_search("revolutsiya")
ukraina <- vk_group_search("ukraina")

#поєднання в один масив
pages_vk <- rbind(maidan,evromaidan,ato,revolutsiya,ukraina)