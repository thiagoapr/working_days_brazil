# Pacotes
library(lubridate)

# Lista de dias
days <- seq(as.Date("2005/01/01"), as.Date("2026/12/31"), by="days")
day <- day(days)
week <- wday(days)
month <- month(days)
year <- year(days)
wrkd <- data.frame(day,week, month, year)


## Feriados

# Feriados m�veis

wrkd$hd <- 0

for (i in min(year):max(year)) {		# P�scoa
  
  year.estr <- i
  
  a <- year%%19
  b <- year%/%100
  c <- year%%100
  d <- b%/%4
  e <- b%%4
  f <- (b+8)%/%25
  g <- (b-f+1)%/%3
  h <- ((19*a)+b-d-g+15)%%30
  i <- c%/%4
  k <- c%%4
  l <- (32+(2*e)+(2*i)-h-k)%%7
  m <- (a+(11*h)+(22*l))%/%451
  p <-(h+l-(7*m)+114)%%31
  
  month.estr <-(h+l-(7*m)+114)%/%31  
  day.estr <- p+1
  
  wrkd$hd[wrkd$year==year.estr & wrkd$month==month.estr & wrkd$day==day.estr] <- 999
  easter <- which(wrkd$hd==999)
  
  wrkd$hd[easter-2] <- 1			# Sexta-Feira Santa (Paix�o de Cristo)
  wrkd$hd[easter-47] <- 1			# Carnaval
  wrkd$hd[easter+60] <- 1			# Corpus Christi
  
}

# Feriados fixos

wrkd$hd[wrkd$month==1 & wrkd$day==1] <- 1		# Confraterniza��o universal 
wrkd$hd[wrkd$month==5 & wrkd$day==1] <- 1		# Dia do trabalho
wrkd$hd[wrkd$month==4 & wrkd$day==21] <- 1	# Tiradentes
wrkd$hd[wrkd$month==9 & wrkd$day==7] <- 1		# Independ�ncia
wrkd$hd[wrkd$month==10 & wrkd$day==12] <- 1	# Nossa Senhora Aparecida
wrkd$hd[wrkd$month==11 & wrkd$day==15] <- 1	# Proclama��o da Rep�blica
wrkd$hd[wrkd$month==12 & wrkd$day==25] <- 1	# Natal


# Quantidade de dias �teis por m�s

wrkd <- subset(wrkd, !(week==7 | week==1))
wrkd <- subset(wrkd, hd==0)

wrkd$wrkd <- 1
wrkd <- aggregate(wrkd ~ (month + year), wrkd, sum)

rm(days, day, month, week, year) 

wrkd.ts <- ts(wrkd$wrkd, start=c(2005,1), frequency=12)