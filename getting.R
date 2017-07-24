library(Rfacebook)

library(tidyverse)

fb <- readxl::read_excel("fb_maidan.xlsx")
vk <- readxl::read_excel("pages_maidan.xlsx")

token <- "EAACEdEose0cBANMtiBs7ZBaCJ5AMN7q3LlQ0U5dBof7677cZCOyS1YbRZCEwCNWED9b9zT7lVgZC7u8KgXKZB9a67TNF6cGh1R4ukZAoRMJU13aS6ZBWrEti5ZBDowY0Ix2mHxdypCm2MzyYsBv7WZA0ETZBrFn2d9u4JF71imVbvqLb3Hc2lFMwIoRYtt3F8iasQZD"

example_fb <- getGroup("202155769980250",token,n = 1000)
members <- getMembers("202155769980250",token,n = 10000000)
getPage(,token,n = 10000000000000000)